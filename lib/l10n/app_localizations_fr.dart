// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'PayFlow';

  @override
  String get loginTagline => 'Transfert d\'argent,\nrapide, simple et sécurisé';

  @override
  String get emailOrPhone => 'Identifiant email';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get signIn => 'Se connecter';

  @override
  String get or => 'ou';

  @override
  String get noAccount => 'Pas encore de compte ?';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get emailOrPhoneRequired => 'Veuillez saisir votre email';

  @override
  String get passwordRequired => 'Veuillez saisir votre mot de passe';

  @override
  String get changeLanguage => 'Changer la langue';

  @override
  String get french => 'Français';

  @override
  String get english => 'Anglais';

  @override
  String get frenchSelected => 'Français sélectionné';

  @override
  String get englishSelected => 'Anglais sélectionné';

  @override
  String get signingIn => 'Connexion en cours...';

  @override
  String get signingInError =>
      'Erreur de connexion : vérifiez votre email ou mot de passe...';

  @override
  String get forgotPasswordMessage => 'Récupération du mot de passe';

  @override
  String socialLoginMessage(String provider) {
    return 'Connexion avec $provider';
  }

  @override
  String get createAccount => 'Créer mon compte';

  @override
  String get createYourAccount => 'Crée ton compte';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get firstNameRequired => 'Veuillez saisir votre prénom';

  @override
  String get lastNameRequired => 'Veuillez saisir votre nom';

  @override
  String get emailRequired => 'Veuillez saisir votre email';

  @override
  String get phoneRequired => 'Veuillez saisir votre numéro de téléphone';

  @override
  String get confirmPasswordRequired => 'Veuillez confirmer votre mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get acceptTermsPrefix => 'J\'accepte les';

  @override
  String get termsAndConditions => 'Conditions générales';

  @override
  String get and => 'et la';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsRequired =>
      'Vous devez accepter les conditions pour continuer';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get creatingAccount => 'Création du compte en cours...';

  @override
  String get passwordRequirementsTitle => 'Le mot de passe doit contenir :';

  @override
  String get passwordMinLength => 'Au moins 12 caractères';

  @override
  String get passwordUppercase => 'Une lettre majuscule';

  @override
  String get passwordLowercase => 'Une lettre minuscule';

  @override
  String get passwordDigit => 'Un chiffre';

  @override
  String get passwordSpecial => 'Un caractère spécial';

  @override
  String get passwordInvalid =>
      'Le mot de passe ne respecte pas les critères de sécurité';

  @override
  String get selectCountry => 'Sélectionner un pays';

  @override
  String get startupConnectionError =>
      'Impossible de se connecter à PayFlow. Vérifiez votre connexion et réessayez.';

  @override
  String get retry => 'Réessayer';

  @override
  String get invalidCredentials => 'Email ou mot de passe incorrect.';

  @override
  String get loginNetworkError =>
      'Impossible de se connecter à PayFlow. Vérifiez votre connexion internet.';

  @override
  String get loginTimeoutError =>
      'La connexion à PayFlow prend trop de temps. Réessayez.';

  @override
  String get loginServerError =>
      'PayFlow est momentanément indisponible. Réessayez dans quelques instants.';

  @override
  String get loginUnexpectedError =>
      'Une erreur inattendue est survenue. Réessayez.';

  @override
  String get profile => 'Profil';

  @override
  String get profileIdCopied => 'ID copié dans le presse-papiers';

  @override
  String get verified => 'Vérifié';

  @override
  String get notVerified => 'Non vérifié';

  @override
  String get myAccount => 'Mon compte';

  @override
  String get accountInformation => 'Informations sur le compte';

  @override
  String get accountInformationSubtitle =>
      'Gérez vos informations personnelles';

  @override
  String get verificationAndLimits => 'Vérification et limites';

  @override
  String get verificationAndLimitsSubtitle =>
      'Consultez votre niveau de vérification et vos limites';

  @override
  String get security => 'Sécurité';

  @override
  String get securityAndPrivacy => 'Sécurité et confidentialité';

  @override
  String get securityAndPrivacySubtitle =>
      'Mot de passe, biométrie et sessions';

  @override
  String get preferences => 'Préférences';

  @override
  String get notificationPreferences => 'Préférences de notification';

  @override
  String get notificationPreferencesSubtitle => 'Gérez vos alertes et messages';

  @override
  String get language => 'Langue';

  @override
  String get languageSubtitle => 'Choisissez la langue de l’application';

  @override
  String get help => 'Aide';

  @override
  String get helpAndSupport => 'Aide et support';

  @override
  String get helpAndSupportSubtitle => 'Obtenez de l’aide avec PayFlow';

  @override
  String get about => 'À propos';

  @override
  String get aboutSubtitle =>
      'Conditions, confidentialité et informations PayFlow';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get authentication => 'Authentification';

  @override
  String get biometrics => 'Biométrie';

  @override
  String get biometricsSubtitle => 'Face ID, Touch ID ou empreinte digitale';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get changePasswordSubtitle =>
      'Modifiez le mot de passe de votre compte';

  @override
  String get sessionsAndDevices => 'Sessions et appareils';

  @override
  String get thisDeviceSubtitle => 'Session PayFlow actuellement utilisée';

  @override
  String get activeSessions => 'Sessions actives';

  @override
  String get activeSessionsSubtitle =>
      'Consultez les appareils connectés à votre compte';

  @override
  String get disconnectOtherDevices => 'Déconnecter les autres appareils';

  @override
  String get disconnectOtherDevicesSubtitle =>
      'Révoquez toutes les autres sessions';

  @override
  String get biometricPrivacyInfo =>
      'Vos données biométriques restent sur votre appareil. PayFlow ne reçoit ni votre visage ni votre empreinte.';

  @override
  String get checkingBiometrics => 'Vérification de la biométrie...';

  @override
  String get biometricsUnavailable =>
      'Aucune biométrie n’est configurée sur cet appareil.';

  @override
  String get enableBiometricsReason =>
      'Authentifiez-vous pour activer la biométrie PayFlow.';

  @override
  String get disableBiometricsReason =>
      'Authentifiez-vous pour désactiver la biométrie PayFlow.';

  @override
  String get biometricAuthenticationFailed =>
      'L’authentification biométrique n’a pas été validée.';

  @override
  String get biometricTechnicalError =>
      'Impossible de modifier la biométrie pour le moment.';

  @override
  String get unlockPayFlowBiometricReason =>
      'Authentifiez-vous pour accéder à PayFlow.';

  @override
  String get biometricUnlockFailed =>
      'L’authentification biométrique n’a pas été validée.';

  @override
  String get biometricUnlockUnavailable =>
      'La biométrie activée pour PayFlow n’est plus disponible sur cet appareil.';

  @override
  String get retryBiometric => 'Réessayer';

  @override
  String get activeSessionsTitle => 'Sessions actives';

  @override
  String get noActiveSessions => 'Aucune session active.';

  @override
  String get thisDevice => 'Cet appareil';

  @override
  String get currentSession => 'ACTUEL';

  @override
  String get lastActivity => 'Dernière activité';

  @override
  String get sessionCreated => 'Connexion';

  @override
  String get sessionExpires => 'Expiration';

  @override
  String get ipAddress => 'Adresse IP';

  @override
  String get unknownDevice => 'Appareil inconnu';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get cancel => 'Annuler';

  @override
  String get revokeSessionTitle => 'Déconnecter cet appareil ?';

  @override
  String revokeSessionMessage(String deviceName) {
    return 'La session de $deviceName sera révoquée et cet appareil devra se reconnecter.';
  }

  @override
  String get sessionRevokedSuccess => 'L’appareil a été déconnecté.';

  @override
  String get activeSessionsNetworkError =>
      'Impossible de charger les sessions. Vérifiez votre connexion.';

  @override
  String get activeSessionsUnauthorized =>
      'Votre session n’est plus valide. Veuillez vous reconnecter.';

  @override
  String get activeSessionsServerError =>
      'Le service est momentanément indisponible.';

  @override
  String get activeSessionsUnexpectedError =>
      'Impossible de gérer les sessions pour le moment.';

  @override
  String get disconnectOtherDevicesConfirmTitle =>
      'Déconnecter les autres appareils ?';

  @override
  String get disconnectOtherDevicesConfirmMessage =>
      'Toutes vos autres sessions PayFlow seront déconnectées. Cet appareil restera connecté.';

  @override
  String get disconnectOtherDevicesSuccess =>
      'Les autres appareils ont été déconnectés.';

  @override
  String get currentDeviceTitle => 'Cet appareil';

  @override
  String get currentDeviceLoadError =>
      'Impossible de récupérer les informations de cet appareil.';

  @override
  String get deviceStatus => 'Statut';

  @override
  String get deviceActive => 'Actif';

  @override
  String get deviceIdentifier => 'Identifiant de l’appareil';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get logoutCurrentDevice => 'Se déconnecter de cet appareil';

  @override
  String get logoutCurrentDeviceSubtitle =>
      'Votre session PayFlow sera fermée sur cet appareil.';

  @override
  String get logoutCurrentDeviceConfirmTitle => 'Se déconnecter ?';

  @override
  String get logoutCurrentDeviceConfirmMessage =>
      'Vous devrez vous authentifier de nouveau pour accéder à PayFlow sur cet appareil.';

  @override
  String get logoutCurrentDeviceNetworkError =>
      'Impossible de se déconnecter. Vérifiez votre connexion et réessayez.';

  @override
  String get logoutCurrentDeviceServerError =>
      'Le service de déconnexion est momentanément indisponible.';

  @override
  String get logoutCurrentDeviceUnexpectedError =>
      'Impossible de se déconnecter pour le moment.';

  @override
  String get homeWelcome => 'Bienvenue,';

  @override
  String get homeLastRateUsed => 'Dernier taux utilisé';

  @override
  String get homeAvailableRate => 'Taux disponible';

  @override
  String get homeExchangeRate => 'Taux de change';

  @override
  String get homeNoRateAvailable => 'Aucun taux disponible actuellement';

  @override
  String get homeMainCurrency => 'Devise principale';

  @override
  String get homeRecentBeneficiaries => 'Envoyer encore de l’argent à';

  @override
  String get homeSeeMore => 'Plus';

  @override
  String get homeRecentTransactions => 'Historique des transactions';

  @override
  String get homeViewAll => 'Voir plus';

  @override
  String get homeNewTransfer => 'Nouveau transfert';

  @override
  String get homeNoRecentBeneficiaries => 'Aucun bénéficiaire récent.';

  @override
  String get homeNoRecentTransactions => 'Aucune transaction récente.';

  @override
  String get homeLoadErrorTitle => 'Impossible de charger l’accueil';

  @override
  String get homeRetry => 'Réessayer';

  @override
  String get homeNetworkError =>
      'Vérifiez votre connexion Internet puis réessayez.';

  @override
  String get homeTimeoutError =>
      'Le serveur met trop de temps à répondre. Réessayez.';

  @override
  String get homeServerError =>
      'Une erreur serveur est survenue. Réessayez dans quelques instants.';

  @override
  String get homeSessionExpiredError => 'Votre session a expiré.';

  @override
  String get homeInvalidResponseError => 'Les données reçues sont invalides.';

  @override
  String get homeUnexpectedError => 'Une erreur inattendue est survenue.';

  @override
  String get homeStatusCreated => 'Créée';

  @override
  String get homeStatusPending => 'En attente';

  @override
  String get homeStatusProcessing => 'En cours';

  @override
  String get homeStatusCompleted => 'Terminée';

  @override
  String get homeStatusFailed => 'Échouée';

  @override
  String get homeStatusCancelled => 'Annulée';

  @override
  String get homeStatusRefunded => 'Remboursée';

  @override
  String get homeTab => 'Accueil';

  @override
  String get transfersTab => 'Transferts';

  @override
  String get contactsTab => 'Contacts';

  @override
  String get profileTab => 'Profil';

  @override
  String get referralTab => 'Parrainer';

  @override
  String get transferAction => 'Transfert';

  @override
  String get homeSelectBeneficiaryHint =>
      'Sélectionnez un bénéficiaire ci-dessous ou lancez un transfert.';

  @override
  String get homeSelectedBeneficiary => 'Bénéficiaire sélectionné';

  @override
  String get homeViewMoreTransactions => 'Voir plus';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get homeExchangeRateSubtitle => 'Exchange Rate';

  @override
  String get homeBeneficiaryLabel => 'BÉNÉFICIAIRE';

  @override
  String get exchangeRatesTitle => 'Taux de change';

  @override
  String get exchangeRatesSearchHint => 'Rechercher un pays ou une devise';

  @override
  String get exchangeRatesEmpty => 'Aucun taux disponible pour le moment.';

  @override
  String get exchangeRatesNoSearchResult =>
      'Aucun taux ne correspond à votre recherche.';

  @override
  String get exchangeRatesLoadError =>
      'Impossible de charger les taux de change.';

  @override
  String get exchangeRatesRefreshError => 'Impossible d’actualiser les taux.';

  @override
  String get exchangeRatesRetry => 'Réessayer';

  @override
  String exchangeRateCorridor(String sourceCountry, String destinationCountry) {
    return '$sourceCountry → $destinationCountry';
  }

  @override
  String exchangeRateEquation(
    String sourceCurrency,
    String rate,
    String targetCurrency,
  ) {
    return '1 $sourceCurrency = $rate $targetCurrency';
  }

  @override
  String get transferHistoryTitle => 'Transactions';

  @override
  String get transferDetailTitle => 'Détail du transfert';

  @override
  String get transferNotFound => 'Ce transfert est introuvable.';

  @override
  String get transferStatusCreated => 'Créé';

  @override
  String get transferStatusPending => 'En attente';

  @override
  String get transferStatusProcessing => 'En cours';

  @override
  String get transferStatusCompleted => 'Terminé';

  @override
  String get transferStatusFailed => 'Échoué';

  @override
  String get transferStatusCancelled => 'Annulé';

  @override
  String get transferStatusRefunded => 'Remboursé';

  @override
  String get transferStatusUnknown => 'Statut inconnu';

  @override
  String get transferBeneficiary => 'Bénéficiaire';

  @override
  String get transferAllBeneficiaries => 'Tous les bénéficiaires';

  @override
  String get transferStatusLabel => 'Statut';

  @override
  String get transferAllStatuses => 'Tous les statuts';

  @override
  String get transferResetFilters => 'Réinitialiser les filtres';

  @override
  String get transferCountLabel => 'Total des transactions';

  @override
  String get transferSentTotalLabel => 'Total envoyé par devise';

  @override
  String get transferHistoryEmpty =>
      'Aucun transfert ne correspond à votre recherche.';

  @override
  String get transferLoadMore => 'Charger la suite';

  @override
  String get transferRecipientName => 'Nom';

  @override
  String get transferCountry => 'Pays';

  @override
  String get transferOperator => 'Opérateur';

  @override
  String get transferDestination => 'Destination';

  @override
  String get transferAmounts => 'Montants';

  @override
  String get transferSent => 'Montant envoyé';

  @override
  String transferSentTo(String amount, String beneficiary) {
    return 'Vous avez envoyé $amount à $beneficiary';
  }

  @override
  String get transferFee => 'Frais';

  @override
  String get transferTotalCharged => 'Total débité';

  @override
  String get transferRate => 'Taux appliqué';

  @override
  String get transferReceived => 'Montant à recevoir';

  @override
  String get transferTracking => 'Suivi du transfert';

  @override
  String get transferReference => 'Référence';

  @override
  String get transferCreatedAt => 'Créé le';

  @override
  String get transferExport => 'Exporter';

  @override
  String get transferReceiptAction => 'Voir / exporter le reçu';

  @override
  String get transferRepeatAction => 'Répéter le transfert';

  @override
  String get transferProviderReference => 'Confirmation opérateur';

  @override
  String get transferTotalAmount => 'Montant total';

  @override
  String get transferTimelineUnavailable =>
      'Le suivi détaillé est indisponible pour ce transfert.';

  @override
  String get transferTrackingCompleted =>
      'Les fonds ont été remis au bénéficiaire.';

  @override
  String get transferTrackingFailed =>
      'Le transfert a échoué. Le suivi disponible ne précise pas la situation du débit ou du remboursement.';

  @override
  String get transferTrackingCancelled =>
      'Le transfert est annulé. Le suivi disponible ne précise pas la situation du débit ou du remboursement.';

  @override
  String get transferTrackingRefunded =>
      'Le transfert est indiqué comme remboursé.';

  @override
  String get transferTrackingPending =>
      'Le transfert est en cours de traitement. Sa réception n’est pas encore confirmée.';

  @override
  String get transferYearLabel => 'Année';

  @override
  String get transferAllYears => 'Toutes les années';

  @override
  String get contactTitle => 'Bénéficiaire';

  @override
  String get contactSearch => 'Entrer le nom à rechercher…';

  @override
  String get contactAdd => 'Ajouter un bénéficiaire';

  @override
  String get contactSection => 'VOS BÉNÉFICIAIRES';

  @override
  String get contactNew => 'Nouveau Bénéficiaire';

  @override
  String get contactEdit => 'Modifier le bénéficiaire';

  @override
  String get contactInformation => 'Informations du contact';

  @override
  String get contactFullName => 'Nom complet';

  @override
  String get contactPhone => 'Numéro de téléphone';

  @override
  String get contactCountry => 'Pays';

  @override
  String get contactOperator => 'Opérateur';

  @override
  String get contactGender => 'Genre';

  @override
  String get contactMale => 'Homme';

  @override
  String get contactFemale => 'Femme';

  @override
  String get contactUnspecified => 'Non renseigné';

  @override
  String get contactSave => 'Enregistrer les modifications';

  @override
  String get contactEmpty => 'Aucun bénéficiaire trouvé.';

  @override
  String get contactNoPhone => 'Numéro non renseigné';

  @override
  String get contactChoose => 'Choisir';

  @override
  String get contactRequired => 'Champ obligatoire';

  @override
  String get contactNameTooLong => '120 caractères maximum';

  @override
  String get contactPhoneInvalid =>
      'Saisissez le numéro avec son indicatif, par exemple +237…';

  @override
  String get contactNoOperators => 'Aucun opérateur Mobile Money disponible.';

  @override
  String get contactNetworkError =>
      'Connexion indisponible. Vérifiez votre réseau.';

  @override
  String get contactSessionError => 'Votre session a expiré. Reconnectez-vous.';

  @override
  String get contactInvalidError =>
      'Vérifiez le numéro, le pays et l’opérateur. Un contact avec plusieurs destinations ne peut pas changer de pays ici.';

  @override
  String get contactNotFoundError =>
      'Ce bénéficiaire ou cet opérateur n’est plus disponible.';

  @override
  String get contactServerError =>
      'Impossible de terminer cette action. Réessayez.';

  @override
  String get contactUnavailable =>
      'Cette destination n’est pas modifiable dans le formulaire Mobile Money.';

  @override
  String get transferSendTitle => 'Envoyer de l\'argent';

  @override
  String get transferChooseBeneficiary => 'Choisir un bénéficiaire';

  @override
  String get transferYouSend => 'Vous envoyez';

  @override
  String get transferAmountReceived => 'Montant reçu';

  @override
  String get transferFundingLabel => 'Mode d\'envoi';

  @override
  String get transferFundingCard => 'Carte bancaire';

  @override
  String get transferCurrentRate => 'Taux de change';

  @override
  String get transferChooseForQuote =>
      'Choisissez un bénéficiaire pour calculer le taux et les frais.';

  @override
  String get transferContinue => 'Continuer à envoyer';

  @override
  String get transferReviewTitle => 'Vérifiez votre transfert';

  @override
  String get transferTrustWarning =>
      'Connaissez-vous cette personne ? Assurez-vous d\'envoyer de l\'argent à une personne de confiance et que ses informations sont exactes.';

  @override
  String get transferConfirm => 'Confirmer le transfert';

  @override
  String get transferInvalidError =>
      'Vérifiez le bénéficiaire et le montant saisi.';

  @override
  String get transferBeneficiaryUnavailable =>
      'Ce bénéficiaire ou sa destination n’est plus disponible.';

  @override
  String get transferConflictError =>
      'Ce transfert a déjà été confirmé ou ne peut plus être utilisé.';

  @override
  String get transferQuoteExpired =>
      'Le taux a expiré. Une nouvelle cotation va être calculée.';

  @override
  String get transferUnavailableError =>
      'Ce transfert n’est pas disponible pour ce bénéficiaire ou ce montant.';
}
