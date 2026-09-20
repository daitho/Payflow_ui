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
