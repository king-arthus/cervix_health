enum UserRole { patient, agent, specialiste, admin }

UserRole userRoleFromString(String value) {
  switch (value) {
    case 'agent':
      return UserRole.agent;
    case 'specialiste':
      return UserRole.specialiste;
    case 'admin':
      return UserRole.admin;
    default:
      return UserRole.patient;
  }
}

class AppUser {
  final String id; // Correspond au "localId" (UID) retourné par Firebase Authentication
  final String email;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String contact;
  final UserRole role;

  // Champs spécifiques à l'agent de santé et au spécialiste
  final String? employerFacility;
  final int? startYear;
  final String? position;
  final String? educationLevel;
  final String? specialty; // spécifique au spécialiste (ex. anatomopathologie, gynécologie)
  final String? photoBase64;

  AppUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.contact,
    required this.role,
    this.employerFacility,
    this.startYear,
    this.position,
    this.educationLevel,
    this.specialty,
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
        role: role,
        employerFacility: employerFacility,
        startYear: startYear,
        position: position,
        educationLevel: educationLevel,
        specialty: specialty,
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
        'role': role.name,
        'employerFacility': employerFacility,
        'startYear': startYear,
        'position': position,
        'educationLevel': educationLevel,
        'specialty': specialty,
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
        role: userRoleFromString(json['role'] ?? json['profileType'] ?? 'patient'),
        employerFacility: json['employerFacility'],
        startYear: json['startYear'],
        position: json['position'],
        educationLevel: json['educationLevel'],
        specialty: json['specialty'],
        photoBase64: json['photoBase64'],
      );
}
