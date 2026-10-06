# Face ID / Touch ID : connexion PayFlow

Cette modification complète le parcours existant. Elle est isolée dans
`fix/face-id-session-unlock`, créée depuis `feat/stripe-test-payments`.
Le backend conserve son contrat de connexion et de rotation des refresh tokens.

## Règles du parcours

- Activation volontaire dans Profil → Sécurité et confidentialité → Biométrie,
  après une authentification native réussie. La désactivation nécessite également
  une authentification réussie. Une annulation ou une erreur de stockage ne
  modifie jamais le choix enregistré.
- Au démarrage avec une session locale : aucun prompt si l'option est désactivée ;
  Face ID / Touch ID / empreinte si elle est activée.
- Sans session locale, ou avec une session localement expirée : connexion classique,
  sans demander inutilement Face ID.
- Une validation réussie permet de lire le refresh token et d'appeler `/auth/refresh`.
  Le token renouvelé est sauvegardé avant d'ouvrir l'accueil.
- Trois authentifications terminées par un échec entraînent le retour à la
  connexion. Le système peut faire plusieurs scans dans une même authentification ;
  son propre verrouillage entraîne un retour immédiat à la connexion.
- Annulation explicite, demande du moyen de secours, biométrie absente/supprimée
  ou verrouillée : retour immédiat à la connexion, sans restauration serveur.
- Une erreur technique du plugin affiche un message biométrique et permet de
  réessayer ou de choisir « Se connecter ». Le repli est sur le Splash ; aucun
  bouton Face ID n'est ajouté à l'écran Login.
- Une erreur réseau après validation biométrique conserve le token. Réessayer
  utilise la validation locale déjà acquise pendant ce démarrage ; elle n'est
  pas comptée comme un échec Face ID. Une session refusée par le serveur est effacée.
- Lorsque le matériel devient indisponible, les paramètres affichent le choix
  enregistré avec l'indication d'indisponibilité et bloquent le changement. Le
  retour à la connexion reste possible ; reconfigurer les biométries du téléphone
  permet de gérer l'option à nouveau.

## Session et protection locale

`SessionService.initialize()` inspecte uniquement l'identifiant et l'expiration de
session. Il ne lit plus le secret avant le contrôle biométrique. La lecture du
refresh token est refusée tant que le démarrage n'a pas autorisé la restauration.
Un 401 ne permet pas à l'intercepteur réseau de restaurer une session encore
verrouillée. Une connexion classique autorise les refresh ultérieurs normalement.

Le refresh token reste dans `flutter_secure_storage` (Keychain / stockage sécurisé
Android), l'access token reste en mémoire. La vérification `local_auth` et le
verrou de lecture sont des contrôles applicatifs locaux ; cette modification
n'ajoute pas de règle biométrique cryptographique à l'objet Keychain/Keystore.
Aucune image du visage ni donnée biométrique n'est envoyée au backend.

Le choix existant reste local au téléphone (`payflow.biometrics.enabled.v2`).
La protection intervient au démarrage/restauration de session. Cette livraison
n'ajoute pas de verrouillage automatique à chaque retour d'arrière-plan.

## Configuration native vérifiée

La base contient déjà `NSFaceIDUsageDescription` dans `ios/Runner/Info.plist`,
`USE_BIOMETRIC` dans le manifeste Android et une `FlutterFragmentActivity`.
Aucune configuration native supplémentaire ni migration backend n'est ajoutée.

## Vérification

Contrôles réalisés dans l'environnement de cette modification : syntaxe des
13 fichiers Dart ajoutés/modifiés avec tree-sitter, `git diff --check`, lecture des
configurations iOS/Android et contrôle des accès au refresh token.

Le SDK Flutter/Dart et Xcode ne sont pas disponibles dans cet environnement.
Les tests ci-dessous sont ajoutés mais **n'ont pas été exécutés** ; l'analyse
Flutter et la validation sur iPhone restent à effectuer avant fusion.

```sh
flutter pub get
flutter analyze
flutter test test/core/session_service_test.dart test/core/biometric_auth_interceptor_test.dart test/features/auth/splash_biometric_test.dart test/features/auth/splash_biometric_view_test.dart test/features/profile/security_biometric_test.dart
```

Sur iPhone physique :

1. Configurer Face ID et autoriser son utilisation par PayFlow ; se connecter
   normalement, puis activer Biométrie dans les paramètres PayFlow.
2. Fermer réellement l'application et la relancer : vérifier le prompt automatique,
   puis l'accès à l'accueil après succès.
3. Annuler le prompt : vérifier l'arrivée sur Login et la possibilité de se connecter.
4. Relancer avec trois échecs d'authentification ; vérifier le repli vers Login
   (ou le repli immédiat si iOS verrouille la biométrie plus tôt).
5. Tester la suppression/désactivation de Face ID et une session serveur révoquée :
   aucun accès à l'accueil sans nouvelle connexion.
6. Couper le réseau après l'authentification locale : afficher l'erreur de connexion,
   rétablir le réseau et réessayer ; ne pas redemander Face ID pendant cette tentative.
7. Désactiver Biométrie dans PayFlow puis relancer : vérifier l'absence de prompt.

Sur simulateur iOS : activer l'enrôlement Face ID dans Features → Face ID,
utiliser Matching Face / Non-matching Face pour les essais. Ces essais complètent
la validation obligatoire sur iPhone ; Android doit également être testé avec
une empreinte configurée et sans biométrie.

## Fichiers modifiés ou ajoutés

Modifiés :

- `lib/core/service/biometric_service.dart`
- `lib/core/service/session_service.dart`
- `lib/core/network/auth_interceptor.dart`
- `lib/features/auth/presentation/view_model/splash_view_model.dart`
- `lib/features/auth/presentation/view/splash_view.dart`
- `lib/features/profile/presentation/view_model/security_privacy_view_model.dart`
- `lib/features/profile/presentation/view/security_privacy_view.dart`

Ajoutés :

- `test/support/biometric_fakes.dart`
- `test/core/session_service_test.dart`
- `test/core/biometric_auth_interceptor_test.dart`
- `test/features/auth/splash_biometric_test.dart`
- `test/features/auth/splash_biometric_view_test.dart`
- `test/features/profile/security_biometric_test.dart`
- `docs/face-id.md`
