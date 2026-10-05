# Stripe en test — PayFlow V1

Base front : `fix/transfer-review-paypal-return`. Base back : `feat/wave-senegal-catalog`.

Cette intégration fonctionne dans les applications Flutter **iOS et Android**. Le mode Stripe est explicitement indisponible sur Flutter Web/desktop dans cette première livraison ; le front l'indique et ne lance pas une fausse simulation à sa place. Le mode de simulation historique reste disponible lorsque Stripe est désactivé.

## Activer

1. Dans la base PostgreSQL de test, exécuter `docs/sql/saved-payment-cards.sql` si nécessaire, puis le nouveau script backend `docs/sql/stripe-test-payments.sql`. Cette migration est nécessaire même si Stripe reste désactivé : le modèle de carte inclut désormais la référence du prestataire.
2. Dans la configuration d'exécution Spring Boot, définir les variables suivantes. Ne pas enregistrer les clés dans Git et ne pas envoyer la clé secrète dans le chat.

```text
STRIPE_TEST_ENABLED=true
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_MERCHANT_COUNTRY=FR
TRANSFER_GATEWAY=simulation
```

Vérifier que `app.transfer.gateway=simulation` est effectivement utilisé ; les clés live et une passerelle de réception réelle sont refusées au démarrage lorsque Stripe est activé.

3. Dans le dashboard Stripe, choisir l'environnement de test/sandbox associé à ces clés. Activer **PayPal** dans les moyens de paiement lorsqu'il est disponible pour le compte. La création d'un produit ou d'une facture n'est pas nécessaire : le backend crée des PaymentIntents pour les cotations.
4. Dans le front :

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

`flutter_stripe ^14.1.0` nécessite Flutter >= 3.41.0 et Dart >= 3.8.1 ; le pubspec actuel utilise déjà Dart ^3.12.2. Faire un redémarrage complet après l'ajout du plugin. Le lockfile sera mis à jour par `flutter pub get` ; cette opération n'a pas pu être exécutée dans l'environnement de développement de cette livraison.

Les thèmes Android sont maintenant compatibles AppCompat. L'activité utilisait déjà FlutterFragmentActivity. Google Pay et le retour `payflow://stripe-return` sont déclarés dans AndroidManifest.xml ; le schéma `payflow` existe déjà sur iOS.

## Compilation Android : cibles JVM Stripe

Le module `:app` et le Java du plugin Stripe ciblent JVM 17. La configuration
racine `android/build.gradle.kts` fixe aussi les tâches Kotlin de
`:stripe_android` à `JvmTarget.JVM_17`. Le JDK 21 du daemon Gradle peut être
conservé : il ne doit pas changer la cible de bytecode du plugin.

Après récupération du correctif, depuis la racine Flutter :

```bash
flutter clean
flutter pub get
flutter build apk --debug
flutter run
```

L'alignement est limité au plugin Stripe pour respecter les cibles des autres
plugins. Il s'applique à ses variantes debug et release. La validation de
compatibilité JVM reste active ; ne pas la remplacer par `ignore` ou `warning`.
Le correctif ne modifie pas les fichiers du cache Pub.

Références :

- https://kotlinlang.org/docs/gradle-configure-project.html#check-for-jvm-target-compatibility-of-related-compile-tasks
- https://kotlinlang.org/docs/gradle-compiler-options.html

## Apple Pay

Configurer dans Apple Developer/Xcode un Merchant ID appartenant au projet, la capacité Apple Pay et le certificat de traitement demandé par Stripe. Définir côté backend :

```text
STRIPE_APPLE_MERCHANT_ID=merchant.<identifiant-configure-dans-xcode>
```

Le même identifiant doit être autorisé dans les entitlements/signatures de l'application. Aucune valeur fictive n'est ajoutée au projet Xcode. Sans Merchant ID configuré, Apple Pay ne figure pas dans le sélecteur Stripe. Tester sur un appareil Apple compatible ; Apple Wallet n'accepte pas les numéros de carte de test Stripe ordinaires. Les clés Stripe de test garantissent un paiement fictif même lorsqu'une carte du wallet est utilisée.

## Sélecteur de paiement et disponibilité Apple Pay

Le ViewModel fournit la même liste de méthodes au sélecteur et à la validation.
Pendant le chargement de la configuration et des cartes, le champ affiche
« Chargement des moyens de paiement… » et la confirmation est désactivée.
Si un wallet devient indisponible ou si la carte choisie est supprimée, le choix
revient à une méthode disponible. La valeur du champ est absente pendant cette
transition et sa clé change avec les options ; elle ne peut pas désigner un item
supprimé. Les cartes sont distinguées par ID et les ID répétés sont dédupliqués.

En mode Stripe, Apple Pay natif n'est proposé que sur iOS si un Merchant ID est
configuré et si le SDK confirme la disponibilité. Sur Android, cette intégration
propose Google Pay ; le parcours Apple Pay par QR n'est pas inclus dans cette V1.
Un message explique l'indisponibilité d'Apple Pay au lieu de masquer le wallet
sans explication. Le mode de simulation historique conserve ses options.

