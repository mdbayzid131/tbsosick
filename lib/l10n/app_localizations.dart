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

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get account;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacyAndSecurity;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @specialtyNotSet.
  ///
  /// In en, this message translates to:
  /// **'Specialty not set'**
  String get specialtyNotSet;

  /// No description provided for @hospitalNotSet.
  ///
  /// In en, this message translates to:
  /// **'Hospital not set'**
  String get hospitalNotSet;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// No description provided for @john.
  ///
  /// In en, this message translates to:
  /// **'Jon'**
  String get john;

  /// No description provided for @doe.
  ///
  /// In en, this message translates to:
  /// **'Doe'**
  String get doe;

  /// No description provided for @specialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialty;

  /// No description provided for @cityHospital.
  ///
  /// In en, this message translates to:
  /// **'City Hospital'**
  String get cityHospital;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospital;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'john.doe@example.com'**
  String get emailPlaceholder;

  /// No description provided for @phonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'(555) 987-6543'**
  String get phonePlaceholder;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @shareData.
  ///
  /// In en, this message translates to:
  /// **'Share Data'**
  String get shareData;

  /// No description provided for @shareDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Allow SMRTSCRUB to share your data with third parties.'**
  String get shareDataDesc;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @emailNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications via email.'**
  String get emailNotificationsDesc;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications on your device.'**
  String get pushNotificationsDesc;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cardNumberPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'1234 5678 9012 3456'**
  String get cardNumberPlaceholder;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @expiryDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'MM/YY'**
  String get expiryDatePlaceholder;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @johnDoePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get johnDoePlaceholder;

  /// No description provided for @cardholderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get cardholderName;

  /// No description provided for @updatePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Update Payment Method'**
  String get updatePaymentMethod;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirm;

  /// No description provided for @signOutDesc.
  ///
  /// In en, this message translates to:
  /// **'You will be logged out of your account and will need to sign in again to access the service.'**
  String get signOutDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @terms1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Acceptance of Terms'**
  String get terms1Title;

  /// No description provided for @terms1Desc.
  ///
  /// In en, this message translates to:
  /// **'By using the SMRTSCRUB service, you agree to be bound by these Terms of Service.'**
  String get terms1Desc;

  /// No description provided for @terms2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Use of Service'**
  String get terms2Title;

  /// No description provided for @terms2Desc.
  ///
  /// In en, this message translates to:
  /// **'You agree to use the service only for lawful purposes and in a manner that does not infringe the rights of, or restrict or inhibit the use and enjoyment of the service by any third party.'**
  String get terms2Desc;

  /// No description provided for @terms3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Privacy Policy'**
  String get terms3Title;

  /// No description provided for @terms3Desc.
  ///
  /// In en, this message translates to:
  /// **'Your use of the service is also governed by our Privacy Policy, which is incorporated into these Terms of Service.'**
  String get terms3Desc;

  /// No description provided for @terms4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Termination'**
  String get terms4Title;

  /// No description provided for @terms4Desc.
  ///
  /// In en, this message translates to:
  /// **'We may terminate or suspend access to the service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms of Service.'**
  String get terms4Desc;

  /// No description provided for @terms5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Disclaimer of Warranties'**
  String get terms5Title;

  /// No description provided for @terms5Desc.
  ///
  /// In en, this message translates to:
  /// **'The service is provided on an \"as is\" and \"as available\" basis. We make no representations or warranties of any kind, express or implied, about the operation of the service, or the information, content, materials, or products included on the service.'**
  String get terms5Desc;

  /// No description provided for @terms6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Limitation of Liability'**
  String get terms6Title;

  /// No description provided for @terms6Desc.
  ///
  /// In en, this message translates to:
  /// **'In no event will we be liable for any loss or damage including without limitation, indirect or consequential loss or damage, or any loss or damage whatsoever arising from loss of data or profits arising out of or in connection with the use of this service.'**
  String get terms6Desc;

  /// No description provided for @terms7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Governing Law'**
  String get terms7Title;

  /// No description provided for @terms7Desc.
  ///
  /// In en, this message translates to:
  /// **'These Terms of Service shall be governed by and construed in accordance with the laws of the State of California, without regard to its conflict of law principles.'**
  String get terms7Desc;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get goodEvening;

  /// No description provided for @goodNight.
  ///
  /// In en, this message translates to:
  /// **'Good night,'**
  String get goodNight;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @createPreferenceCard.
  ///
  /// In en, this message translates to:
  /// **'Create Preference card'**
  String get createPreferenceCard;

  /// No description provided for @createPrivateCard.
  ///
  /// In en, this message translates to:
  /// **'Create Private Card'**
  String get createPrivateCard;

  /// No description provided for @preferenceCardFavorites.
  ///
  /// In en, this message translates to:
  /// **'Preference card favorites'**
  String get preferenceCardFavorites;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noFavoriteItem.
  ///
  /// In en, this message translates to:
  /// **'No favorite item'**
  String get noFavoriteItem;

  /// No description provided for @searchProceduresCards.
  ///
  /// In en, this message translates to:
  /// **'Search procedures, cards...'**
  String get searchProceduresCards;

  /// No description provided for @allCard.
  ///
  /// In en, this message translates to:
  /// **'All Card'**
  String get allCard;

  /// No description provided for @myCards.
  ///
  /// In en, this message translates to:
  /// **'My Cards'**
  String get myCards;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @newCardAdded.
  ///
  /// In en, this message translates to:
  /// **'New Card Added'**
  String get newCardAdded;

  /// No description provided for @viewCard.
  ///
  /// In en, this message translates to:
  /// **'View Card'**
  String get viewCard;

  /// No description provided for @eventScheduled.
  ///
  /// In en, this message translates to:
  /// **'Event Scheduled'**
  String get eventScheduled;

  /// No description provided for @viewEvent.
  ///
  /// In en, this message translates to:
  /// **'View Event'**
  String get viewEvent;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @primaryInformation.
  ///
  /// In en, this message translates to:
  /// **'Primary Information'**
  String get primaryInformation;

  /// No description provided for @surgeon.
  ///
  /// In en, this message translates to:
  /// **'Surgeon'**
  String get surgeon;

  /// No description provided for @anesthesia.
  ///
  /// In en, this message translates to:
  /// **'Anesthesia'**
  String get anesthesia;

  /// No description provided for @surgicalTeamWithCount.
  ///
  /// In en, this message translates to:
  /// **'Surgical Team ({count})'**
  String surgicalTeamWithCount(int count);

  /// No description provided for @leadSurgeon.
  ///
  /// In en, this message translates to:
  /// **'Lead Surgeon'**
  String get leadSurgeon;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @linkedPreferenceCard.
  ///
  /// In en, this message translates to:
  /// **'Linked Preference Card'**
  String get linkedPreferenceCard;

  /// No description provided for @viewCardDetails.
  ///
  /// In en, this message translates to:
  /// **'View Card Details'**
  String get viewCardDetails;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @oneHourBefore.
  ///
  /// In en, this message translates to:
  /// **'1 hour before procedure'**
  String get oneHourBefore;

  /// No description provided for @twentyFourHoursBefore.
  ///
  /// In en, this message translates to:
  /// **'24 hours before procedure'**
  String get twentyFourHoursBefore;

  /// No description provided for @eventTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Event Title *'**
  String get eventTitleLabel;

  /// No description provided for @enterEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter event title'**
  String get enterEventTitle;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @dateRequired.
  ///
  /// In en, this message translates to:
  /// **'Date is required'**
  String get dateRequired;

  /// No description provided for @timeRequired.
  ///
  /// In en, this message translates to:
  /// **'Time is required'**
  String get timeRequired;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get locationRequired;

  /// No description provided for @enterLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter location (e.g., OR 3)'**
  String get enterLocationHint;

  /// No description provided for @linkPreferenceCardOptional.
  ///
  /// In en, this message translates to:
  /// **'Enter preference card ID(optional)'**
  String get linkPreferenceCardOptional;

  /// No description provided for @prefCardIdLengthError.
  ///
  /// In en, this message translates to:
  /// **'Preference card ID must be 24 characters long'**
  String get prefCardIdLengthError;

  /// No description provided for @durationRequired.
  ///
  /// In en, this message translates to:
  /// **'Duration is required'**
  String get durationRequired;

  /// No description provided for @enterValidPositiveNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid positive number'**
  String get enterValidPositiveNumber;

  /// No description provided for @eventTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Event Type *'**
  String get eventTypeLabel;

  /// No description provided for @addTeamMember.
  ///
  /// In en, this message translates to:
  /// **'Add team member'**
  String get addTeamMember;

  /// No description provided for @pleaseEnterLeadSurgeon.
  ///
  /// In en, this message translates to:
  /// **'Please enter a lead surgeon'**
  String get pleaseEnterLeadSurgeon;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEvent;

  /// No description provided for @medicalSupplies.
  ///
  /// In en, this message translates to:
  /// **'Medical Supplies'**
  String get medicalSupplies;

  /// No description provided for @searchSuppliesHint.
  ///
  /// In en, this message translates to:
  /// **'Search for supplies...'**
  String get searchSuppliesHint;

  /// No description provided for @sutures.
  ///
  /// In en, this message translates to:
  /// **'Sutures'**
  String get sutures;

  /// No description provided for @searchSuturesHint.
  ///
  /// In en, this message translates to:
  /// **'Search for sutures...'**
  String get searchSuturesHint;

  /// No description provided for @itemSelected.
  ///
  /// In en, this message translates to:
  /// **'1 item selected'**
  String get itemSelected;

  /// No description provided for @itemsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} items selected'**
  String itemsSelected(int count);

  /// No description provided for @selectedWithCount.
  ///
  /// In en, this message translates to:
  /// **'Selected ({count})'**
  String selectedWithCount(int count);

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @noItemSelected.
  ///
  /// In en, this message translates to:
  /// **'No item selected'**
  String get noItemSelected;

  /// No description provided for @addAsCustom.
  ///
  /// In en, this message translates to:
  /// **'Add \"{name}\" as custom'**
  String addAsCustom(String name);

  /// No description provided for @at.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get at;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @newPrivateCardTitle.
  ///
  /// In en, this message translates to:
  /// **'New Private Card'**
  String get newPrivateCardTitle;

  /// No description provided for @newPreferenceCardTitle.
  ///
  /// In en, this message translates to:
  /// **'New Preference Card'**
  String get newPreferenceCardTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @cardTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Card Title'**
  String get cardTitleLabel;

  /// No description provided for @cardTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Surgeon Name — Procedure Name'**
  String get cardTitleHint;

  /// No description provided for @surgeonDetails.
  ///
  /// In en, this message translates to:
  /// **'SURGEON DETAILS'**
  String get surgeonDetails;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @handPreferenceSurgeon.
  ///
  /// In en, this message translates to:
  /// **'Hand Preference (Surgeon)'**
  String get handPreferenceSurgeon;

  /// No description provided for @enterHandPreference.
  ///
  /// In en, this message translates to:
  /// **'Enter hand preference'**
  String get enterHandPreference;

  /// No description provided for @specialtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialtyLabel;

  /// No description provided for @selectSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Select specialty'**
  String get selectSpecialty;

  /// No description provided for @contactNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumberLabel;

  /// No description provided for @musicPreferencesHint.
  ///
  /// In en, this message translates to:
  /// **'Preferred music or silence'**
  String get musicPreferencesHint;

  /// No description provided for @medicationHint.
  ///
  /// In en, this message translates to:
  /// **'List all required medications...'**
  String get medicationHint;

  /// No description provided for @medicalSuppliesRequired.
  ///
  /// In en, this message translates to:
  /// **'Medical Supplies are required'**
  String get medicalSuppliesRequired;

  /// No description provided for @suturesRequired.
  ///
  /// In en, this message translates to:
  /// **'Sutures are required'**
  String get suturesRequired;

  /// No description provided for @instrumentsHint.
  ///
  /// In en, this message translates to:
  /// **'List all required instruments...'**
  String get instrumentsHint;

  /// No description provided for @positioningEquipmentPlacement.
  ///
  /// In en, this message translates to:
  /// **'Positioning Equipment / Placement'**
  String get positioningEquipmentPlacement;

  /// No description provided for @positioningEquipmentHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Leg holders, arm boards'**
  String get positioningEquipmentHint;

  /// No description provided for @positioningPrepping.
  ///
  /// In en, this message translates to:
  /// **'Positioning / Prepping'**
  String get positioningPrepping;

  /// No description provided for @patientPositioningHint.
  ///
  /// In en, this message translates to:
  /// **'Patient positioning'**
  String get patientPositioningHint;

  /// No description provided for @operativeWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Operative Workflow'**
  String get operativeWorkflow;

  /// No description provided for @stepsOfCase.
  ///
  /// In en, this message translates to:
  /// **'Steps of the Case'**
  String get stepsOfCase;

  /// No description provided for @keyNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Critical reminders and important notes...'**
  String get keyNotesHint;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// No description provided for @tapToSelectFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Tap to select from library'**
  String get tapToSelectFromLibrary;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get addEvent;

  /// No description provided for @noEventsScheduled.
  ///
  /// In en, this message translates to:
  /// **'No events scheduled'**
  String get noEventsScheduled;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcomingEvents;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @eventTypes.
  ///
  /// In en, this message translates to:
  /// **'Event Types'**
  String get eventTypes;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @preferenceLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Preference Library'**
  String get preferenceLibraryTitle;

  /// No description provided for @preferenceCardTab.
  ///
  /// In en, this message translates to:
  /// **'Preference card'**
  String get preferenceCardTab;

  /// No description provided for @privateCardTab.
  ///
  /// In en, this message translates to:
  /// **'Private Card'**
  String get privateCardTab;

  /// No description provided for @preferenceCards.
  ///
  /// In en, this message translates to:
  /// **'Preference cards'**
  String get preferenceCards;

  /// No description provided for @privateCards.
  ///
  /// In en, this message translates to:
  /// **'Private cards'**
  String get privateCards;

  /// No description provided for @noCardsFound.
  ///
  /// In en, this message translates to:
  /// **'No cards found'**
  String get noCardsFound;

  /// No description provided for @noPrivateCardsFound.
  ///
  /// In en, this message translates to:
  /// **'No private cards found'**
  String get noPrivateCardsFound;

  /// No description provided for @noMoreData.
  ///
  /// In en, this message translates to:
  /// **'No more data'**
  String get noMoreData;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @verifiedOnly.
  ///
  /// In en, this message translates to:
  /// **'Verified Only'**
  String get verifiedOnly;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'By'**
  String get by;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @noDetailsFound.
  ///
  /// In en, this message translates to:
  /// **'No details found'**
  String get noDetailsFound;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'downloads'**
  String get downloads;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @surgeonInformation.
  ///
  /// In en, this message translates to:
  /// **'Surgeon Information'**
  String get surgeonInformation;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @musicPreferences.
  ///
  /// In en, this message translates to:
  /// **'Music Preferences'**
  String get musicPreferences;

  /// No description provided for @handPreference.
  ///
  /// In en, this message translates to:
  /// **'Hand Preference'**
  String get handPreference;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

  /// No description provided for @allSupplies.
  ///
  /// In en, this message translates to:
  /// **'All Supplies'**
  String get allSupplies;

  /// No description provided for @noSuppliesFound.
  ///
  /// In en, this message translates to:
  /// **'No supplies found'**
  String get noSuppliesFound;

  /// No description provided for @noSuturesFound.
  ///
  /// In en, this message translates to:
  /// **'No sutures found'**
  String get noSuturesFound;

  /// No description provided for @instruments.
  ///
  /// In en, this message translates to:
  /// **'Instruments'**
  String get instruments;

  /// No description provided for @positioning.
  ///
  /// In en, this message translates to:
  /// **'Positioning'**
  String get positioning;

  /// No description provided for @equipmentPlacement.
  ///
  /// In en, this message translates to:
  /// **'Equipment / Placement'**
  String get equipmentPlacement;

  /// No description provided for @patientPosition.
  ///
  /// In en, this message translates to:
  /// **'Patient Position'**
  String get patientPosition;

  /// No description provided for @preppingShaving.
  ///
  /// In en, this message translates to:
  /// **'Prepping / Shaving'**
  String get preppingShaving;

  /// No description provided for @keyNotes.
  ///
  /// In en, this message translates to:
  /// **'Key Notes'**
  String get keyNotes;

  /// No description provided for @photoLibrary.
  ///
  /// In en, this message translates to:
  /// **'Photo library'**
  String get photoLibrary;

  /// No description provided for @noPhotosFound.
  ///
  /// In en, this message translates to:
  /// **'No photos found'**
  String get noPhotosFound;

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get editEvent;

  /// No description provided for @procedureInformation.
  ///
  /// In en, this message translates to:
  /// **'Procedure Information'**
  String get procedureInformation;

  /// No description provided for @procedureName.
  ///
  /// In en, this message translates to:
  /// **'Procedure Name'**
  String get procedureName;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'Duration (hours)'**
  String get durationHours;

  /// No description provided for @eventType.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get eventType;

  /// No description provided for @surgery.
  ///
  /// In en, this message translates to:
  /// **'Surgery'**
  String get surgery;

  /// No description provided for @meeting.
  ///
  /// In en, this message translates to:
  /// **'Meeting'**
  String get meeting;

  /// No description provided for @consultation.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get consultation;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @personnel.
  ///
  /// In en, this message translates to:
  /// **'Personnel'**
  String get personnel;

  /// No description provided for @surgicalTeam.
  ///
  /// In en, this message translates to:
  /// **'Surgical Team'**
  String get surgicalTeam;

  /// No description provided for @locationSetup.
  ///
  /// In en, this message translates to:
  /// **'Location & Setup'**
  String get locationSetup;

  /// No description provided for @operatingRoom.
  ///
  /// In en, this message translates to:
  /// **'Operating Room'**
  String get operatingRoom;

  /// No description provided for @anesthesiaType.
  ///
  /// In en, this message translates to:
  /// **'Anesthesia Type'**
  String get anesthesiaType;

  /// No description provided for @procedureNotes.
  ///
  /// In en, this message translates to:
  /// **'Procedure Notes'**
  String get procedureNotes;

  /// No description provided for @addNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any special notes or requirements...'**
  String get addNotesHint;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerificationTitle;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @verificationCodeSentEmail.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification code to {email}. Please check your inbox.'**
  String verificationCodeSentEmail(String email);

  /// No description provided for @otpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otpCodeLabel;

  /// No description provided for @verifyOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtpButton;

  /// No description provided for @didNotReceiveCodeResend.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? Resend'**
  String get didNotReceiveCodeResend;

  /// No description provided for @enterNewPasswordBelow.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password below.'**
  String get enterNewPasswordBelow;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordHint;

  /// No description provided for @confirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPasswordHint;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @passwordResetSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful!'**
  String get passwordResetSuccessful;

  /// No description provided for @loginWithNewPassword.
  ///
  /// In en, this message translates to:
  /// **'You can now log in using your new password.'**
  String get loginWithNewPassword;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @noEventsOnDate.
  ///
  /// In en, this message translates to:
  /// **'No events on this date.\nPlease create an event or select another date.'**
  String get noEventsOnDate;

  /// No description provided for @deleteEvent.
  ///
  /// In en, this message translates to:
  /// **'Delete Event'**
  String get deleteEvent;

  /// No description provided for @deleteEventConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this event?'**
  String get deleteEventConfirm;

  /// No description provided for @egTwoHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 2'**
  String get egTwoHint;

  /// No description provided for @generalAnesthesia.
  ///
  /// In en, this message translates to:
  /// **'General Anesthesia'**
  String get generalAnesthesia;
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
