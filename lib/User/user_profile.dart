class UserProfile {
  String id;
  String name;
  String age;
  String height;
  String weight;
  String gender;
  String gymFrequency;

  UserProfile({
    required this.id, // Require the Firebase user ID
    this.name = '',
    this.age = '',
    this.height = '',
    this.weight = '',
    this.gender = '',
    this.gymFrequency = '',
  });
}
