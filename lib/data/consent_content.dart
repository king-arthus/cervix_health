import 'introduction_content.dart';

/// Contenu du contrat de consentement / conditions d'utilisation, affiché
/// obligatoirement avant la première utilisation de l'application.
///
/// ⚠️ Ce texte est une base rédigée par un assistant IA, pas par un juriste.
/// Il doit être relu et validé par un professionnel du droit compétent
/// (idéalement connaissant la réglementation du Tchad et du Cameroun en
/// matière de données de santé) avant tout déploiement réel avec de vraies
/// patientes et de vraies données médicales.
const List<IntroChapter> consentChapters = [
  IntroChapter(
    title: {
      'fr': '1. Objet de l\'application',
      'en': '1. Purpose of the application',
      'ar': '1. الغرض من التطبيق',
    },
    body: {
      'fr': 'Cervix Health est une application d\'information, de mise en relation et de suivi autour du dépistage du cancer du col de l\'utérus. Elle permet aux patientes de s\'informer, de demander un dépistage et de suivre leur dossier ; elle permet aux agents de santé et aux spécialistes de réaliser, orienter et valider ce dépistage.\n\n⚠️ Cervix Health n\'est ni un dispositif médical certifié, ni un outil de diagnostic. Elle ne remplace en aucun cas une consultation, un examen ou l\'avis d\'un professionnel de santé qualifié.',
      'en': 'Cervix Health is an information, referral, and follow-up application for cervical cancer screening. It lets patients learn about the topic, request screening, and track their file; it lets health agents and specialists carry out, refer, and validate that screening.\n\n⚠️ Cervix Health is neither a certified medical device nor a diagnostic tool. It never replaces a consultation, an examination, or the advice of a qualified health professional.',
      'ar': 'تطبيق Cervix Health هو تطبيق للتوعية والتوجيه والمتابعة المتعلقة بفحص سرطان عنق الرحم. يتيح للمريضات الاطلاع على المعلومات، وطلب الفحص، ومتابعة ملفهن؛ ويتيح للأعوان الصحيين والأخصائيين إجراء هذا الفحص وتوجيهه والتحقق منه.\n\n⚠️ تطبيق Cervix Health ليس جهازًا طبيًا معتمدًا ولا أداة تشخيص. لا يغني بأي حال عن استشارة أو فحص أو رأي طبيب مختص.',
    },
  ),
  IntroChapter(
    title: {
      'fr': '2. Données collectées',
      'en': '2. Data collected',
      'ar': '2. البيانات التي يتم جمعها',
    },
    subchapters: [
      IntroSubchapter(
        subtitle: {'fr': '2.1 Données d\'identité et de contact', 'en': '2.1 Identity and contact data', 'ar': '2.1 بيانات الهوية والاتصال'},
        body: {
          'fr': 'Nom, prénom, âge, sexe, adresse e-mail, numéro de contact, et, pour les agents et spécialistes, la structure de santé employeuse, le poste occupé et la spécialité. Vous pouvez également ajouter une photo de profil, facultative.',
          'en': 'Last name, first name, age, gender, email address, contact number, and, for agents and specialists, the employing health facility, position, and specialty. You may also add an optional profile photo.',
          'ar': 'الاسم واللقب والعمر والجنس والبريد الإلكتروني ورقم الاتصال، وبالنسبة للأعوان والأخصائيين، المنشأة الصحية التابعين لها والمنصب والتخصص. يمكنك أيضًا إضافة صورة شخصية اختيارية.',
        },
      ),
      IntroSubchapter(
        subtitle: {'fr': '2.2 Données de santé (données sensibles)', 'en': '2.2 Health data (sensitive data)', 'ar': '2.2 البيانات الصحية (بيانات حساسة)'},
        body: {
          'fr': 'Demandes de dépistage, résultats IVA/IVL, observations cliniques, orientation vers un spécialiste, conclusion médicale et dates de rendez-vous. Ce sont des données de santé, considérées comme sensibles : elles ne sont visibles que par vous-même et les professionnels de santé directement impliqués dans votre dossier (l\'agent qui vous a dépistée, le spécialiste vers qui vous êtes orientée).',
          'en': 'Screening requests, VIA/VILI results, clinical observations, referral to a specialist, medical conclusion, and appointment dates. This is health data, considered sensitive: it is visible only to you and the health professionals directly involved in your case (the agent who screened you, the specialist you were referred to).',
          'ar': 'طلبات الفحص، ونتائج IVA/IVL، والملاحظات السريرية، والتوجيه إلى أخصائي، والاستنتاج الطبي، ومواعيد الفحص. هذه بيانات صحية تعتبر حساسة: لا يراها سوى المستخدم نفسه والمهنيين الصحيين المعنيين مباشرة بملفه (العون الذي أجرى الفحص، والأخصائي الذي تم التوجيه إليه).',
        },
      ),
      IntroSubchapter(
        subtitle: {'fr': '2.3 Contenus que vous publiez', 'en': '2.3 Content you post', 'ar': '2.3 المحتوى الذي تنشره'},
        body: {
          'fr': 'Les messages échangés dans la messagerie et les publications dans l\'espace communauté sont visibles par leurs destinataires ou par l\'ensemble des utilisateurs de l\'application (pour la communauté). Ne partagez jamais d\'information que vous ne souhaitez pas voir visible par d\'autres utilisateurs de l\'application dans cet espace public.',
          'en': 'Messages exchanged in the messaging feature and posts in the community space are visible to their recipients or to all users of the application (for the community). Never share information there that you would not want visible to other users of the application in that public space.',
          'ar': 'الرسائل المتبادلة عبر خاصية المراسلة والمنشورات في فضاء المجتمع مرئية لمستلميها أو لجميع مستخدمي التطبيق (بالنسبة للمجتمع). لا تشارك أبدًا في هذا الفضاء العام معلومات لا ترغب في أن يراها مستخدمون آخرون.',
        },
      ),
    ],
  ),
  IntroChapter(
    title: {'fr': '3. Pourquoi ces données sont collectées', 'en': '3. Why this data is collected', 'ar': '3. لماذا يتم جمع هذه البيانات'},
    body: {
      'fr': 'Vos données sont utilisées exclusivement pour : créer et sécuriser votre compte ; vous permettre de demander, réaliser ou suivre un dépistage ; mettre en relation patientes, agents et spécialistes ; vous envoyer des rappels de rendez-vous ; et faire fonctionner les espaces de messagerie et de communauté. Elles ne sont jamais utilisées à des fins publicitaires ni vendues à des tiers.',
      'en': 'Your data is used exclusively to: create and secure your account; let you request, perform, or track screening; connect patients, agents, and specialists; send you appointment reminders; and run the messaging and community features. It is never used for advertising purposes or sold to third parties.',
      'ar': 'تُستخدم بياناتك حصريًا من أجل: إنشاء حسابك وتأمينه؛ تمكينك من طلب الفحص أو إجرائه أو متابعته؛ الربط بين المريضات والأعوان والأخصائيين؛ إرسال تذكيرات بالمواعيد؛ وتشغيل خاصيتي المراسلة والمجتمع. لا تُستخدم أبدًا لأغراض إعلانية ولا تُباع لأطراف ثالثة.',
    },
  ),
  IntroChapter(
    title: {'fr': '4. Qui peut voir vos données', 'en': '4. Who can see your data', 'ar': '4. من يمكنه رؤية بياناتك'},
    body: {
      'fr': 'Selon votre rôle :\n• Patiente : vous seule voyez l\'intégralité de votre dossier. L\'agent qui vous dépiste et le spécialiste vers qui vous êtes orientée voient les informations nécessaires à votre prise en charge.\n• Agent de santé : vous voyez les dossiers des patientes que vous suivez et la liste des spécialistes disponibles pour orientation.\n• Spécialiste : vous voyez uniquement les dossiers qui vous sont spécifiquement orientés.\n• Administrateur (fonctionnalité à venir) : accès de gestion technique du système, encadré par des règles internes strictes.',
      'en': 'Depending on your role:\n• Patient: only you see your full file. The agent who screens you and the specialist you are referred to see the information needed for your care.\n• Health agent: you see the files of patients you follow and the list of specialists available for referral.\n• Specialist: you only see files specifically referred to you.\n• Administrator (upcoming feature): technical system management access, governed by strict internal rules.',
      'ar': 'حسب دورك:\n• المريضة: أنت وحدك من يرى ملفك الكامل. يرى العون الذي يجري لك الفحص والأخصائي الذي تم توجيهك إليه المعلومات اللازمة لرعايتك.\n• العون الصحي: ترى ملفات المريضات اللواتي تتابعهن وقائمة الأخصائيين المتاحين للتوجيه.\n• الأخصائي: لا ترى سوى الملفات الموجهة إليك تحديدًا.\n• المدير (ميزة قادمة): صلاحية إدارة تقنية للنظام، تخضع لقواعد داخلية صارمة.',
    },
  ),
  IntroChapter(
    title: {'fr': '5. Où et comment vos données sont stockées', 'en': '5. Where and how your data is stored', 'ar': '5. أين وكيف يتم تخزين بياناتك'},
    body: {
      'fr': 'Vos données sont hébergées sur Firebase, un service d\'hébergement cloud fourni par Google, ce qui implique un transfert et un stockage de vos données en dehors du Tchad et du Cameroun. Les échanges entre votre téléphone et nos serveurs sont chiffrés (HTTPS). Votre mot de passe n\'est jamais stocké en clair : il est géré directement par le système d\'authentification de Firebase.\n\n⚠️ L\'application est actuellement en phase de développement et de test. Bien que des précautions raisonnables soient prises, aucune garantie absolue de sécurité ne peut être donnée à ce stade, et une perte ou une réinitialisation de données de test peut survenir pendant cette phase.',
      'en': 'Your data is hosted on Firebase, a cloud hosting service provided by Google, which means your data is transferred and stored outside Chad and Cameroon. Exchanges between your phone and our servers are encrypted (HTTPS). Your password is never stored in plain text: it is managed directly by Firebase\'s authentication system.\n\n⚠️ The application is currently in development and testing phase. While reasonable precautions are taken, no absolute security guarantee can be given at this stage, and loss or reset of test data may occur during this phase.',
      'ar': 'تُستضاف بياناتك على Firebase، وهي خدمة استضافة سحابية تقدمها Google، ما يعني نقل بياناتك وتخزينها خارج تشاد والكاميرون. التبادلات بين هاتفك وخوادمنا مشفرة (HTTPS). لا يتم أبدًا تخزين كلمة مرورك بشكل واضح: يتم التعامل معها مباشرة عبر نظام المصادقة الخاص بـ Firebase.\n\n⚠️ التطبيق حاليًا في مرحلة التطوير والاختبار. ورغم اتخاذ احتياطات معقولة، لا يمكن تقديم أي ضمان مطلق للأمان في هذه المرحلة، وقد يحدث فقدان أو إعادة تعيين لبيانات الاختبار خلال هذه الفترة.',
    },
  ),
  IntroChapter(
    title: {'fr': '6. Durée de conservation', 'en': '6. Retention period', 'ar': '6. مدة الاحتفاظ بالبيانات'},
    body: {
      'fr': 'Vos données sont conservées tant que votre compte est actif. Vous pouvez demander la suppression de votre compte et de vos données à tout moment (voir section 8). Les dossiers médicaux peuvent être conservés plus longtemps si une obligation légale ou une nécessité de continuité des soins le justifie.',
      'en': 'Your data is kept as long as your account is active. You may request deletion of your account and data at any time (see section 8). Medical records may be kept longer if a legal obligation or continuity-of-care requirement justifies it.',
      'ar': 'يُحتفظ ببياناتك طالما أن حسابك نشط. يمكنك طلب حذف حسابك وبياناتك في أي وقت (انظر القسم 8). يمكن الاحتفاظ بالملفات الطبية لفترة أطول إذا استدعى ذلك التزام قانوني أو ضرورة استمرارية الرعاية.',
    },
  ),
  IntroChapter(
    title: {'fr': '7. Limites et risques à connaître', 'en': '7. Limitations and risks to be aware of', 'ar': '7. حدود ومخاطر يجب معرفتها'},
    body: {
      'fr': 'En utilisant Cervix Health, vous reconnaissez et acceptez que :\n• l\'application est en développement actif et peut contenir des erreurs (bugs), y compris des interruptions temporaires de service ;\n• les rappels et notifications ne sont pas garantis à l\'heure exacte et peuvent, dans de rares cas, ne pas se déclencher (panne réseau, contraintes du système Android) ;\n• l\'application ne fournit aucun diagnostic médical automatisé ; toute décision médicale doit être prise par un professionnel de santé qualifié ;\n• en cas de symptôme préoccupant, vous devez consulter un professionnel de santé sans attendre une réponse dans l\'application ;\n• la disponibilité du personnel de santé et des spécialistes référencés dans l\'application dépend de leur propre inscription et disponibilité, non garantie par l\'application elle-même.',
      'en': 'By using Cervix Health, you acknowledge and accept that:\n• the application is under active development and may contain errors (bugs), including temporary service interruptions;\n• reminders and notifications are not guaranteed to arrive at the exact time and may, in rare cases, fail to trigger (network outage, Android system constraints);\n• the application provides no automated medical diagnosis; any medical decision must be made by a qualified health professional;\n• if you have a concerning symptom, you should consult a health professional without waiting for a response within the app;\n• the availability of health staff and specialists listed in the application depends on their own registration and availability, not guaranteed by the application itself.',
      'ar': 'باستخدامك لتطبيق Cervix Health، فإنك تقر وتوافق على أن:\n• التطبيق قيد التطوير النشط وقد يحتوي على أخطاء (bugs)، بما في ذلك انقطاعات مؤقتة للخدمة؛\n• التذكيرات والإشعارات غير مضمونة الوصول في الوقت المحدد بدقة، وقد لا تصل في حالات نادرة (انقطاع الشبكة، قيود نظام أندرويد)؛\n• التطبيق لا يقدم أي تشخيص طبي آلي؛ يجب أن يتخذ أي قرار طبي من قبل مختص صحي مؤهل؛\n• في حال ظهور عرض مقلق، يجب استشارة مختص صحي دون انتظار رد داخل التطبيق؛\n• توفر الطاقم الصحي والأخصائيين المدرجين في التطبيق يعتمد على تسجيلهم وتوفرهم الخاص، وهو أمر غير مضمون من طرف التطبيق نفسه.',
    },
  ),
  IntroChapter(
    title: {'fr': '8. Vos droits', 'en': '8. Your rights', 'ar': '8. حقوقك'},
    body: {
      'fr': 'Vous pouvez à tout moment : consulter les données de votre profil (section "Mon profil") ; demander la correction d\'une information inexacte ; demander la suppression de votre compte et de vos données ; retirer votre consentement, ce qui entraînera l\'impossibilité de continuer à utiliser l\'application. Pour exercer ces droits, contactez le développeur de l\'application via les informations fournies dans l\'application.',
      'en': 'You may at any time: view your profile data ("My profile" section); request correction of inaccurate information; request deletion of your account and data; withdraw your consent, which will make it impossible to continue using the application. To exercise these rights, contact the application\'s developer using the information provided within the app.',
      'ar': 'يمكنك في أي وقت: الاطلاع على بيانات ملفك الشخصي (قسم "ملفي الشخصي")؛ طلب تصحيح معلومة غير دقيقة؛ طلب حذف حسابك وبياناتك؛ سحب موافقتك، ما سيؤدي إلى عدم إمكانية مواصلة استخدام التطبيق. لممارسة هذه الحقوق، تواصل مع مطور التطبيق عبر المعلومات المتوفرة داخل التطبيق.',
    },
  ),
  IntroChapter(
    title: {'fr': '9. Âge minimum', 'en': '9. Minimum age', 'ar': '9. الحد الأدنى للسن'},
    body: {
      'fr': 'Cervix Health s\'adresse à des utilisatrices et utilisateurs majeurs. Si vous êtes mineur(e), l\'utilisation de l\'application doit se faire avec l\'accord et sous la supervision d\'un parent, tuteur légal, ou professionnel de santé encadrant.',
      'en': 'Cervix Health is intended for adult users. If you are a minor, use of the application must occur with the agreement and under the supervision of a parent, legal guardian, or supervising health professional.',
      'ar': 'تطبيق Cervix Health موجه للمستخدمين البالغين. إذا كنت قاصرًا، يجب أن يتم استخدام التطبيق بموافقة وتحت إشراف أحد الوالدين أو الوصي القانوني أو مختص صحي مشرف.',
    },
  ),
  IntroChapter(
    title: {'fr': '10. Modifications de ce document', 'en': '10. Changes to this document', 'ar': '10. تعديلات على هذا المستند'},
    body: {
      'fr': 'Ce document peut évoluer à mesure que l\'application se développe. Toute modification importante vous sera signalée, et une nouvelle acceptation pourra vous être demandée.',
      'en': 'This document may evolve as the application develops. Any significant change will be flagged to you, and you may be asked to accept it again.',
      'ar': 'قد يتطور هذا المستند مع تطور التطبيق. سيتم إعلامك بأي تعديل مهم، وقد يُطلب منك الموافقة عليه مجددًا.',
    },
  ),
];
