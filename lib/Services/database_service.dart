import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final GetIt _getIt = GetIt.instance;
 late AuthServices _authServices;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? userCollection;
  DatabaseService() {
    _authServices = _getIt.get<AuthServices>();
    _setupCollectionRefrence();
  }

  void _setupCollectionRefrence() {
    userCollection = _firebaseFirestore
        .collection('users')
        .withConverter<UserProfile>(
            fromFirestore: (snapshots, _) =>
                UserProfile.fromJson(snapshots.data()!),
            toFirestore: (userProfile, _) => userProfile.toJson());
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await userCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfile() {
    return userCollection
        ?.where("uid", isNotEqualTo: _authServices.user()?.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }
}
