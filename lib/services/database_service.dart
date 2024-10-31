import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/data/models/conversation.dart';
import 'package:todo/data/models/message.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/data/models/todo_user.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<TodoUser> _usersCollection;
  late final CollectionReference<Todo> _todosCollection;
  late final CollectionReference<Conversation> _conversationsCollection;

  DatabaseService() {
    _usersCollection = _firestore.collection('users').withConverter(
          fromFirestore: (snapshot, options) => TodoUser.fromFirestore(snapshot, options),
          toFirestore: (todoUser, _) => todoUser.toFirestore(),
        );
    _todosCollection = _firestore.collection('todos').withConverter(
          fromFirestore: (snapshot, options) => Todo.fromFirestore(snapshot, options),
          toFirestore: (todo, _) => todo.toFirestore(),
        );
    _conversationsCollection = _firestore.collection('conversations').withConverter(
          fromFirestore: (snapshot, options) => Conversation.fromFirestore(snapshot, options),
          toFirestore: (conversation, _) => conversation.toFirestore(),
        );
  }

  Future<void> createUserDocument({required TodoUser todoUser}) async {
    final userRef = _usersCollection.doc(todoUser.uid);
    await userRef.set(todoUser);
  }

  Future<bool> isUserNameTaken({required String userName}) async {
    final documentReference = await _usersCollection.where('userName', isEqualTo: userName).limit(1).get();
    return documentReference.docs.isNotEmpty;
  }

  Stream<TodoUser?> getUser({required String uid}) {
    return _usersCollection.doc(uid).snapshots().map((snapshot) => snapshot.data());
  }

  Future<void> updateUser({required TodoUser todoUser}) async {
    await _firestore.runTransaction((Transaction transaction) async {
      // update user document in users collection
      var userReference = _usersCollection.doc(todoUser.uid);
      transaction.update(userReference, todoUser.toFirestore());

      // update every conversation document where user is a participant
      var docs = (await _conversationsCollection.where('participantsUid', arrayContains: todoUser.uid).get()).docs;
      var conversations = docs.map((doc) => doc.data()).toList();
      var updatedConversations = conversations.map((conversation) {
        var otherUser = conversation.participants.singleWhere((user) => user.uid != todoUser.uid);
        return conversation.copyWith(participants: [todoUser, otherUser]);
      }).toList();

      for (var conversation in updatedConversations) {
        var documentReference = _conversationsCollection.doc(conversation.documentId);
        transaction.update(documentReference, conversation.toFirestore());
      }
    });
  }

  Future<void> deleteUser({required TodoUser todoUser}) async {
    await _firestore.runTransaction((Transaction transaction) async {
      // delete user document from users collection
      var userReference = _usersCollection.doc(todoUser.uid);
      transaction.delete(userReference);

      // delete every conversation of this user
      var docs = (await _conversationsCollection.where('participantsUid', arrayContains: todoUser.uid).get()).docs;
      var conversations = docs.map((doc) => doc.data()).toList();

      for (var conversation in conversations) {
        var documentReference = _conversationsCollection.doc(conversation.documentId);
        transaction.delete(documentReference);
      }

      // delete every todo owned by this user
      var todoDocs = (await _todosCollection.where('owner', isEqualTo: todoUser.userName).get()).docs;
      var todos = todoDocs.map((todoDoc) => todoDoc.data()).toList();

      for (var todo in todos) {
        var documentReference = _todosCollection.doc(todo.id);
        transaction.delete(documentReference);
      }

      // remove this user form every todo they collaborated on
      var collaboratedOnTodosDocs = (await _todosCollection.where('collaborators', arrayContains: todoUser.userName).get()).docs;
      var collaboratedOnTodos = collaboratedOnTodosDocs.map((todoDoc) => todoDoc.data()).toList();
      var collaborationRemovedTodos = collaboratedOnTodos.map((collaboratedOnTodo) {
        return collaboratedOnTodo.copyWith(collaborators: collaboratedOnTodo.collaborators.where((userName) => userName != todoUser.userName).toList());
      }).toList();

      for (var collaborationRemovedTodo in collaborationRemovedTodos) {
        var documentReference = _todosCollection.doc(collaborationRemovedTodo.id);
        transaction.update(documentReference, collaborationRemovedTodo.toFirestore());
      }
    });
  }

  Stream<List<Todo>> getTodos({required String userName}) {
    return _todosCollection.where('collaborators', arrayContains: userName).orderBy('createdAt').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      },
    );
  }

  Stream<Todo> getTodo({required String id}) {
    return _todosCollection.doc(id).snapshots().map((snapshot) => snapshot.data()!);
  }

  Future<void> addtodo({required Todo todo}) async {
    final docRef = _todosCollection.doc();

    await docRef.set(todo.copyWith(id: docRef.id));
  }

  Future<void> editTodo({required Todo todo}) async {
    await _todosCollection.doc(todo.id).set(todo);
  }

  Future<void> pinTodo({required String todoId, required String userName}) async {
    await _todosCollection.doc(todoId).update({
      "pinnedBy": FieldValue.arrayUnion([userName]),
    });
  }

  Future<void> unpinTodo({required String todoId, required String userName}) async {
    await _todosCollection.doc(todoId).update({
      "pinnedBy": FieldValue.arrayRemove([userName]),
    });
  }

  Future<void> deleteTodo({required String todoId}) async {
    await _todosCollection.doc(todoId).delete();
  }

  Future<List<TodoUser>> searchUser({required String query}) async {
    if (query.isEmpty) return [];
    return (await _usersCollection.where('userName', isGreaterThanOrEqualTo: query).where('userName', isLessThanOrEqualTo: '$query\uf8ff').get())
        .docs
        .map((doc) => doc.data())
        .toList();
  }

  Future<void> addCollaborator({required String todoId, required String userName}) async {
    await _todosCollection.doc(todoId).update({
      "collaborators": FieldValue.arrayUnion([userName]),
    });
  }

  Stream<List<Conversation>> getConverstations({required String uid}) {
    return _conversationsCollection.where('participantsUid', arrayContains: uid).orderBy('lastMessage.timestamp', descending: true).snapshots().map(
      (querySnapshot) {
        return querySnapshot.docs.map(
          (documentSnapshot) {
            return documentSnapshot.data();
          },
        ).toList();
      },
    );
  }

  Stream<List<Message>> getMessages({required String conversationId}) {
    final messagesRef = _conversationsCollection.doc(conversationId).collection('messages').withConverter(
          fromFirestore: (snapshot, options) => Message.fromFirestore(snapshot, options),
          toFirestore: (message, options) => message.toFirestore(),
        );
    return messagesRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  Future<void> sendMessage({required Conversation conversation, required Message message}) async {
    final batch = _firestore.batch();

    final conversationRef = _conversationsCollection.doc(conversation.documentId);
    batch.set<Conversation>(conversationRef, conversation);

    final messageRef = _conversationsCollection.doc(conversation.documentId).collection('messages').doc(message.messageId);
    batch.set(messageRef, message.toFirestore());

    batch.commit();
  }

  Future<void> markMessageRead({required String conversationId, required Message message}) async {
    await _firestore.runTransaction((Transaction transaction) async {
      var conversationRef = _conversationsCollection.doc(conversationId);
      var messageRef = _conversationsCollection.doc(conversationId).collection('messages').doc(message.messageId);

      var conversation = (await transaction.get(conversationRef)).data();

      if (conversation != null) {
        transaction.set(
        messageRef,
        <String, dynamic>{'read': true},
        SetOptions(merge: true),
      );
      if (conversation.lastMessage.messageId == message.messageId) {
        transaction.set(
          conversationRef,
          conversation.copyWith(lastMessage: message.copyWith(read: true)),
          SetOptions(merge: true),
        );
      }
      }
      
    });
  }
}
