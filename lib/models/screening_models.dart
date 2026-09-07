enum ScreeningStatus { enAttente, planifie, depiste, oriente, valide, annule }

String screeningStatusLabel(ScreeningStatus status, String Function(String) t) {
  switch (status) {
    case ScreeningStatus.enAttente:
      return t('status_pending');
    case ScreeningStatus.planifie:
      return t('status_scheduled');
    case ScreeningStatus.depiste:
      return t('status_screened');
    case ScreeningStatus.oriente:
      return t('status_referred');
    case ScreeningStatus.valide:
      return t('status_validated');
    case ScreeningStatus.annule:
      return t('status_cancelled');
  }
}

/// Représente le dossier de dépistage d'une patiente, de sa création par la
/// patiente jusqu'à la validation par un spécialiste, en passant par la
/// réalisation du dépistage par un agent de santé.
class ScreeningRequest {
  final String id;
  final String patientId;
  final String patientName;
  final String hospital;
  final DateTime requestDate;
  ScreeningStatus status;

  DateTime? nextAppointmentDate;

  // Renseigné par l'agent de santé lors du dépistage
  String? agentId;
  String? agentName;
  String? viaResult; // positif / négatif / douteux
  String? viliResult; // positif / négatif / douteux
  String? observations;

  // Renseigné lors de l'orientation vers un spécialiste
  String? specialistId;
  String? specialistName;

  // Renseigné par le spécialiste lors de la validation
  String? conclusion;
  DateTime? validationDate;
  // NOTE : l'analyse assistée par IA des images VIA/VILI sera ajoutée ultérieurement.

  ScreeningRequest({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.hospital,
    required this.requestDate,
    this.status = ScreeningStatus.enAttente,
    this.nextAppointmentDate,
    this.agentId,
    this.agentName,
    this.viaResult,
    this.viliResult,
    this.observations,
    this.specialistId,
    this.specialistName,
    this.conclusion,
    this.validationDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'patientName': patientName,
        'hospital': hospital,
        'requestDate': requestDate.toIso8601String(),
        'status': status.name,
        'nextAppointmentDate': nextAppointmentDate?.toIso8601String(),
        'agentId': agentId,
        'agentName': agentName,
        'viaResult': viaResult,
        'viliResult': viliResult,
        'observations': observations,
        'specialistId': specialistId,
        'specialistName': specialistName,
        'conclusion': conclusion,
        'validationDate': validationDate?.toIso8601String(),
      };

  factory ScreeningRequest.fromJson(Map<String, dynamic> json) => ScreeningRequest(
        id: json['id'],
        patientId: json['patientId'],
        patientName: json['patientName'],
        hospital: json['hospital'],
        requestDate: DateTime.parse(json['requestDate']),
        status: ScreeningStatus.values.firstWhere((e) => e.name == json['status'],
            orElse: () => ScreeningStatus.enAttente),
        nextAppointmentDate: json['nextAppointmentDate'] != null
            ? DateTime.parse(json['nextAppointmentDate'])
            : null,
        agentId: json['agentId'],
        agentName: json['agentName'],
        viaResult: json['viaResult'] ?? json['result'],
        viliResult: json['viliResult'],
        observations: json['observations'],
        specialistId: json['specialistId'],
        specialistName: json['specialistName'],
        conclusion: json['conclusion'],
        validationDate: json['validationDate'] != null ? DateTime.parse(json['validationDate']) : null,
      );
}

class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'senderName': senderName,
        'receiverId': receiverId,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        senderId: json['senderId'],
        senderName: json['senderName'],
        receiverId: json['receiverId'],
        text: json['text'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  /// Identifiant unique de la conversation entre deux utilisateurs (ordre indépendant)
  static String conversationId(String a, String b) {
    final ids = [a, b]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}

class CommunityPost {
  final String id;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime timestamp;

  CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorId': authorId,
        'authorName': authorName,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
      };

  factory CommunityPost.fromJson(Map<String, dynamic> json) => CommunityPost(
        id: json['id'],
        authorId: json['authorId'],
        authorName: json['authorName'],
        text: json['text'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
