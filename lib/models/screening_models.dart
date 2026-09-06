enum ScreeningStatus { enAttente, planifie, realise, annule }

String screeningStatusLabel(ScreeningStatus status, String Function(String) t) {
  switch (status) {
    case ScreeningStatus.enAttente:
      return t('status_pending');
    case ScreeningStatus.planifie:
      return t('status_scheduled');
    case ScreeningStatus.realise:
      return t('status_done');
    case ScreeningStatus.annule:
      return t('status_cancelled');
  }
}

class ScreeningRequest {
  final String id;
  final String patientId;
  final String patientName;
  final String hospital;
  final String? assignedPersonnelId;
  final DateTime requestDate;
  ScreeningStatus status;

  // Renseignés une fois le dépistage réalisé (côté personnel)
  String? techniqueUsed;
  String? result; // positif / négatif / douteux -> saisi manuellement pour l'instant
  DateTime? nextAppointmentDate;
  // NOTE: l'analyse assistée par IA des images VIA/VILI sera ajoutée ultérieurement.

  ScreeningRequest({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.hospital,
    this.assignedPersonnelId,
    required this.requestDate,
    this.status = ScreeningStatus.enAttente,
    this.techniqueUsed,
    this.result,
    this.nextAppointmentDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'patientName': patientName,
        'hospital': hospital,
        'assignedPersonnelId': assignedPersonnelId,
        'requestDate': requestDate.toIso8601String(),
        'status': status.name,
        'techniqueUsed': techniqueUsed,
        'result': result,
        'nextAppointmentDate': nextAppointmentDate?.toIso8601String(),
      };

  factory ScreeningRequest.fromJson(Map<String, dynamic> json) => ScreeningRequest(
        id: json['id'],
        patientId: json['patientId'],
        patientName: json['patientName'],
        hospital: json['hospital'],
        assignedPersonnelId: json['assignedPersonnelId'],
        requestDate: DateTime.parse(json['requestDate']),
        status: ScreeningStatus.values.firstWhere((e) => e.name == json['status'],
            orElse: () => ScreeningStatus.enAttente),
        techniqueUsed: json['techniqueUsed'],
        result: json['result'],
        nextAppointmentDate: json['nextAppointmentDate'] != null
            ? DateTime.parse(json['nextAppointmentDate'])
            : null,
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
