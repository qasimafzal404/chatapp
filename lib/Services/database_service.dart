import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/models/chat.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:chatapp/utils.dart';

class DatabaseService {

  final GetIt _getIt = GetIt.instance;
 late AuthServices _authServices;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? userCollection;
    CollectionReference? chatCollection;
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

  chatCollection = _firebaseFirestore
        .collection('chats')
        .withConverter<Chat>(
            fromFirestore: (snapshots, _) =>
                Chat.fromJson(snapshots.data()!),
                toFirestore: (chat, _) => chat.toJson());
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await userCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfile() {
    return userCollection
        ?.where("uid", isNotEqualTo: _authServices.user()?.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;

        }

   Future<bool> checkChatExists(String uid1 , String uid2) async{
          String chatID = generateChatID(uid1: uid1 , uid2: uid2);
          final result = await chatCollection?.doc(chatID).get();
          if(result != null)
          {
            return result.exists;
          }
          return false;
        }

  Future<void> createNewChat(String uid1 , String uid2)async{
    String chatID = generateChatID(uid1: uid1 , uid2: uid2);
    final docRef = chatCollection!.doc(chatID);
    final chat = Chat(
      id: chatID,
      participants: [uid1 , uid2],
      messages: [],
    );
    await docRef.set(chat);
  }
}
