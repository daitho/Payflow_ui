# Filtre année de l'historique

Branche : `feat/transfer-history-detail`.

Le bénéficiaire est une liste déroulante pleine largeur. Statut et Année sont deux listes déroulantes côte à côte ; elles s'empilent si la largeur ou l'agrandissement du texte l'exige. Chaque sélection conserve les deux autres filtres. « Toutes les années » omet le paramètre `year`.

Les options d'années viennent du champ `availableYears` de l'API et sont triées de la plus récente à la plus ancienne. Elles ne sont pas déduites des pages chargées. Le backend utilise l'année de création en UTC.

Le filtre est transmis à la liste paginée et à l'export PDF. Un changement recharge la page zéro et le résumé serveur ; les totaux restent séparés par devise. L'export continue de bloquer les changements de filtre pendant sa génération.

Déployer d'abord le backend avec le support de `year` et `availableYears`. L'absence de ce dernier champ dans une ancienne réponse reste tolérée, mais ne fournit aucune année sélectionnable.

```sh
flutter gen-l10n
flutter analyze
flutter test test/features/transfer_history/
```

Les tests Flutter n'ont pas été exécutés dans l'environnement de préparation (SDK absent). Les tests ajoutés couvrent la sélection et la remise à zéro de l'année, la conservation des autres filtres, la transmission HTTP et les options du serveur sur un résultat vide.