Pour diagnostiquer Apple Pay sur iOS : vérifier que la réponse authentifiée de
`GET /api/v1/payments/stripe-test/config` contient `enabled: true` et un
`appleMerchantId` non vide. La variable back `STRIPE_APPLE_MERCHANT_ID` doit
correspondre au Merchant ID sélectionné dans la capacité Apple Pay de la cible
Runner dans Xcode. Configurer le certificat Stripe et un Wallet compatible, puis
redémarrer complètement l'application après modification de la configuration.

Régressions ajoutées :

```bash
flutter test test/features/transfer/stripe_transfer_view_model_test.dart test/features/transfer/transfer_funding_availability_test.dart
```

Ces tests couvrent le vrai écran avant/pendant/après le chargement, la disparition
et le retour d'Apple Pay, le refus d'une méthode indisponible, la déduplication
et la suppression de la carte choisie. Ils restent à exécuter avec le SDK Flutter.

## Google Pay

Utiliser un téléphone Android compatible, connecté à un compte Google. L'API est activée dans le manifeste et le SDK utilise `testEnv: true`. Le bouton n'est proposé que lorsque le SDK confirme sa disponibilité. Tester avec la suite de cartes de test Google Pay/Stripe et la configuration de wallet requise par Google.

## Cartes enregistrées

Profil → Mes cartes bancaires → Ajouter une carte ouvre PaymentSheet. Le numéro et le CVC sont saisis dans le composant Stripe. PayFlow ne les reçoit pas. Le backend vérifie que le SetupIntent a réussi et appartient au client Stripe de l'utilisateur, puis conserve le token Stripe, la marque, les quatre derniers chiffres et l'expiration.

Les anciennes cartes saisies manuellement restent visibles dans la gestion des cartes, mais ne sont pas utilisables en mode Stripe. Les réenregistrer avec le formulaire Stripe. Dans le choix du mode d'envoi : `Visa •••• 4242`, `Mastercard •••• 4444`, etc. Le choix conserve l'ID de la carte ; le récapitulatif affiche la même carte.

## Parcours et reprise

Le serveur calcule le paiement depuis le montant envoyé + les frais de la cotation. La V1 accepte les devises d'envoi EUR, USD et GBP, à deux décimales. La réception XAF/autres corridors reste simulée.

Une cotation crée au plus un PaymentIntent Stripe. Les appels rejoués réutilisent le même objet. Le serveur vérifie à nouveau le statut `succeeded`, le montant reçu, la devise, le client Stripe, le caractère test et le type de paiement. Pour une carte, il vérifie aussi que le token correspond exactement à la carte sélectionnée ; pour les wallets, il vérifie `apple_pay`/`google_pay`.

Le client et la reprise serveur utilisent la clé `stripe-<id-local-du-paiement>` pour confirmer le transfert. Toutes les minutes, le serveur rapproche les paiements restés sans confirmation du front : il termine le transfert simulé si la cotation reste utilisable, ou demande le remboursement de test si elle a expiré après paiement. Un transfert FAILED/CANCELLED financé est remboursé puis marqué REFUNDED après confirmation de Stripe. Un TIMEOUT/PENDING n'est pas automatiquement remboursé tant que le résultat de réception reste inconnu. Les erreurs de rapprochement sont retentées au passage suivant.

Le rapprochement périodique suffit à cette simulation. Avant une intégration de production, prévoir notamment les webhooks Stripe signés, les litiges et le rapprochement opérationnel. L'acceptation de l'activité de remittance par Stripe doit être clarifiée séparément ; le fonctionnement en test ne constitue pas un accord de production.

## Vérifier

- Enregistrer Visa `4242 4242 4242 4242` puis Mastercard `5555 5555 5555 4444`, avec date future et CVC de test.
- Les deux entrées doivent porter leurs quatre derniers chiffres. Sélectionner Mastercard et vérifier le récapitulatif et le token du PaymentIntent dans le dashboard.
- Tester les paiements card refusés/3DS avec les valeurs officielles Stripe. Pour un refus lors de l'enregistrement, aucun token local ne doit être créé.
- Annuler PaymentSheet : aucun transfert ne doit être confirmé.
- Tester PayPal en mode test, le retour à l'application et le rapprochement après fermeture du front.
- Tester Apple Pay et Google Pay séparément sur les appareils compatibles.
- Tester `TRANSFER_SIMULATION_SCENARIO=COMPLETED`, puis `REJECTED`, puis `TIMEOUT`. REJECTED doit conduire à un remboursement de test confirmé ; TIMEOUT reste en attente tant que la réception est inconnue.
- Côté back : `./mvnw test`. Côté front : `flutter analyze` et `flutter test`.

Validation effectuée : compilation Maven réussie, 18 tests unitaires Java réussis (dont 21 contrôles du financement), analyse syntaxique de 261 fichiers Dart et inspection des manifestes/diffs. Les tests Flutter et les transactions Stripe restent à exécuter localement avec les clés de test et des appareils compatibles.

## Références

- https://docs.stripe.com/testing
- https://docs.stripe.com/api/setup_intents
- https://docs.stripe.com/apple-pay?platform=ios
- https://docs.stripe.com/google-pay?platform=android
- https://docs.stripe.com/payments/paypal/accept-a-payment
- https://pub.dev/packages/flutter_stripe
