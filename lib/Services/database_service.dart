import 'package:chatapp/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? userCollection;
  DatabaseService() {
    _setupCollectionRefrence();
  }

  void _setupCollectionRefrence() {
    userCollection = _firebaseFirestore.collection('users').withConverter<UserProfile>(
        fromFirestore: (snapshots, _) => UserProfile.fromJson(snapshots.data()!),
        toFirestore: (userProfile, _) => userProfile.toJson());
  }
  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await userCollection?.doc(userProfile.uid).set(userProfile);
}
}