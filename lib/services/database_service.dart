import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/data/models/todo_user.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<TodoUser> _usersCollection;
  late final CollectionReference _userNamesCollection;
  late final CollectionReference<Todo> _todosCollection;

  DatabaseService() {
    _usersCollection = _firestore.collection('users').withConverter(
          fromFirestore: (snapshot, options) => TodoUser.fromFirestore(snapshot, options),
          toFirestore: (todoUser, _) => todoUser.toFirestore(),
        );
    _userNamesCollection = _firestore.collection('userNames');
    _todosCollection = _firestore.collection('todos').withConverter(
          fromFirestore: (snapshot, options) => Todo.fromFirestore(snapshot, options),
          toFirestore: (todo, _) => todo.toFirestore(),
        );
  }

  Future<void> createUserDocument({required TodoUser todoUser}) async {
    final batch = _firestore.batch();

    // set username in userNames collection
    DocumentReference userNameRef = _userNamesCollection.doc(todoUser.userName);
    batch.set(
      userNameRef,
      {'uid': todoUser.uid, 'userName': todoUser.userName},
    );

    // add user to users collection
    final userRef = _usersCollection.doc(todoUser.uid);
    batch.set<TodoUser>(userRef, todoUser);

    batch.commit();
  }

  Future<bool> isUserNameTaken({required String userName}) async {
    final documentReference = await _userNamesCollection.doc(userName).get();
    return documentReference.exists;
  }

  Stream<TodoUser?> getUser({required String uid}) {
    return _usersCollection.doc(uid).snapshots().map((snapshot) => snapshot.data());
  }

  Future<void> updateUser({required TodoUser todoUser}) async {
    await _usersCollection.doc(todoUser.uid).set(todoUser);
  }

  Future<void> deleteUser({required TodoUser todoUser}) async {
    final batch = _firestore.batch();

    // delete user document
    final DocumentReference<TodoUser> userDocRef = _usersCollection.doc(todoUser.uid);
    batch.delete(userDocRef);

    // delete user name from user names collection

    final DocumentReference userNameDocRef = _userNamesCollection.doc(todoUser.userName);
    batch.delete(userNameDocRef);

    batch.commit();
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
}
