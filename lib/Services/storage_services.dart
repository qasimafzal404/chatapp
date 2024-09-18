import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageServices {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Constructor
  StorageServices();

  // Method to upload user profile picture
  Future<String?> uploadUserPfp({
    required File file,
    required String uid,
  }) async {
    try {
      // Create a reference to the  file location in Firebase Storage
      Reference fileRef = _firebaseStorage
          .ref('users/pfp')
          .child('$uid${p.extension(file.path)}');

      // Start the file upload
      UploadTask task = fileRef.putFile(file);

      // Wait for the upload task to complete and return the download URL if successful
      TaskSnapshot snapshot = await task;
      if (snapshot.state == TaskState.success) {
        return await fileRef.getDownloadURL();
      }
    } catch (e) {
      print("Error uploading profile picture: $e");
      return null;
    }
  }
}
