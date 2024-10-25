import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/data/models/todo_user.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<TodoUser> _usersCollection;
  late final CollectionReference _userNamesCollection;

  DatabaseService() {
    _usersCollection = _firestore.collection('users').withConverter(
          fromFirestore: (snapshot, options) => TodoUser.fromFirestore(snapshot, options),
          toFirestore: (todoUser, _) => todoUser.toFirestore(),
        );
    _userNamesCollection = _firestore.collection('userNames');
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
}
