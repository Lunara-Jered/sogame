# SOGAME EQUIP — application Flutter

Application client mobile basée sur l’interface de référence `index.html`.
Les produits sont des données fictives locales ; aucun backend ni service
d’envoi de devis n’est connecté.

## Lancer l’application

1. Installer le SDK Flutter.
2. Récupérer les dépendances : `flutter pub get`.
3. Générer les écrans de démarrage natifs après modification de leur
   configuration : `dart run flutter_native_splash:create`.
4. Lancer l’application : `flutter run`.

Le splashscreen Flutter reprend le logo animé et les trois points de la
référence. La configuration `flutter_native_splash` prépare les écrans de
démarrage natifs Android et iOS. Les icônes de l’application Android et iOS
reprennent également le logo officiel existant.

L’identifiant Android est `com.sogame.equip` et l’identifiant iOS est
`com.sogame.equip`. Aucune permission n’est demandée : l’application n’en a
pas besoin pour les fonctionnalités locales actuelles.

## Compilation

- Android debug : `flutter build apk --debug`.
- Android release universelle (ARM 32 et 64 bits, Android 5.0/API 21 minimum) :
  `flutter build apk --release --target-platform android-arm,android-arm64`.
- iOS : `flutter build ios` ou `flutter build ipa` sur macOS avec une version
  compatible de Xcode configurée. Le projet natif généré utilise les
  dépendances Swift Package Manager. La signature de distribution nécessite
  un compte Apple et une identité de signature de l’équipe.
- Pour une version Android release signée, créer une clé privée puis configurer
  `android/key.properties` (ignoré par Git) avec `storeFile`, `storePassword`,
  `keyAlias` et `keyPassword`. Sans ce fichier, une release n’utilise aucune
  clé de signature. Aucune clé de production n’est incluse dans le dépôt.
  Le workflow GitHub Actions attend la même clé au moyen des secrets
  `ANDROID_KEYSTORE_BASE64` (fichier JKS encodé en Base64),
  `ANDROID_STORE_PASSWORD`, `ANDROID_KEY_ALIAS` et `ANDROID_KEY_PASSWORD`.
  Les builds de pull request utilisent une APK Debug signée automatiquement ;
  les autres builds Android produisent et vérifient la signature de l’APK
  Release.

Les visuels fournis sont dans `assets/images/`. Aucun fichier photo de produit
n’existe dans le dépôt d’origine : les fiches conservent les pictogrammes SVG
intégrés dans `index.html`. Les polices Inter et Barlow Condensed sont
embarquées dans `assets/fonts/`, avec leurs licences OFL.
