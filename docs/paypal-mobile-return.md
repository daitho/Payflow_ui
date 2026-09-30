# Retour PayPal vers PayFlow (sandbox)

Le backend fournit à PayPal `payflow://paypal/return?paymentIntentId=...`
et `payflow://paypal/cancel?paymentIntentId=...`. Configurez dans IntelliJ :

```text
PAYPAL_RETURN_URL=payflow://paypal/return
PAYPAL_CANCEL_URL=payflow://paypal/cancel
```

Supprimez les anciennes valeurs `localhost` ou `votre-backend` : les variables
d'environnement existantes remplacent les valeurs par défaut du backend.
Redémarrez ensuite le backend. Le schéma `payflow` doit être enregistré dans
iOS et Android ; après `flutter pub get`, réinstallez l'application sur le
téléphone (un hot reload ne recharge pas les manifestes natifs).

Pour tester : choisissez PayPal dans un nouveau transfert, vérifiez que le
récapitulatif affiche PayPal, approuvez avec le compte acheteur Sandbox.
Le lien de retour doit rouvrir PayFlow, puis l'application demande au backend
de capturer l'ordre et de confirmer le transfert. En cas d'annulation PayPal,
le retour ne lance aucune capture. Si le retour automatique n'arrive pas,
revenez manuellement dans PayFlow et utilisez « Vérifier » : le backend valide
l'approbation PayPal avant toute capture.

L'application accepte uniquement les liens contenant l'identifiant du paiement
en cours. Un nouveau test nécessite un nouveau devis ; le devis expire après
10 minutes. Le parcours avec application interrompue ou fermée pendant
l'approbation n'est pas encore repris automatiquement.
