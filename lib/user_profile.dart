class UserProfile {
  final String id;
  String? name;
  String? height;
  String? weight;
  String? gender;
  String? dateOfBirth;
  String? gymFrequency;
  String? goals;
  bool notifyInApp;
  bool notifyEmail;

  UserProfile({
    required this.id,
    this.name,
    this.height,
    this.weight,
    this.gender,
    this.dateOfBirth,
    this.gymFrequency,
    this.goals,
    this.notifyInApp = false,
    this.notifyEmail = false,
  });
}
