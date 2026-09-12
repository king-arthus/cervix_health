/// Établissements de santé disposant (ou susceptibles de disposer) d'un service
/// de gynécologie-obstétrique au Tchad et au Cameroun, organisés par pays puis
/// par ville.
///
/// Source : recensement à partir de sources publiques (ministères de la santé,
/// annuaires médicaux, publications scientifiques). Liste non garantie
/// exhaustive — de nombreuses cliniques privées et petits centres de santé
/// proposent aussi des consultations de gynécologie. Il est recommandé de
/// vérifier par téléphone la disponibilité effective d'un gynécologue avant
/// de se déplacer.
class HospitalEntry {
  final String city;
  final String name;
  const HospitalEntry({required this.city, required this.name});
}

const Map<String, List<HospitalEntry>> hospitalsByCountry = {
  'Tchad': [
    HospitalEntry(city: "N'Djamena", name: "Hôpital Général de Référence Nationale (HGRN)"),
    HospitalEntry(city: "N'Djamena", name: "Centre Hospitalier Universitaire de la Mère et de l'Enfant (CHUME)"),
    HospitalEntry(city: "N'Djamena", name: "Centre Hospitalier Universitaire de la Renaissance (CHU-R)"),
    HospitalEntry(city: "N'Djamena", name: "Hôpital de N'Djamena — Le Bon Samaritain (CHU Le Bon Samaritain)"),
    HospitalEntry(city: "N'Djamena", name: "SECADEV"),
    HospitalEntry(city: "N'Djamena", name: "Hôpital de la Refondation du Tchad"),
    HospitalEntry(city: "N'Djamena", name: "Hôpital Notre Dame des Apôtres"),
    HospitalEntry(city: "N'Djamena", name: "Hôpital Spécialisé Niamey de N'Djamena"),
    HospitalEntry(city: "N'Djamena", name: "Hôpital de l'Union"),
    HospitalEntry(city: "N'Djamena", name: "Centre Médical Pasteur"),
    HospitalEntry(city: "N'Djamena", name: "Clinique Royal Internationale"),
    HospitalEntry(city: "N'Djamena", name: "Polyclinique Générale, Société Civile Professionnelle des Médecins"),
    HospitalEntry(city: "N'Djamena", name: "Clinique Vision Plus"),
    HospitalEntry(city: "N'Djamena", name: "Clinique Albasma"),
    HospitalEntry(city: "N'Djamena", name: "Clinique la Province"),
    HospitalEntry(city: "N'Djamena", name: "Clinique Hariri Internationale"),
    HospitalEntry(city: "N'Djamena", name: "Clinique SOS International / Centre Médical International"),
    HospitalEntry(city: "Moundou", name: "Hôpital Provincial de Moundou"),
    HospitalEntry(city: "Sarh", name: "Hôpital Provincial de Sarh"),
    HospitalEntry(city: "Abéché", name: "Hôpital Provincial d'Abéché"),
    HospitalEntry(city: "Bongor", name: "Hôpital Provincial de Bongor"),
    HospitalEntry(city: "Laï", name: "Hôpital Provincial de Laï"),
    HospitalEntry(city: "Koumra", name: "Hôpital Provincial de Koumra"),
    HospitalEntry(city: "Pala", name: "Hôpital Provincial de Pala"),
    HospitalEntry(city: "Doba", name: "Hôpital Provincial de Doba"),
  ],
  'Cameroun': [
    HospitalEntry(city: "Yaoundé", name: "Hôpital Gynéco-Obstétrique et Pédiatrique de Yaoundé (HGOPY)"),
    HospitalEntry(city: "Yaoundé", name: "Centre Hospitalier et Universitaire de Yaoundé (CHUY)"),
    HospitalEntry(city: "Yaoundé", name: "Hôpital Central de Yaoundé"),
    HospitalEntry(city: "Yaoundé", name: "Hôpital Général de Yaoundé"),
    HospitalEntry(city: "Yaoundé", name: "Centre Pasteur de Yaoundé"),
    HospitalEntry(city: "Douala", name: "Hôpital Gynéco-Obstétrique et Pédiatrique de Douala (HGOPED)"),
    HospitalEntry(city: "Douala", name: "Hôpital Général de Douala"),
    HospitalEntry(city: "Douala", name: "Hôpital Laquintinie"),
    HospitalEntry(city: "Douala", name: "Centre Pasteur de Douala"),
    HospitalEntry(city: "Bafoussam", name: "Centre Hospitalier Régional (CHR) de Bafoussam"),
    HospitalEntry(city: "Bamenda", name: "Hôpital Régional (HR) de Bamenda"),
    HospitalEntry(city: "Bertoua", name: "Hôpital Régional de Bertoua"),
    HospitalEntry(city: "Bertoua", name: "CHR de Bertoua"),
    HospitalEntry(city: "Buea", name: "Hôpital Régional (HR) de Buea"),
    HospitalEntry(city: "Ebolowa", name: "Hôpital Régional (HR) d'Ebolowa"),
    HospitalEntry(city: "Garoua", name: "Hôpital Régional (HR) de Garoua"),
    HospitalEntry(city: "Garoua", name: "Hôpital Général de Garoua"),
    HospitalEntry(city: "Garoua", name: "CHR de Garoua"),
    HospitalEntry(city: "Garoua", name: "Centre Pasteur annexe de Garoua"),
    HospitalEntry(city: "Maroua", name: "Hôpital Régional de Maroua (HRM)"),
    HospitalEntry(city: "Ngaoundéré", name: "Centre Hospitalier Régional de Ngaoundéré (CHRN)"),
  ],
};

