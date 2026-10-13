# Contacts bénéficiaires

Branche : `feat/transfer-history-detail`.

La feature respecte le parcours View → ViewModel → Service → Repository → API Dio authentifiée. Les modèles du domaine ne dépendent pas de Flutter ou Dio.

L'onglet Contacts affiche le titre, la recherche, l'action d'ajout avec son icône, puis les bénéficiaires avec avatar, drapeau, numéro, opérateur, devise et crayon. La recherche ignore la casse et les accents latins. Une table de 26 couleurs associe A à Z à des couleurs distinctes et stables ; les autres initiales utilisent une couleur neutre. Le genre enregistré choisit l'icône homme/femme ; le genre absent utilise une icône neutre.

Routes protégées : `/beneficiaries/new` (vierge) et `/beneficiaries/:beneficiaryId/edit` (chargement des informations enregistrées). Le même formulaire sert aux deux. Pays et opérateurs viennent du serveur. Changer le pays efface l'ancien opérateur. Les erreurs conservent les champs saisis et les enregistrements en cours bloquent les doubles clics et le retour arrière. Une sauvegarde réussie recharge la liste.

Le bouton est « Ajouter un bénéficiaire » / « Enregistrer les modifications ». Le bouton « Ajouter et transférer » de la maquette sera branché au véritable parcours de transfert ; actuellement `_openTransfer` de HomePage ne fait qu'afficher une annonce de fonctionnalité à venir.

Le formulaire couvre les destinations Mobile Money. Les bénéficiaires bancaires restent dans la liste ; les destinations sans téléphone ne peuvent pas être enregistrées depuis ce formulaire.

Installer d'abord le backend et sa colonne `genre` décrits dans `docs/beneficiary-contacts.md` du backend. Aucun stockage local fictif ne remplace ces endpoints.

```sh
flutter gen-l10n
flutter analyze
flutter test test/features/beneficiaries/
```

Tests ajoutés : stabilité/unicité des couleurs, recherche accentuée, formulaire vierge/prérempli, remise à zéro de l'opérateur au changement de pays, conservation de l'identifiant et du genre, normalisation du téléphone, blocage des doubles clics.

Vérifications statiques réalisées : intégrité des traductions FR/EN et différences sans erreurs d'espacement. Flutter n'est pas installé dans l'environnement de préparation : ni analyse, ni tests Flutter, ni comparaison visuelle sur appareil n'ont été exécutés. Vérifier sur le téléphone les captures de référence, les petits écrans et la taille de texte agrandie.


## Sélection pays/opérateur renforcée

Branche `fix/beneficiary-country-operator`, basée sur `fix/stripe-payment-feedback`.
Les opérateurs sont filtrés par le pays du catalogue serveur et dédupliqués par ID
pour éviter les valeurs multiples du dropdown. Changer de pays remet l'opérateur
à zéro ; une sélection d'un opérateur d'un autre pays est refusée par le ViewModel.
L'édition d'un ancien contact conserve son historique mais efface la sélection si
l'opérateur ne figure plus dans le catalogue actif du pays. Le formulaire n'ajoute
plus cet ancien opérateur incompatible aux options. Un pays sans opérateur rend
le sélecteur indisponible et empêche l'enregistrement.

Les nouveaux pays, leurs opérateurs et les routes d'agrégateurs sont administrés
par les scripts backend documentés dans `docs/country-operator-aggregator-catalogue.md`.
Le formulaire Mobile Money reste limité aux corridors/taux et opérateurs disponibles ;
il n'affiche pas tous les pays de la table pays comme destinations transférables.

Tests de régression : `test/features/beneficiaries/beneficiary_country_operator_test.dart`
(changement de pays, opérateur étranger, doublons, ancien opérateur incompatible,
pays inconnu). Syntaxe Dart vérifiée ; `flutter test test/features/beneficiaries/`
non exécuté ici car le SDK Flutter est absent. Validation appareil à effectuer.
