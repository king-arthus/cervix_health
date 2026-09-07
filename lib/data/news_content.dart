/// Actualités et ressources factuelles sur le cancer du col de l'utérus,
/// basées sur des communications publiques de l'OMS et de l'UNICEF.
/// Contenu à mettre à jour périodiquement à mesure que la situation évolue.
class NewsItem {
  final Map<String, String> title;
  final Map<String, String> summary;
  final String source;
  final String date;
  final String url;

  const NewsItem({
    required this.title,
    required this.summary,
    required this.source,
    required this.date,
    required this.url,
  });
}

const List<NewsItem> cervicalCancerNews = [
  NewsItem(
    source: 'OMS',
    date: '2020',
    url: 'https://www.who.int/fr/news/item/17-11-2020-a-cervical-cancer-free-future-first-ever-global-commitment-to-eliminate-a-cancer',
    title: {
      'fr': 'Un engagement mondial historique pour éliminer le cancer du col de l\'utérus',
      'en': 'A historic global commitment to eliminate cervical cancer',
      'ar': 'التزام عالمي تاريخي للقضاء على سرطان عنق الرحم',
    },
    summary: {
      'fr': 'Pour la première fois, 194 pays se sont engagés à éliminer un cancer. La stratégie mondiale de l\'OMS repose sur trois piliers : vaccination, dépistage et traitement. Bien appliquée, elle pourrait réduire les nouveaux cas de plus de 40 % et éviter 5 millions de décès d\'ici 2050.',
      'en': 'For the first time, 194 countries have committed to eliminating a cancer. The WHO global strategy rests on three pillars: vaccination, screening and treatment. If well implemented, it could cut new cases by over 40% and prevent 5 million deaths by 2050.',
      'ar': 'لأول مرة، التزمت 194 دولة بالقضاء على أحد أنواع السرطان. تقوم استراتيجية منظمة الصحة العالمية على ثلاث ركائز: التطعيم، الفحص، والعلاج. إذا طُبّقت بشكل جيد، يمكنها خفض الحالات الجديدة بأكثر من 40٪ ومنع 5 ملايين حالة وفاة بحلول عام 2050.',
    },
  ),
  NewsItem(
    source: 'OMS — Fiche d\'information',
    date: '2026',
    url: 'https://www.who.int/fr/news-room/fact-sheets/detail/cervical-cancer',
    title: {
      'fr': 'Un objectif chiffré : moins de 4 cas pour 100 000 femmes',
      'en': 'A measurable target: fewer than 4 cases per 100,000 women',
      'ar': 'هدف قابل للقياس: أقل من 4 حالات لكل 100 ألف امرأة',
    },
    summary: {
      'fr': 'L\'OMS considère le cancer du col de l\'utérus éliminé en tant que problème de santé publique lorsque son incidence descend sous 4 nouveaux cas pour 100 000 femmes par an. Selon les projections, atteindre cet objectif éviterait 74 millions de nouveaux cas et 62 millions de décès d\'ici 2120. Le 17 novembre marque chaque année la Journée mondiale pour l\'élimination du cancer du col de l\'utérus.',
      'en': 'WHO considers cervical cancer eliminated as a public health problem once incidence falls below 4 new cases per 100,000 women per year. Projections suggest reaching this goal would avoid 74 million new cases and 62 million deaths by 2120. November 17 marks World Cervical Cancer Elimination Day each year.',
      'ar': 'تعتبر منظمة الصحة العالمية أن سرطان عنق الرحم قد تم القضاء عليه كمشكلة صحة عامة عندما ينخفض معدل الإصابة إلى أقل من 4 حالات جديدة لكل 100 ألف امرأة سنويًا. تشير التوقعات إلى أن بلوغ هذا الهدف سيجنب 74 مليون حالة جديدة و62 مليون حالة وفاة بحلول عام 2120. يُحتفل في 17 نوفمبر من كل عام باليوم العالمي للقضاء على سرطان عنق الرحم.',
    },
  ),
  NewsItem(
    source: 'OMS / UNICEF — Forum mondial',
    date: '2024',
    url: 'https://www.who.int/fr/initiatives/cervical-cancer-elimination-initiative/cervical-cancer-forum/commitments',
    title: {
      'fr': 'Près de 600 millions de dollars engagés lors du premier Forum mondial',
      'en': 'Nearly \$600 million pledged at the first Global Forum',
      'ar': 'التعهد بنحو 600 مليون دولار في المنتدى العالمي الأول',
    },
    summary: {
      'fr': 'De nouveaux engagements nationaux et un financement de près de 600 millions de dollars ont été annoncés pour accélérer la vaccination, le dépistage et le traitement. Le conseil de Gavi étudie par ailleurs des plans 2026-2030 pour élargir l\'accès au vaccin HPV à davantage de filles et de jeunes femmes.',
      'en': 'New national commitments and nearly \$600 million in funding were announced to accelerate vaccination, screening and treatment. Gavi\'s board is also considering 2026-2030 plans to expand HPV vaccine access to more girls and young women.',
      'ar': 'أُعلن عن التزامات وطنية جديدة وتمويل بقرابة 600 مليون دولار لتسريع التطعيم والفحص والعلاج. كما ينظر مجلس إدارة "غافي" في خطط 2026-2030 لتوسيع نطاق الوصول إلى لقاح فيروس الورم الحليمي لمزيد من الفتيات والشابات.',
    },
  ),
  NewsItem(
    source: 'OMS Europe',
    date: 'Janvier 2025',
    url: 'https://www.who.int/europe/fr/news/item/27-01-2025-cervical-cancer-elimination--progress-evident--but-tragically-slow',
    title: {
      'fr': 'Des progrès réels, mais encore trop lents',
      'en': 'Real progress, but still too slow',
      'ar': 'تقدم حقيقي، لكنه لا يزال بطيئًا جدًا',
    },
    summary: {
      'fr': 'Grâce aux efforts de vaccination contre le HPV et au renforcement du dépistage, l\'élimination du cancer du col de l\'utérus n\'est plus un objectif lointain mais un but atteignable. L\'OMS souligne cependant que le rythme des progrès reste trop lent dans de nombreuses régions et appelle à une action redoublée.',
      'en': 'Thanks to HPV vaccination efforts and stronger screening, eliminating cervical cancer is no longer a distant goal but an achievable one. WHO nonetheless stresses that progress remains too slow in many regions and calls for renewed action.',
      'ar': 'بفضل جهود التطعيم ضد فيروس الورم الحليمي وتعزيز الفحص، لم يعد القضاء على سرطان عنق الرحم هدفًا بعيد المنال بل أصبح قابلاً للتحقيق. ومع ذلك، تؤكد منظمة الصحة العالمية أن وتيرة التقدم لا تزال بطيئة جدًا في العديد من المناطق وتدعو إلى مضاعفة الجهود.',
    },
  ),
];
