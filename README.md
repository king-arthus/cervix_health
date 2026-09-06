# Cervix Health — Application mobile (Flutter)

Application de prévention, dépistage et suivi du cancer du col de l'utérus, pour patientes et personnel de santé.

## Contenu de ce projet

- Écran d'accueil avec sélection de langue (FR/EN/AR) et sélection de profil
- Authentification (connexion / inscription) avec champs différenciés patiente / personnel
- **Espace patiente** : introduction, facteurs de risque (avec calcul du ratio), demande de dépistage (liste des hôpitaux du Tchad + recherche de personnel), suivi, messagerie, communauté
- **Espace personnel de santé** : introduction adaptée, demandes de dépistage reçues (mise à jour manuelle du statut/résultat/rendez-vous), suivi des patientes, messagerie, communauté
- Persistance locale (SharedPreferences) : comptes, demandes, messages, publications
- Gestion RTL automatique pour l'arabe

> ⚠️ **Analyse IA (VIA/VILI)** : volontairement laissée de côté dans cette version, comme convenu. Un emplacement (`ai_analysis_placeholder`) est prévu dans l'écran de détail de demande de dépistage côté personnel (`screening_requests_screen.dart`) pour brancher le futur modèle.

## Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installé (canal stable)
- Android Studio (ou VS Code + extension Flutter) avec un émulateur Android configuré, ou un téléphone Android en mode développeur

## Installation et lancement

```bash
# 1. Se placer dans le dossier du projet
cd cervix_health

# 2. Installer les dépendances
flutter pub get

# 3. Vérifier qu'un appareil/émulateur est détecté
flutter devices

# 4. Lancer l'application en mode debug
flutter run
```

## Générer un APK installable

```bash
flutter build apk --release
# L'APK se trouve ensuite dans : build/app/outputs/flutter-apk/app-release.apk
```

## Structure du projet

```
lib/
  main.dart                        # Point d'entrée, thème, routage initial
  models/                          # Modèles de données (utilisateur, dépistage, messages, posts)
  services/app_data.dart           # Couche de persistance + logique métier (état global via Provider)
  localization/                    # Traductions FR/EN/AR + extension context.t('cle')
  data/hospitals.dart              # Liste des hôpitaux du Tchad + facteurs de risque
  screens/
    welcome_screen.dart            # Page 1
    auth_screen.dart               # Page 2 (connexion/inscription)
    patient/                       # Les 6 modules côté patiente
    personnel/                     # Les modules côté personnel de santé
```

## Compiler l'APK en ligne (sans rien installer), via GitHub Actions

Ce projet inclut déjà un fichier `.github/workflows/build-apk.yml` qui compile automatiquement l'APK dans le cloud.

1. Créez un compte sur [github.com](https://github.com) (gratuit)
2. Créez un nouveau dépôt (repository), par exemple nommé `cervix-health`
3. Uploadez-y tout le contenu de ce dossier `cervix_health` (le plus simple : via [GitHub Desktop](https://desktop.github.com))
4. Allez dans l'onglet **Actions** de votre dépôt : la compilation démarre automatiquement (3-5 minutes)
5. Une fois terminé, cliquez sur le run terminé → section **Artifacts** en bas → téléchargez `app-release` (contient `app-release.apk`)

Vous pouvez aussi relancer une compilation manuellement à tout moment depuis l'onglet Actions, sans avoir à modifier de code.

## Points importants avant mise en production

1. **Backend réel** : les données sont actuellement stockées uniquement sur l'appareil (SharedPreferences). Pour une utilisation multi-appareils/multi-utilisateurs réelle, il faut connecter un backend (Firebase, Supabase, ou API REST + base de données) — en particulier pour la messagerie et les comptes.
2. **Sécurité des mots de passe** : les mots de passe sont actuellement comparés en clair pour la démonstration. En production, ils doivent être hachés (ex. bcrypt) côté serveur, jamais stockés en clair.
3. **Liste des hôpitaux** : la liste dans `data/hospitals.dart` est indicative ; à valider/compléter auprès du ministère de la Santé publique du Tchad.
4. **Analyse IA VIA/VILI** : à intégrer dans une prochaine itération (modèle entraîné + pipeline d'inférence, hébergé séparément).
5. **Traductions** : les textes sont dans `localization/app_strings.dart`. Pour un projet à grande échelle, migrer vers `flutter_localizations` + fichiers `.arb`.
