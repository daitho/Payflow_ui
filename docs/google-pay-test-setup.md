# Google Pay en test sur PayFlow

La capture du 6 octobre 2026 affiche : « Google Pay requires a Google account to be set up on this device. » Le SDK demande un compte Google configuré **dans Android**. Se connecter à PayFlow avec Google n'ajoute pas ce compte au système Android.

## Configurer l'appareil

1. Sur le téléphone Android : Paramètres → Comptes / Mots de passe et comptes → Ajouter un compte → Google. Les intitulés varient selon le fabricant. Terminer la connexion au compte utilisé pour les essais.
2. Ouvrir le Play Store et vérifier que ce compte est connecté. Mettre à jour Google Play Services et Google Wallet si des mises à jour sont proposées.
3. Tester de préférence sur un **téléphone Android physique** : c'est le parcours recommandé par Stripe. Si la capture vient d'un émulateur, utiliser une image avec Google Play pour ajouter un compte ; une image AOSP seule ne suffit pas. Valider le paiement final sur un téléphone physique.
4. Consulter la suite officielle de cartes de test Google Pay avec le même compte : https://developers.google.com/pay/api/android/guides/resources/test-card-suite . Suivre l'accès à la suite indiqué sur la page. Google indique que les cartes de test sont affichées par défaut en environnement TEST ; Stripe est une passerelle prise en charge.
5. Utiliser les **cartes de test de la passerelle Stripe** proposées dans la feuille Google Pay. La suite Google permet ces essais sans ajouter une vraie carte au compte. Ne pas saisir les numéros de test Stripe ordinaires dans Google Wallet. Si le contrôle de disponibilité du SDK exige encore un Wallet configuré, suivre le parcours physique documenté par Stripe avec une carte compatible dans Wallet, tout en conservant les clés Stripe de test et Google Pay en TEST.
6. Fermer complètement PayFlow puis le relancer pour renouveler le contrôle de disponibilité. Reprendre un transfert → Google Pay → Vérification → Confirmer.

## Configuration déjà présente dans le code

Dans `StripeTestFundingService` :

```dart
googlePay: const IsGooglePaySupportedParams(testEnv: true)
// Au lancement du paiement :
GooglePayParams(
  testEnv: true,
  merchantCountryCode: _country,
  merchantName: 'PayFlow',
  currencyCode: funding['currency'] as String,
)
```

Dans `android/app/src/main/AndroidManifest.xml`, à l'intérieur de `<application>` :

```xml
<meta-data
    android:name="com.google.android.gms.wallet.api.enabled"
    android:value="true" />
```

L'activité utilise déjà `FlutterFragmentActivity` et les thèmes AppCompat. Aucune modification du manifeste n'est nécessaire pour résoudre le message de la capture.

## Vérifier le backend

```text
STRIPE_TEST_ENABLED=true
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_MERCHANT_COUNTRY=FR
TRANSFER_GATEWAY=simulation
```

Les deux clés doivent provenir du même environnement de test Stripe. `FR` correspond au pays du marchand de ce projet, pas au pays du bénéficiaire. Adapter ce pays uniquement à la configuration réelle du compte marchand.

La réponse authentifiée de `GET /api/v1/payments/stripe-test/config` doit contenir `enabled: true`, une `publishableKey` commençant par `pk_test_` et le bon `merchantCountryCode`. Garder la clé secrète exclusivement côté serveur.

Après l'essai : vérifier le PaymentIntent réussi dans le dashboard Stripe de test, puis le transfert simulé dans PayFlow. Une annulation de Google Pay ne doit pas confirmer le transfert.

Pour un paiement réel ultérieur : demander l'accès production dans Google Pay & Wallet Console, avec intégration Gateway et captures de l'application, puis utiliser un build release signé et les clés live. Le service actuel est volontairement limité aux clés de test ; passer `testEnv` à `false` ne suffit pas à le convertir en production.

## Vérification de l'écran de transfert

La flèche de retour ferme le récapitulatif et conserve le bénéficiaire, le montant, la carte/le wallet et la cotation. Le retour système est également pris en charge. Pendant une confirmation, le bouton de retour est désactivé.

Ordre : bénéficiaire → téléphone → mode de réception → montant envoyé → mode d'envoi → frais → taux → montant reçu → total. Les moyens de paiement utilisent les mêmes lignes que les autres détails, avec une hauteur minimale de 56 pixels logiques et des logos de 56 × 28. Le texte peut augmenter la hauteur pour rester lisible à grande taille de police.

```bash
flutter test test/features/transfer/transfer_review_test.dart
flutter analyze
```

Huit tests de widget couvrent le retour avec conservation du formulaire, le retour système, la disposition des quatre modes d'envoi, le petit écran avec grande police et le paiement en cours. Ils restent à exécuter avec Flutter ; le SDK est absent de l'environnement de cette livraison.

Fichiers de cette modification :

- Modifié : `lib/features/transfer/presentation/view/transfer_view.dart`
- Ajouté : `test/features/transfer/transfer_review_test.dart`
- Ajouté : `docs/google-pay-test-setup.md`

## Références

- https://developers.google.com/pay/api/android/guides/resources/test-card-suite
- https://developers.google.com/pay/api/android/guides/setup
- https://docs.stripe.com/google-pay?platform=android
