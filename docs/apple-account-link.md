# Liaison et connexion avec Apple

Branche front et back : `feat/apple-account-link`, depuis les branches
`feat/stripe-test-payments`. Cette livraison complète le fournisseur de connexion
Apple dans le parcours Google/Facebook existant.

## Comportement

- Dans Profil → Sécurité et confidentialité → Moyens de connexion, l'entrée Apple
  est cliquable sur iPhone/iPad lorsque le backend annonce `available: true`.
- Le mot de passe PayFlow actuel est demandé, puis la feuille native Apple s'ouvre.
  Le client transmet le jeton d'identité signé et le nonce de cette demande.
- Le backend vérifie la preuve Apple, le mot de passe et l'unicité du sujet Apple.
  Une identité déjà liée à un autre compte PayFlow est refusée. Une adresse e-mail
  identique ne déclenche jamais une fusion automatique de comptes.
- Après liaison, le bouton Apple de la page de connexion ouvre le même parcours
  natif et se connecte au compte PayFlow associé.
- Une annulation Apple ne crée pas de liaison et ne modifie pas la session.
  Un résultat sans `identityToken` est refusé ; un identifiant Apple seul ne suffit pas.
- « Masquer mon adresse e-mail » reste compatible : le mail PayFlow et son mot de
  passe ne sont pas remplacés par l'adresse relay Apple.
- Google, Apple et Facebook utilisent exactement les mêmes assets et tailles
  d'image sur la page Login et dans le profil, via `SocialProviderLogo`.
- Le parcours natif de cette livraison cible iOS. Sur les autres plateformes,
  la liaison Apple est annoncée indisponible et ne lance pas un SDK non configuré.
  Un compte déjà lié reste affiché comme lié. Android/Web demanderont un Services ID,
  un domaine et un retour HTTPS dédiés ; aucune valeur fictive n'est configurée.

## Activation sur iPhone

1. Dans Apple Developer, Identifiers → App IDs → `com.pay.flow.payFlowUi`, activer
   **Sign in with Apple**. Le compte doit appartenir à l'équipe de signature du build.
   Ce service requiert l'adhésion Apple Developer Program appropriée.
2. Ouvrir `ios/Runner.xcworkspace` dans Xcode, cible Runner → Signing & Capabilities.
   Vérifier l'équipe et Sign in with Apple, puis actualiser le provisioning.
   L'entitlement est déjà déclaré dans le dépôt pour Debug, Profile et Release.
   Conserver les autres entitlements configurés localement, notamment Apple Pay,
   dans ce même fichier lors de la fusion.
3. Dans le backend / configuration IntelliJ :

```properties
AUTH_OAUTH_APPLE_ENABLED=true
AUTH_APPLE_CLIENT_ID=com.pay.flow.payFlowUi
```

4. Redémarrer le backend. Vérifier, avec une session PayFlow, que
   `GET /api/v1/account/external-identities` renvoie `APPLE` avec `available: true`.
5. Depuis le front :

```sh
flutter pub get
flutter analyze
flutter test test/features/auth/apple_credential_service_test.dart test/features/auth/apple_auth_api_test.dart test/features/authentication_methods/provider_logos_test.dart
flutter run
```

`pubspec.lock` et l'enregistrement généré du plugin doivent être régénérés par
Flutter ; ils n'ont pas été modifiés à la main. Le SDK Flutter et Xcode sont absents
ici, donc les tests Flutter et la compilation/signature native ne sont pas exécutés.
Les contrôles de syntaxe des 10 fichiers Dart et du projet Xcode ont été réalisés.
Côté backend, 16 tests de vérification JWT et de liaison Google/Apple passent avec
une compilation ciblée Java 17 des sources concernées ; la compilation complète
Java 21/Maven reste à rejouer.

Si la base ne contient pas encore les identités externes et l'action d'audit de
liaison, appliquer le script existant `docs/sql/account-provider-linking.sql` du
backend. Aucune nouvelle migration n'est ajoutée.

## Contrat Apple

- Liaison : `POST /api/v1/account/external-identities/APPLE`, bearer PayFlow,
  JSON `{credential, expectedNonce, currentPassword}`.
- Connexion : `POST /api/v1/auth/oauth/apple`,
  JSON `{idToken, expectedNonce, deviceId, deviceName}`. Apple utilise `idToken`,
  contrairement au jeton classique Facebook transmis comme `accessToken`.
- Le client fournit le SHA-256 d'un nonce aléatoire au SDK et la même valeur au
  backend. Celui-ci vérifie la signature JWT, l'issuer Apple, l'audience iOS,
  les dates et l'égalité du claim `nonce` avec `expectedNonce`.
- Les jetons fournisseur et le mot de passe ne sont ni persistés ni journalisés.
  Une session PayFlow est créée seulement après vérification serveur.

Cette livraison utilise le vérificateur JWT existant. L'échange d'authorization
code, la gestion des autorisations révoquées chez Apple et leur révocation lors
d'une suppression de compte restent des travaux du parcours de production.

## Essais sur appareil

1. Se connecter avec le compte PayFlow existant ; vérifier les trois logos dans
   le profil, puis associer Apple avec le mot de passe correct.
2. Vérifier le passage de « Non lié » à « Lié ». Déconnecter PayFlow, puis utiliser
   Apple sur Login : retrouver le même utilisateur, sans créer de second compte.
3. Répéter avec « Masquer mon adresse e-mail » et après une autorisation déjà donnée
   (Apple peut ne plus fournir le nom et l'e-mail dans la réponse native).
4. Annuler la feuille Apple ; essayer un mauvais mot de passe PayFlow et une identité
   Apple déjà liée à un autre utilisateur : aucune liaison supplémentaire.
5. Vérifier que Google et Facebook fonctionnent encore et que le profil affiche
   une indisponibilité lorsque le fournisseur Apple est désactivé côté serveur.

## Références

- https://pub.dev/packages/sign_in_with_apple/versions/8.2.0
- https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.applesignin

## Tous les fichiers de cette livraison

Front — modifiés :

- `pubspec.yaml`
- `ios/Runner.xcodeproj/project.pbxproj`
- `lib/features/auth/data/social/social_credential_service.dart`
- `lib/features/auth/data/service_api/auth_api_service.dart`
- `lib/features/auth/presentation/view/login_view.dart`
- `lib/features/authentication_methods/presentation/view/authentication_methods_view.dart`

Front — ajoutés :

- `ios/Runner/Runner.entitlements`
- `lib/features/auth/data/social/social_credential.dart`
- `lib/features/auth/data/social/apple_credential_service.dart`
- `lib/features/auth/presentation/widget/social_provider_logo.dart`
- `test/features/auth/apple_credential_service_test.dart`
- `test/features/auth/apple_auth_api_test.dart`
- `test/features/authentication_methods/provider_logos_test.dart`
- `docs/apple-account-link.md`

Back — modifiés :

- `src/main/resources/application.properties`
- `docs/account-provider-linking.md`

Back — ajoutés :

- `src/test/java/com/fintech/payflow_back/common/infrastructure/oauth/AppleIdentityVerifierTest.java`
- `src/test/java/com/fintech/payflow_back/service/AppleLinkedProviderServiceTest.java`
