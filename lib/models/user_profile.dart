class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;

  UserProfile({
    required this.uid,
    required this.name,
    required this.pfpURL,
  });

  // Create an instance of UserProfile from JSON data
  UserProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    pfpURL = json['pfpURL'];
  }

  // Convert a UserProfile object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; // Corrected syntax
    data['uid'] = uid;
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    return data;
  }
}