/// Liste des facteurs de risque courants du cancer du col de l'utérus,
/// utilisée pour le calcul du ratio facteur d'exposition / facteur de risque.
const List<Map<String, String>> riskFactorsList = [
  {
    'fr': "Absence de dépistage au cours des 3 dernières années",
    'en': "No screening in the last 3 years",
    'ar': "عدم إجراء فحص خلال السنوات الثلاث الماضية",
  },
  {
    'fr': "Premier rapport sexuel avant l'âge de 18 ans",
    'en': "First sexual intercourse before age 18",
    'ar': "أول علاقة جنسية قبل سن 18 عامًا",
  },
  {
    'fr': "Plusieurs partenaires sexuels au cours de la vie",
    'en': "Multiple sexual partners in a lifetime",
    'ar': "تعدد الشركاء الجنسيين خلال الحياة",
  },
  {
    'fr': "Antécédent d'infection sexuellement transmissible",
    'en': "History of a sexually transmitted infection",
    'ar': "سوابق إصابة بعدوى منقولة جنسياً",
  },
  {
    'fr': "Tabagisme actuel ou passé",
    'en': "Current or past smoking",
    'ar': "التدخين حاليًا أو سابقًا",
  },
  {
    'fr': "Système immunitaire affaibli (VIH ou autre)",
    'en': "Weakened immune system (HIV or other)",
    'ar': "ضعف الجهاز المناعي (فيروس نقص المناعة أو غيره)",
  },
  {
    'fr': "Utilisation prolongée de contraceptifs oraux (plus de 5 ans)",
    'en': "Long-term use of oral contraceptives (over 5 years)",
    'ar': "استخدام طويل الأمد لموانع الحمل الفموية (أكثر من 5 سنوات)",
  },
  {
    'fr': "Antécédents familiaux de cancer du col de l'utérus",
    'en': "Family history of cervical cancer",
    'ar': "تاريخ عائلي للإصابة بسرطان عنق الرحم",
  },
  {
    'fr': "Grossesses multiples (3 accouchements ou plus)",
    'en': "Multiple pregnancies (3 or more births)",
    'ar': "حمل متعدد (3 ولادات أو أكثر)",
  },
  {
    'fr': "Faible accès aux soins de santé",
    'en': "Low access to healthcare",
    'ar': "ضعف الوصول إلى الرعاية الصحية",
  },
];
