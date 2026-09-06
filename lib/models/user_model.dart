enum ProfileType { patient, personnel }

ProfileType profileTypeFromString(String value) {
  return value == 'personnel' ? ProfileType.personnel : ProfileType.patient;
}

class AppUser {
  final String id;
  final String username;
  final String password; // NB: en production, ne jamais stocker en clair -> hasher côté backend
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String contact;
  final ProfileType profileType;

  // Champs spécifiques au personnel de santé
  final String? employerFacility;
  final int? startYear;
  final String? position;
  final String? educationLevel;

  AppUser({
    required this.id,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.contact,
    required this.profileType,
    this.employerFacility,
    this.startYear,
    this.position,
    this.educationLevel,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'gender': gender,
        'contact': contact,
        'profileType': profileType.name,
        'employerFacility': employerFacility,
        'startYear': startYear,
        'position': position,
        'educationLevel': educationLevel,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'],
        username: json['username'],
        password: json['password'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        age: json['age'],
        gender: json['gender'],
        contact: json['contact'],
        profileType: profileTypeFromString(json['profileType']),
        employerFacility: json['employerFacility'],
        startYear: json['startYear'],
        position: json['position'],
        educationLevel: json['educationLevel'],
      );
}
