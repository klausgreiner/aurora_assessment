import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Random Image'**
  String get appTitle;

  /// Button label to load another random image
  ///
  /// In en, this message translates to:
  /// **'Another'**
  String get buttonAnother;

  /// Instruction text telling user to tap the Another button
  ///
  /// In en, this message translates to:
  /// **'Tap \'Another\' for a new image'**
  String get instructionTapAnother;

  /// Semantics label for image load message
  ///
  /// In en, this message translates to:
  /// **'Image load message'**
  String get semanticsImageLoadMessage;

  /// Semantics label for the button that loads another random image
  ///
  /// In en, this message translates to:
  /// **'Load another random image'**
  String get semanticsLoadAnotherImage;

  /// Error message when initial image fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load initial image'**
  String get errorFailedToLoadInitialImage;

  /// Button label to retry loading
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get buttonRetry;

  /// Error message when image cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load that image. Try again.'**
  String get errorCouldNotLoadImage;

  /// Error message when colors cannot be extracted from image
  ///
  /// In en, this message translates to:
  /// **'Could not extract colors from image. Try again.'**
  String get errorCouldNotExtractColors;

  /// Error message when image is not found (404)
  ///
  /// In en, this message translates to:
  /// **'Image not found. Please retry.'**
  String get errorImageNotFound;

  /// Error message when access is denied (403)
  ///
  /// In en, this message translates to:
  /// **'Access denied (403). Cannot load this image.'**
  String get errorAccessDenied;

  /// Error message for server errors (500, 502, 503)
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again.'**
  String get errorServerError;

  /// Error message when image load times out
  ///
  /// In en, this message translates to:
  /// **'Image load timed out. Please try again.'**
  String get errorImageLoadTimeout;

  /// Error message for network errors
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errorNetworkError;

  /// Generic error message when image fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load image. Please try again.'**
  String get errorFailedToLoadImage;

  /// Error message when image load times out after specific duration
  ///
  /// In en, this message translates to:
  /// **'Image load timed out after 3 seconds'**
  String get errorImageLoadTimeoutAfterSeconds;

  /// Error message when request times out
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errorRequestTimeout;

  /// Error message for connection errors
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please check your internet.'**
  String get errorConnectionError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
