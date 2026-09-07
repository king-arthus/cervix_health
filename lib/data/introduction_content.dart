/// Contenu de l'introduction, structuré en chapitres et sous-chapitres,
/// pour les profils patiente et personnel de santé, en trois langues.
class IntroSubchapter {
  final Map<String, String> subtitle;
  final Map<String, String> body;
  const IntroSubchapter({required this.subtitle, required this.body});
}

class IntroChapter {
  final Map<String, String> title;
  final Map<String, String>? body;
  final List<IntroSubchapter>? subchapters;
  const IntroChapter({required this.title, this.body, this.subchapters});
}

// ============================= PATIENTE =============================

const List<IntroChapter> patientIntroChapters = [
  IntroChapter(
    title: {
      'fr': '1. Comprendre le cancer du col de l\'utérus',
      'en': '1. Understanding cervical cancer',
      'ar': '1. فهم سرطان عنق الرحم',
    },
    subchapters: [
      IntroSubchapter(
        subtitle: {'fr': '1.1 Qu\'est-ce que le col de l\'utérus ?', 'en': '1.1 What is the cervix?', 'ar': '1.1 ما هو عنق الرحم؟'},
        body: {
          'fr': 'Le col de l\'utérus est la partie basse et étroite de l\'utérus, qui fait le lien avec le vagin. C\'est une zone facilement accessible lors d\'un examen, ce qui rend le dépistage simple à réaliser.',
          'en': 'The cervix is the lower, narrow part of the uterus, connecting it to the vagina. It is an area easily accessible during an examination, which makes screening simple to perform.',
          'ar': 'عنق الرحم هو الجزء السفلي الضيق من الرحم، ويربطه بالمهبل. وهو منطقة يسهل الوصول إليها أثناء الفحص، مما يجعل إجراء الفحص أمرًا بسيطًا.',
        },
      ),
      IntroSubchapter(
        subtitle: {'fr': '1.2 Comment ce cancer se développe', 'en': '1.2 How this cancer develops', 'ar': '1.2 كيف يتطور هذا السرطان'},
        body: {
          'fr': 'Contrairement à beaucoup d\'autres cancers, celui du col de l\'utérus évolue très lentement : entre 10 et 20 ans séparent souvent l\'infection initiale de l\'apparition d\'un cancer. Cette lenteur laisse une large fenêtre pour le détecter et le traiter avant qu\'il ne devienne dangereux.',
          'en': 'Unlike many other cancers, cervical cancer develops very slowly: often 10 to 20 years pass between the initial infection and the appearance of cancer. This slow progression leaves a wide window to detect and treat it before it becomes dangerous.',
          'ar': 'على عكس العديد من أنواع السرطان الأخرى، يتطور سرطان عنق الرحم ببطء شديد: غالبًا ما تفصل 10 إلى 20 عامًا بين العدوى الأولية وظهور السرطان. يترك هذا البطء نافذة واسعة لاكتشافه وعلاجه قبل أن يصبح خطيرًا.',
        },
      ),
    ],
  ),
  IntroChapter(
    title: {
      'fr': '2. Le papillomavirus humain (HPV)',
      'en': '2. Human papillomavirus (HPV)',
      'ar': '2. فيروس الورم الحليمي البشري',
    },
    subchapters: [
      IntroSubchapter(
        subtitle: {'fr': '2.1 Un virus très répandu', 'en': '2.1 A very common virus', 'ar': '2.1 فيروس شائع جدًا'},
        body: {
          'fr': 'Le HPV est un virus courant qui se transmet par contact sexuel. La grande majorité des personnes sexuellement actives seront exposées à ce virus au moins une fois dans leur vie, souvent sans même le savoir.',
          'en': 'HPV is a common virus spread through sexual contact. The vast majority of sexually active people will be exposed to it at least once in their life, often without even knowing it.',
          'ar': 'فيروس الورم الحليمي البشري هو فيروس شائع ينتقل عن طريق الاتصال الجنسي. ستتعرض الغالبية العظمى من الأشخاص النشطين جنسيًا لهذا الفيروس مرة واحدة على الأقل في حياتهم، وغالبًا دون أن يدركوا ذلك.',
        },
      ),
      IntroSubchapter(
        subtitle: {'fr': '2.2 Pourquoi il ne cause pas toujours un cancer', 'en': '2.2 Why it doesn\'t always cause cancer', 'ar': '2.2 لماذا لا يسبب دائمًا السرطان'},
        body: {
          'fr': 'Dans la majorité des cas, le système immunitaire élimine seul l\'infection en un à deux ans, sans laisser de trace. Ce n\'est que lorsque l\'infection persiste plusieurs années que des lésions précancéreuses peuvent apparaître sur le col de l\'utérus.',
          'en': 'In most cases, the immune system clears the infection on its own within one to two years, without leaving a trace. Only when the infection persists for several years can precancerous lesions appear on the cervix.',
          'ar': 'في معظم الحالات، يتخلص جهاز المناعة من العدوى تلقائيًا خلال سنة إلى سنتين دون أن يترك أثرًا. فقط عندما تستمر العدوى لعدة سنوات يمكن أن تظهر آفات قبل سرطانية على عنق الرحم.',
        },
      ),
    ],
  ),
  IntroChapter(
    title: {'fr': '3. Facteurs de risque', 'en': '3. Risk factors', 'ar': '3. عوامل الخطر'},
    subchapters: [
      IntroSubchapter(
        subtitle: {'fr': '3.1 Facteurs liés au mode de vie', 'en': '3.1 Lifestyle-related factors', 'ar': '3.1 عوامل متعلقة بنمط الحياة'},
        body: {
          'fr': 'Un premier rapport sexuel précoce, de multiples partenaires sexuels, le tabagisme et de multiples grossesses augmentent le risque, principalement en favorisant la persistance de l\'infection à HPV.',
          'en': 'Early first intercourse, multiple sexual partners, smoking and multiple pregnancies increase risk, mainly by favoring the persistence of HPV infection.',
          'ar': 'تزيد العلاقة الجنسية الأولى المبكرة، وتعدد الشركاء الجنسيين، والتدخين، وتعدد حالات الحمل من الخطر، أساسًا عن طريق تعزيز استمرار عدوى فيروس الورم الحليمي.',
        },
      ),
      IntroSubchapter(
        subtitle: {'fr': '3.2 Facteurs liés à l\'accès aux soins', 'en': '3.2 Healthcare access factors', 'ar': '3.2 عوامل متعلقة بالوصول إلى الرعاية'},
        body: {
          'fr': 'L\'absence de dépistage régulier et un système immunitaire affaibli (notamment en cas de VIH) sont deux des facteurs de risque les plus déterminants. Un accès limité aux soins de santé retarde le dépistage et donc la détection précoce.',
          'en': 'Lack of regular screening and a weakened immune system (notably with HIV) are two of the most decisive risk factors. Limited access to healthcare delays screening and therefore early detection.',
          'ar': 'يُعد عدم الخضوع للفحص المنتظم وضعف جهاز المناعة (خاصة في حالة الإصابة بفيروس نقص المناعة البشرية) من أهم عوامل الخطر. كما أن ضعف الوصول إلى الرعاية الصحية يؤخر الفحص وبالتالي الكشف المبكر.',
        },
      ),
    ],
  ),
  IntroChapter(
    title: {'fr': '4. Symptômes à surveiller', 'en': '4. Symptoms to watch for', 'ar': '4. أعراض يجب الانتباه لها'},
    body: {
      'fr': 'Aux stades précancéreux, il n\'y a généralement aucun symptôme — c\'est justement pour cela que le dépistage régulier est essentiel. À un stade plus avancé, des saignements vaginaux anormaux (entre les règles, après un rapport sexuel ou après la ménopause), des pertes vaginales inhabituelles ou des douleurs pelviennes peuvent apparaître. Ces signes doivent toujours motiver une consultation rapide, mais leur absence ne remplace jamais un dépistage régulier.',
      'en': 'At precancerous stages, there are usually no symptoms at all — which is exactly why regular screening is essential. At a more advanced stage, abnormal vaginal bleeding (between periods, after intercourse, or after menopause), unusual vaginal discharge, or pelvic pain may appear. These signs should always prompt a prompt consultation, but their absence never replaces regular screening.',
      'ar': 'في المراحل قبل السرطانية، لا توجد عادةً أي أعراض — ولهذا السبب بالتحديد يُعد الفحص المنتظم أمرًا أساسيًا. في مرحلة أكثر تقدمًا، قد يظهر نزيف مهبلي غير طبيعي (بين الدورات الشهرية، بعد العلاقة الجنسية، أو بعد سن اليأس)، أو إفرازات مهبلية غير معتادة، أو آلام في الحوض. يجب أن تدفع هذه العلامات دائمًا إلى استشارة سريعة، لكن غيابها لا يغني أبدًا عن الفحص المنتظم.',
    },
  ),
  IntroChapter(
    title: {'fr': '5. Le dépistage', 'en': '5. Screening', 'ar': '5. الفحص'},
    subchapters: [
      IntroSubchapter(
        subtitle: {'fr': '5.1 Méthodes disponibles', 'en': '5.1 Available methods', 'ar': '5.1 الطرق المتاحة'},
        body: {
          'fr': 'Selon les moyens disponibles dans votre région, plusieurs méthodes existent : l\'inspection visuelle à l\'acide acétique et au lugol (IVA/IVL), le frottis cervico-vaginal, ou le test HPV. Toutes visent à détecter des anomalies avant qu\'elles ne deviennent un cancer.',
          'en': 'Depending on resources available in your area, several methods exist: visual inspection with acetic acid and Lugol\'s iodine (VIA/VILI), the Pap smear, or the HPV test. All aim to detect abnormalities before they become cancer.',
          'ar': 'حسب الإمكانيات المتاحة في منطقتك، توجد عدة طرق: الفحص البصري بحمض الخل ومحلول لوغول، أو مسحة عنق الرحم، أو فحص فيروس الورم الحليمي. تهدف جميعها إلى اكتشاف التشوهات قبل أن تتحول إلى سرطان.',
        },
      ),
      IntroSubchapter(
        subtitle: {'fr': '5.2 À quelle fréquence ?', 'en': '5.2 How often?', 'ar': '5.2 ما هي الوتيرة؟'},
        body: {
          'fr': 'Il est généralement recommandé de se faire dépister tous les 3 à 5 ans à partir de 25-30 ans, mais votre personnel de santé pourra vous conseiller la fréquence la mieux adaptée à votre situation personnelle.',
          'en': 'Screening is generally recommended every 3 to 5 years starting at age 25-30, but your health provider can advise the frequency best suited to your personal situation.',
          'ar': 'يُنصح عمومًا بإجراء الفحص كل 3 إلى 5 سنوات ابتداءً من سن 25-30 عامًا، لكن يمكن لطاقمك الصحي تحديد الوتيرة الأنسب لحالتك الشخصية.',
        },
      ),
    ],
  ),
  IntroChapter(
    title: {'fr': '6. Prévention', 'en': '6. Prevention', 'ar': '6. الوقاية'},
    subchapters: [
      IntroSubchapter(
        subtitle: {'fr': '6.1 Le vaccin HPV', 'en': '6.1 The HPV vaccine', 'ar': '6.1 لقاح فيروس الورم الحليمي'},
        body: {
          'fr': 'Le vaccin contre le HPV, idéalement administré avant le début de la vie sexuelle (souvent entre 9 et 14 ans), protège contre les souches du virus les plus associées au cancer du col de l\'utérus. Il constitue l\'un des trois piliers de la stratégie mondiale de l\'OMS pour éliminer cette maladie.',
          'en': 'The HPV vaccine, ideally given before the start of sexual activity (often between ages 9 and 14), protects against the virus strains most associated with cervical cancer. It is one of the three pillars of the WHO global strategy to eliminate this disease.',
          'ar': 'يحمي لقاح فيروس الورم الحليمي، الذي يُفضل إعطاؤه قبل بدء النشاط الجنسي (غالبًا بين سن 9 و14 عامًا)، من سلالات الفيروس الأكثر ارتباطًا بسرطان عنق الرحم. وهو أحد الركائز الثلاث لاستراتيجية منظمة الصحة العالمية العالمية للقضاء على هذا المرض.',
        },
      ),
      IntroSubchapter(
        subtitle: {'fr': '6.2 Les bons réflexes au quotidien', 'en': '6.2 Everyday good habits', 'ar': '6.2 العادات اليومية الجيدة'},
        body: {
          'fr': 'Au-delà du dépistage et de la vaccination, limiter le tabagisme et se protéger lors des rapports sexuels contribuent aussi à réduire le risque.',
          'en': 'Beyond screening and vaccination, limiting smoking and using protection during intercourse also help reduce risk.',
          'ar': 'بالإضافة إلى الفحص والتطعيم، يساهم الحد من التدخين واستخدام وسائل الحماية أثناء العلاقة الجنسية أيضًا في تقليل الخطر.',
        },
      ),
    ],
  ),
  IntroChapter(
    title: {'fr': '7. En cas de résultat anormal', 'en': '7. If a result comes back abnormal', 'ar': '7. في حال ظهور نتيجة غير طبيعية'},
    body: {
      'fr': 'Un résultat anormal ne signifie pas un cancer : dans la majorité des cas, il s\'agit d\'une lésion précancéreuse facilement traitable par une intervention locale simple et rapide (comme la cryothérapie). C\'est justement l\'objectif du dépistage : intervenir tôt, avant que quoi que ce soit de grave ne se développe. Votre personnel de santé vous accompagnera pour la suite à donner.',
      'en': 'An abnormal result does not mean cancer: in most cases, it is a precancerous lesion that is easily treated with a simple, quick local procedure (such as cryotherapy). This is exactly the point of screening: to intervene early, before anything serious develops. Your health provider will guide you through the next steps.',
      'ar': 'لا تعني النتيجة غير الطبيعية الإصابة بالسرطان: في معظم الحالات، يتعلق الأمر بآفة قبل سرطانية يمكن علاجها بسهولة بإجراء موضعي بسيط وسريع (مثل العلاج بالتبريد). هذا بالضبط هو هدف الفحص: التدخل مبكرًا قبل تطور أي شيء خطير. سيرافقك طاقمك الصحي في الخطوات التالية.',
    },
  ),
];

