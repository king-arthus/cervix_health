enum ProfileType { patient, personnel }

ProfileType profileTypeFromString(String value) {
  return value == 'personnel' ? ProfileType.personnel : ProfileType.patient;
}

class AppUser {
  final String id; // Correspond au "localId" (UID) retourné par Firebase Authentication
  final String email;
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
  final String? photoBase64;

  AppUser({
    required this.id,
    required this.email,
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
    this.photoBase64,
  });

  /// Retourne une copie de l'utilisateur avec la photo de profil modifiée.
  AppUser copyWithPhoto(String? newPhotoBase64) => AppUser(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        age: age,
        gender: gender,
        contact: contact,
        profileType: profileType,
        employerFacility: employerFacility,
        startYear: startYear,
        position: position,
        educationLevel: educationLevel,
        photoBase64: newPhotoBase64,
      );

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
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
        'photoBase64': photoBase64,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'],
        email: json['email'],
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
        photoBase64: json['photoBase64'],
      );
}
