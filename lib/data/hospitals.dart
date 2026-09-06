/// Liste indicative des établissements de santé au Tchad pratiquant le dépistage
/// du cancer du col de l'utérus, des hôpitaux provinciaux aux hôpitaux de référence.
/// À remplacer/compléter par une source officielle (ministère de la Santé publique) en production.
const List<String> chadScreeningHospitals = [
  "Hôpital Général de Référence Nationale (HGRN) - N'Djaména",
  "Hôpital de la Mère et de l'Enfant - N'Djaména",
  "Hôpital Provincial de Moundou",
  "Hôpital Provincial de Sarh",
  "Hôpital Provincial d'Abéché",
  "Hôpital Provincial de Doba",
  "Hôpital Provincial de Bongor",
  "Hôpital Provincial de Mongo",
  "Hôpital Provincial d'Am Timan",
  "Hôpital Provincial de Kélo",
  "Hôpital Provincial de Pala",
  "Hôpital Provincial de Laï",
  "Hôpital Provincial de Faya-Largeau",
  "Hôpital Régional de Bol",
  "Centre Hospitalier Universitaire de Référence Nationale (CHU-RN)",
  "Hôpital de l'Amitié Tchad-Chine",
];

/// Liste des facteurs de risque courants du cancer du col de l'utérus,
/// utilisée pour le calcul du ratio facteur d'exposition / facteur de risque.
/// Clé = identifiant de traduction, à ajouter dans app_strings.dart si besoin d'affichage détaillé.
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
