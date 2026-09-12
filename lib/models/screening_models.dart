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

  /// Contrôle si les détails cliniques (VIA/VILI, observations, conclusion) sont
  /// visibles par la patiente. Confidentiel par défaut ; activé explicitement par
  /// l'agent ou le spécialiste depuis leur écran de dossier.
  bool sharedWithPatient;

  /// Photos ou documents joints (ex. images d'examen VIA/VILI) visibles par
  /// l'agent et le spécialiste. Limitées en nombre pour ne pas alourdir la
  /// synchronisation (voir écran d'ajout).
  List<DossierAttachment> attachments;

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
    this.sharedWithPatient = false,
    List<DossierAttachment>? attachments,
  }) : attachments = attachments ?? [];

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
        'sharedWithPatient': sharedWithPatient,
        'attachments': attachments.map((a) => a.toJson()).toList(),
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
        sharedWithPatient: json['sharedWithPatient'] == true,
        attachments: (json['attachments'] as List?)
                ?.map((a) => DossierAttachment.fromJson(Map<String, dynamic>.from(a)))
                .toList() ??
            [],
      );
}

class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final String? sharedWithPatientId;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.sharedWithPatientId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'senderName': senderName,
        'receiverId': receiverId,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'sharedWithPatientId': sharedWithPatientId,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        senderId: json['senderId'],
        senderName: json['senderName'],
        receiverId: json['receiverId'],
        text: json['text'],
        timestamp: DateTime.parse(json['timestamp']),
        sharedWithPatientId: json['sharedWithPatientId'],
      );

  /// Identifiant unique de la conversation entre deux utilisateurs (ordre indépendant)
  static String conversationId(String a, String b) {
    final ids = [a, b]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}

/// Pièce jointe attachée à un dossier de dépistage (photo d'examen VIA/VILI,
/// document, etc.), encodée en base64. À utiliser avec parcimonie : chaque
/// pièce jointe alourdit la taille du dossier synchronisé.
class DossierAttachment {
  final String id;
  final String fileName;
  final String mimeType; // ex. 'image/jpeg', 'application/pdf'
  final String base64Data;
  final String addedByName;
  final DateTime addedAt;

  DossierAttachment({
    required this.id,
    required this.fileName,
    required this.mimeType,
    required this.base64Data,
    required this.addedByName,
    required this.addedAt,
  });

  bool get isImage => mimeType.startsWith('image/');

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileName': fileName,
        'mimeType': mimeType,
        'base64Data': base64Data,
        'addedByName': addedByName,
        'addedAt': addedAt.toIso8601String(),
      };

  factory DossierAttachment.fromJson(Map<String, dynamic> json) => DossierAttachment(
        id: json['id'],
        fileName: json['fileName'],
        mimeType: json['mimeType'],
        base64Data: json['base64Data'],
        addedByName: json['addedByName'],
        addedAt: DateTime.parse(json['addedAt']),
      );
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
