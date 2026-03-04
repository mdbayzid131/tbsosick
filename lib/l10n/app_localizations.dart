import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @stopRelyingTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop Relying on Loose Paper'**
  String get stopRelyingTitle;

  /// No description provided for @stopRelyingDesc.
  ///
  /// In en, this message translates to:
  /// **'SMRTSCRUB keeps your surgical notes organized and accessible'**
  String get stopRelyingDesc;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @scrubPocketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Scrub Pockets Made for Phones'**
  String get scrubPocketsTitle;

  /// No description provided for @scrubPocketsDesc.
  ///
  /// In en, this message translates to:
  /// **'Not messy notepads. Minimalist UI designed for the high-pressure OR environment.'**
  String get scrubPocketsDesc;

  /// No description provided for @secureTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure & Compliant'**
  String get secureTitle;

  /// No description provided for @secureDesc.
  ///
  /// In en, this message translates to:
  /// **'No patient info needed. Your preference cards stay private and protected.'**
  String get secureDesc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SMRTSCRUB'**
  String get welcome;

  /// No description provided for @startWithName.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start with your name'**
  String get startWithName;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_button;

  /// No description provided for @specialtyQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s Your Specialty?'**
  String get specialtyQuestion;

  /// No description provided for @orthopedicSurgery.
  ///
  /// In en, this message translates to:
  /// **'Orthopedic Surgery'**
  String get orthopedicSurgery;

  /// No description provided for @cardiacSurgery.
  ///
  /// In en, this message translates to:
  /// **'Cardiac Surgery'**
  String get cardiacSurgery;

  /// No description provided for @generalSurgery.
  ///
  /// In en, this message translates to:
  /// **'General Surgery'**
  String get generalSurgery;

  /// No description provided for @neurosurgery.
  ///
  /// In en, this message translates to:
  /// **'Neurosurgery'**
  String get neurosurgery;

  /// No description provided for @plasticSurgery.
  ///
  /// In en, this message translates to:
  /// **'Plastic Surgery'**
  String get plasticSurgery;

  /// No description provided for @vascularSurgery.
  ///
  /// In en, this message translates to:
  /// **'Vascular Surgery'**
  String get vascularSurgery;

  /// No description provided for @thoracicSurgery.
  ///
  /// In en, this message translates to:
  /// **'Thoracic Surgery'**
  String get thoracicSurgery;

  /// No description provided for @pediatricSurgery.
  ///
  /// In en, this message translates to:
  /// **'Pediatric Surgery'**
  String get pediatricSurgery;

  /// No description provided for @noteMethodQuestion.
  ///
  /// In en, this message translates to:
  /// **'Preferred Note Method?'**
  String get noteMethodQuestion;

  /// No description provided for @chooseInputMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose your default input method'**
  String get chooseInputMethod;

  /// No description provided for @voiceToText.
  ///
  /// In en, this message translates to:
  /// **'Voice-to-Text'**
  String get voiceToText;

  /// No description provided for @voiceToTextDesc.
  ///
  /// In en, this message translates to:
  /// **'Dictate notes hands-free'**
  String get voiceToTextDesc;

  /// No description provided for @rapidChecklist.
  ///
  /// In en, this message translates to:
  /// **'Rapid Checklist'**
  String get rapidChecklist;

  /// No description provided for @rapidChecklistDesc.
  ///
  /// In en, this message translates to:
  /// **'Quick tap-through templates'**
  String get rapidChecklistDesc;

  /// No description provided for @freehandEntry.
  ///
  /// In en, this message translates to:
  /// **'Freehand Entry'**
  String get freehandEntry;

  /// No description provided for @freehandEntryDesc.
  ///
  /// In en, this message translates to:
  /// **'Type custom notes'**
  String get freehandEntryDesc;

  /// No description provided for @interactiveTutorial.
  ///
  /// In en, this message translates to:
  /// **'Interactive Tutorial'**
  String get interactiveTutorial;

  /// No description provided for @tutorialTime.
  ///
  /// In en, this message translates to:
  /// **'30 seconds to master'**
  String get tutorialTime;

  /// No description provided for @createFirstCard.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Create Your First Card'**
  String get createFirstCard;

  /// No description provided for @tutorialFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow along with this quick 30-second tutorial'**
  String get tutorialFollow;

  /// No description provided for @quickStartGuide.
  ///
  /// In en, this message translates to:
  /// **'Quick Start Guide'**
  String get quickStartGuide;

  /// No description provided for @quickStartDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn the basics in under 30 seconds'**
  String get quickStartDesc;

  /// No description provided for @startProcedure.
  ///
  /// In en, this message translates to:
  /// **'Start a new procedure'**
  String get startProcedure;

  /// No description provided for @logKeyMoments.
  ///
  /// In en, this message translates to:
  /// **'Log key moments'**
  String get logKeyMoments;

  /// No description provided for @addVoiceNotes.
  ///
  /// In en, this message translates to:
  /// **'Add voice notes'**
  String get addVoiceNotes;

  /// No description provided for @finalizeCard.
  ///
  /// In en, this message translates to:
  /// **'Finalize your card'**
  String get finalizeCard;

  /// No description provided for @tapStartProcedure.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Start Procedure\" to begin'**
  String get tapStartProcedure;

  /// No description provided for @logImportantMoments.
  ///
  /// In en, this message translates to:
  /// **'Log Important Moments'**
  String get logImportantMoments;

  /// No description provided for @trackMilestones.
  ///
  /// In en, this message translates to:
  /// **'Track key surgical milestones with one tap'**
  String get trackMilestones;

  /// No description provided for @newProcedure.
  ///
  /// In en, this message translates to:
  /// **'New Procedure'**
  String get newProcedure;

  /// No description provided for @totalKneeReplacement.
  ///
  /// In en, this message translates to:
  /// **'Total Knee Replacement'**
  String get totalKneeReplacement;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @timeOutRequired.
  ///
  /// In en, this message translates to:
  /// **'Time Out Required'**
  String get timeOutRequired;

  /// No description provided for @tip.
  ///
  /// In en, this message translates to:
  /// **'Tip:'**
  String get tip;

  /// No description provided for @timelineTip.
  ///
  /// In en, this message translates to:
  /// **'Quick-tap milestones to maintain accurate surgical timeline'**
  String get timelineTip;

  /// No description provided for @tapTimeOut.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Time Out\" to log the safety checklist'**
  String get tapTimeOut;

  /// No description provided for @timeOut.
  ///
  /// In en, this message translates to:
  /// **'Time Out'**
  String get timeOut;

  /// No description provided for @skipTutorial.
  ///
  /// In en, this message translates to:
  /// **'Skip Tutorial'**
  String get skipTutorial;

  /// No description provided for @addVoiceNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Voice Notes'**
  String get addVoiceNotesTitle;

  /// No description provided for @dictateHandsFree.
  ///
  /// In en, this message translates to:
  /// **'Dictate instrument preferences hands-free'**
  String get dictateHandsFree;

  /// No description provided for @voiceNote.
  ///
  /// In en, this message translates to:
  /// **'Voice Note'**
  String get voiceNote;

  /// No description provided for @holdToRecordDesc.
  ///
  /// In en, this message translates to:
  /// **'Hold button to record hands-free'**
  String get holdToRecordDesc;

  /// No description provided for @worksWithGloves.
  ///
  /// In en, this message translates to:
  /// **'Works with surgical gloves'**
  String get worksWithGloves;

  /// No description provided for @autoSave.
  ///
  /// In en, this message translates to:
  /// **'Auto-saves to your preference card'**
  String get autoSave;

  /// No description provided for @hipaaCompliant.
  ///
  /// In en, this message translates to:
  /// **'HIPAA compliant - no patient data'**
  String get hipaaCompliant;

  /// No description provided for @holdPreference.
  ///
  /// In en, this message translates to:
  /// **'Hold to record your instrument preference'**
  String get holdPreference;

  /// No description provided for @holdToRecord.
  ///
  /// In en, this message translates to:
  /// **'Hold to Record'**
  String get holdToRecord;

  /// No description provided for @reviewCard.
  ///
  /// In en, this message translates to:
  /// **'Review Your Card'**
  String get reviewCard;

  /// No description provided for @formattedCard.
  ///
  /// In en, this message translates to:
  /// **'See your clean, formatted preference card'**
  String get formattedCard;

  /// No description provided for @preferenceCardSummary.
  ///
  /// In en, this message translates to:
  /// **'Preference Card Summary'**
  String get preferenceCardSummary;

  /// No description provided for @reviewFinalize.
  ///
  /// In en, this message translates to:
  /// **'Review and finalize'**
  String get reviewFinalize;

  /// No description provided for @procedure.
  ///
  /// In en, this message translates to:
  /// **'Procedure'**
  String get procedure;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @instrumentNotes.
  ///
  /// In en, this message translates to:
  /// **'Instrument Notes'**
  String get instrumentNotes;

  /// No description provided for @instrumentExample.
  ///
  /// In en, this message translates to:
  /// **'Prefer DeBakey forceps and Metzenbaum scissors for this procedure'**
  String get instrumentExample;

  /// No description provided for @tapFinalize.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Finalize\" to complete'**
  String get tapFinalize;

  /// No description provided for @finalize.
  ///
  /// In en, this message translates to:
  /// **'Finalize Card'**
  String get finalize;

  /// No description provided for @otpVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Verify'**
  String get otpVerifyTitle;

  /// No description provided for @otpSentDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your OTP code sent to your email address.'**
  String get otpSentDesc;

  /// No description provided for @otpLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otpLabel;

  /// No description provided for @otpVerifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Otp Verify Success'**
  String get otpVerifySuccess;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordDesc;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email!'**
  String get passwordResetSent;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'SURGICAL CASE LOG & PREFERENCE CARDS'**
  String get appDescription;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordButton;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orText;

  /// No description provided for @continueApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueApple;

  /// No description provided for @continueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @termsPolicyText.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to SMRTSCRUB s Terms of service and Privacy policy'**
  String get termsPolicyText;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @selectCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Select your country'**
  String get selectCountryHint;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @choosePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a Plan'**
  String get choosePlanTitle;

  /// No description provided for @unlockSmrtscrub.
  ///
  /// In en, this message translates to:
  /// **'Unlock SMRTSCRUB'**
  String get unlockSmrtscrub;

  /// No description provided for @chooseWorksForYou.
  ///
  /// In en, this message translates to:
  /// **'Choose the plan that works for you'**
  String get chooseWorksForYou;

  /// No description provided for @freePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freePlanTitle;

  /// No description provided for @premiumPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumPlanTitle;

  /// No description provided for @enterprisePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise'**
  String get enterprisePlanTitle;

  /// No description provided for @popularBadge.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popularBadge;

  /// No description provided for @monthLabel.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get monthLabel;

  /// No description provided for @continueWithFree.
  ///
  /// In en, this message translates to:
  /// **'Continue with free'**
  String get continueWithFree;

  /// No description provided for @continueWithPremium.
  ///
  /// In en, this message translates to:
  /// **'Continue with premium'**
  String get continueWithPremium;

  /// No description provided for @continueWithEnterprise.
  ///
  /// In en, this message translates to:
  /// **'Continue with enterprise'**
  String get continueWithEnterprise;

  /// No description provided for @featureBasicCards.
  ///
  /// In en, this message translates to:
  /// **'2 basic preference cards'**
  String get featureBasicCards;

  /// No description provided for @featureNoLibrary.
  ///
  /// In en, this message translates to:
  /// **'No library access'**
  String get featureNoLibrary;

  /// No description provided for @featureNoCalendar.
  ///
  /// In en, this message translates to:
  /// **'No calendar'**
  String get featureNoCalendar;

  /// No description provided for @featureEmailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email support'**
  String get featureEmailSupport;

  /// No description provided for @featurePremiumCards.
  ///
  /// In en, this message translates to:
  /// **'20 preference cards'**
  String get featurePremiumCards;

  /// No description provided for @featureBasicCalendar.
  ///
  /// In en, this message translates to:
  /// **'Basic calendar'**
  String get featureBasicCalendar;

  /// No description provided for @featurePublicLibrary.
  ///
  /// In en, this message translates to:
  /// **'Access to public library (upload & download)'**
  String get featurePublicLibrary;

  /// No description provided for @featureNoCollaboration.
  ///
  /// In en, this message translates to:
  /// **'No team collaboration'**
  String get featureNoCollaboration;

  /// No description provided for @featureNoVerifiedCard.
  ///
  /// In en, this message translates to:
  /// **'No verified card'**
  String get featureNoVerifiedCard;

  /// No description provided for @featureUnlimitedCards.
  ///
  /// In en, this message translates to:
  /// **'Unlimited cards'**
  String get featureUnlimitedCards;

  /// No description provided for @featureAdvancedCalendar.
  ///
  /// In en, this message translates to:
  /// **'Advanced calendar'**
  String get featureAdvancedCalendar;

  /// No description provided for @featureTeamCollaboration.
  ///
  /// In en, this message translates to:
  /// **'Team collaboration'**
  String get featureTeamCollaboration;

  /// No description provided for @featureVerifiedCards.
  ///
  /// In en, this message translates to:
  /// **'Verified preference cards'**
  String get featureVerifiedCards;

  /// No description provided for @languageRegion.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get languageRegion;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