// ============================= PERSONNEL =============================

const List<IntroChapter> personnelIntroChapters = [
  IntroChapter(
    title: {'fr': '1. Enjeux de santé publique', 'en': '1. Public health stakes', 'ar': '1. رهانات الصحة العامة'},
    body: {
      'fr': 'Le cancer du col de l\'utérus reste l\'un des principaux cancers touchant les femmes dans les régions à ressources limitées, alors qu\'il figure parmi les plus évitables. L\'OMS a fixé un seuil d\'élimination à moins de 4 nouveaux cas pour 100 000 femmes par an, un objectif que 194 pays se sont engagés à atteindre via trois piliers : vaccination, dépistage et traitement.',
      'en': 'Cervical cancer remains one of the leading cancers affecting women in resource-limited regions, despite being among the most preventable. WHO has set an elimination threshold of fewer than 4 new cases per 100,000 women per year, a goal 194 countries have committed to reach through three pillars: vaccination, screening and treatment.',
      'ar': 'لا يزال سرطان عنق الرحم من أبرز أنواع السرطان التي تصيب النساء في المناطق ذات الموارد المحدودة، رغم أنه من أكثرها قابلية للوقاية. حددت منظمة الصحة العالمية عتبة القضاء عند أقل من 4 حالات جديدة لكل 100 ألف امرأة سنويًا، وهو هدف التزمت 194 دولة ببلوغه عبر ثلاث ركائز: التطعيم، الفحص، والعلاج.',
    },
  ),
  IntroChapter(
    title: {'fr': '2. Histoire naturelle de la maladie', 'en': '2. Natural history of the disease', 'ar': '2. المسار الطبيعي للمرض'},
    subchapters: [
      IntroSubchapter(
        subtitle: {'fr': '2.1 Infection à HPV', 'en': '2.1 HPV infection', 'ar': '2.1 عدوى فيروس الورم الحليمي'},
        body: {
          'fr': 'L\'infection persistante par certaines souches à haut risque du papillomavirus humain est la cause quasi-systématique du cancer du col de l\'utérus. La clairance spontanée du virus survient dans la majorité des cas en 1 à 2 ans.',
          'en': 'Persistent infection with certain high-risk strains of human papillomavirus is the near-universal cause of cervical cancer. Spontaneous viral clearance occurs in most cases within 1 to 2 years.',
          'ar': 'تُعد العدوى المستمرة ببعض سلالات فيروس الورم الحليمي عالية الخطورة السبب شبه الحصري لسرطان عنق الرحم. يحدث التخلص التلقائي من الفيروس في معظم الحالات خلال سنة إلى سنتين.',
        },
      ),
      IntroSubchapter(
        subtitle: {'fr': '2.2 Évolution vers les lésions précancéreuses', 'en': '2.2 Progression to precancerous lesions', 'ar': '2.2 التطور إلى آفات قبل سرطانية'},
        body: {
          'fr': 'En cas de persistance de l\'infection, des lésions intra-épithéliales de bas puis de haut grade peuvent apparaître sur plusieurs années, avant une éventuelle progression vers un cancer invasif si elles ne sont pas prises en charge.',
          'en': 'When infection persists, low-grade then high-grade intraepithelial lesions can develop over several years, potentially progressing to invasive cancer if left untreated.',
          'ar': 'في حال استمرار العدوى، يمكن أن تظهر آفات داخل ظهارية منخفضة الدرجة ثم عالية الدرجة على مدى سنوات عديدة، مع احتمال تطورها إلى سرطان غازٍ في حال عدم علاجها.',
        },
      ),
    ],
  ),
  IntroChapter(
    title: {'fr': '3. Méthodes de dépistage', 'en': '3. Screening methods', 'ar': '3. طرق الفحص'},
    subchapters: [
      IntroSubchapter(
        subtitle: {'fr': '3.1 Inspection visuelle (IVA/IVL)', 'en': '3.1 Visual inspection (VIA/VILI)', 'ar': '3.1 الفحص البصري'},
        body: {
          'fr': 'L\'inspection visuelle à l\'acide acétique (IVA) et au lugol (IVL) est une méthode peu coûteuse, adaptée aux contextes à ressources limitées, offrant un résultat immédiat qui permet souvent un traitement le jour même ("voir et traiter").',
          'en': 'Visual inspection with acetic acid (VIA) and Lugol\'s iodine (VILI) is a low-cost method suited to resource-limited settings, giving an immediate result that often allows same-day treatment ("see and treat").',
          'ar': 'يُعد الفحص البصري بحمض الخل ومحلول لوغول طريقة منخفضة التكلفة، مناسبة للسياقات ذات الموارد المحدودة، وتوفر نتيجة فورية تسمح غالبًا بالعلاج في نفس اليوم ("رؤية وعلاج").',
        },
      ),
      IntroSubchapter(
        subtitle: {'fr': '3.2 Frottis et test HPV', 'en': '3.2 Pap smear and HPV test', 'ar': '3.2 مسحة عنق الرحم وفحص فيروس الورم الحليمي'},
        body: {
          'fr': 'Le frottis cervico-vaginal recherche des cellules anormales, tandis que le test HPV détecte directement la présence du virus. Ce dernier est de plus en plus recommandé par l\'OMS comme méthode de première intention lorsque les ressources le permettent, en raison de sa sensibilité supérieure.',
          'en': 'The Pap smear looks for abnormal cells, while the HPV test directly detects the presence of the virus. WHO increasingly recommends the latter as a first-line method where resources allow, due to its higher sensitivity.',
          'ar': 'تبحث مسحة عنق الرحم عن خلايا غير طبيعية، بينما يكشف فحص فيروس الورم الحليمي مباشرة عن وجود الفيروس. توصي منظمة الصحة العالمية بشكل متزايد بهذا الأخير كطريقة أولى عند توفر الإمكانيات، نظرًا لحساسيته الأعلى.',
        },
      ),
    ],
  ),
  IntroChapter(
    title: {'fr': '4. Interprétation des résultats et orientation', 'en': '4. Interpreting results and referral', 'ar': '4. تفسير النتائج والتوجيه'},
    body: {
      'fr': 'Un résultat positif à l\'IVA/IVL, un frottis anormal ou un test HPV positif ne signifient pas un cancer, mais justifient une évaluation complémentaire (colposcopie si disponible) et une orientation rapide, car un délai de prise en charge trop long augmente le risque de progression vers un cancer invasif.',
      'en': 'A positive VIA/VILI result, an abnormal Pap smear, or a positive HPV test do not mean cancer, but warrant further evaluation (colposcopy if available) and prompt referral, since delayed care increases the risk of progression to invasive cancer.',
      'ar': 'لا تعني النتيجة الإيجابية للفحص البصري، أو المسحة غير الطبيعية، أو فحص فيروس الورم الحليمي الإيجابي وجود سرطان، لكنها تستدعي تقييمًا إضافيًا (تنظير عنق الرحم إن أمكن) وتوجيهًا سريعًا، لأن تأخر العلاج يزيد من خطر التطور إلى سرطان غازٍ.',
    },
  ),
  IntroChapter(
    title: {'fr': '5. Prise en charge des lésions précancéreuses', 'en': '5. Management of precancerous lesions', 'ar': '5. علاج الآفات قبل السرطانية'},
    body: {
      'fr': 'Selon la sévérité et le plateau technique disponible, le traitement repose sur la cryothérapie, la thermocoagulation, ou une résection chirurgicale (RAD/conisation). Ces traitements sont d\'un excellent rapport coût-efficacité et permettent d\'éviter la quasi-totalité des évolutions vers un cancer invasif lorsqu\'ils sont réalisés à temps.',
      'en': 'Depending on severity and available equipment, treatment relies on cryotherapy, thermocoagulation, or surgical excision (LEEP/conization). These treatments are highly cost-effective and prevent nearly all progressions to invasive cancer when performed in time.',
      'ar': 'حسب شدة الحالة والإمكانيات التقنية المتاحة، يعتمد العلاج على العلاج بالتبريد، أو التخثير الحراري، أو الاستئصال الجراحي. تتميز هذه العلاجات بفعالية عالية من حيث التكلفة وتمنع تقريبًا كل حالات التطور إلى سرطان غازٍ عند إجرائها في الوقت المناسب.',
    },
  ),
  IntroChapter(
    title: {'fr': '6. Suivi et traçabilité', 'en': '6. Follow-up and record-keeping', 'ar': '6. المتابعة والتوثيق'},
    body: {
      'fr': 'Une continuité rigoureuse des soins — rendez-vous de contrôle planifiés, dossier clair pour chaque patiente — est essentielle pour s\'assurer qu\'un traitement a bien fonctionné et détecter précocement une éventuelle récidive.',
      'en': 'Rigorous continuity of care — scheduled check-up appointments, a clear record for each patient — is essential to confirm treatment success and detect any recurrence early.',
      'ar': 'تُعد الاستمرارية الدقيقة للرعاية — مواعيد مراقبة مبرمجة، وملف واضح لكل مريضة — أمرًا أساسيًا للتأكد من نجاح العلاج والكشف المبكر عن أي انتكاسة محتملة.',
    },
  ),
  IntroChapter(
    title: {'fr': '7. Sensibilisation communautaire', 'en': '7. Community awareness', 'ar': '7. التوعية المجتمعية'},
    body: {
      'fr': 'Informer les patientes sur le HPV, les facteurs de risque et l\'importance du dépistage régulier reste un levier majeur, en particulier dans les zones où l\'accès à l\'information est limité. Votre rôle de sensibilisation est aussi déterminant que votre rôle clinique.',
      'en': 'Informing patients about HPV, risk factors and the importance of regular screening remains a major lever, especially in areas with limited access to information. Your awareness-raising role is just as decisive as your clinical role.',
      'ar': 'يظل إعلام المريضات بفيروس الورم الحليمي، وعوامل الخطر، وأهمية الفحص المنتظم رافعة أساسية، خاصة في المناطق التي يقل فيها الوصول إلى المعلومة. دورك التوعوي لا يقل أهمية عن دورك السريري.',
    },
  ),
];
