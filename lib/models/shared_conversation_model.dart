/// Représente le partage volontaire d'une conversation entre un agent et un
/// spécialiste avec la patiente concernée, à leur initiative. La conversation
/// originale reste privée entre les deux professionnels ; seule une "vue en
/// lecture seule" est rendue accessible à la patiente choisie.
class SharedConversation {
  final String id;
  final String agentId;
  final String agentName;
  final String specialistId;
  final String specialistName;
  final String patientId;
  final String patientName;
  final DateTime sharedAt;
  final String sharedByName;

  SharedConversation({
    required this.id,
    required this.agentId,
    required this.agentName,
    required this.specialistId,
    required this.specialistName,
    required this.patientId,
    required this.patientName,
    required this.sharedAt,
    required this.sharedByName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'agentId': agentId,
        'agentName': agentName,
        'specialistId': specialistId,
        'specialistName': specialistName,
        'patientId': patientId,
        'patientName': patientName,
        'sharedAt': sharedAt.toIso8601String(),
        'sharedByName': sharedByName,
      };

  factory SharedConversation.fromJson(Map<String, dynamic> json) => SharedConversation(
        id: json['id'],
        agentId: json['agentId'],
        agentName: json['agentName'],
        specialistId: json['specialistId'],
        specialistName: json['specialistName'],
        patientId: json['patientId'],
        patientName: json['patientName'],
        sharedAt: DateTime.parse(json['sharedAt']),
        sharedByName: json['sharedByName'],
      );
}
