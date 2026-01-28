// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Random Image';

  @override
  String get buttonAnother => 'Another';

  @override
  String get instructionTapAnother => 'Tap \'Another\' for a new image';

  @override
  String get semanticsImageLoadMessage => 'Image load message';

  @override
  String get semanticsLoadAnotherImage => 'Load another random image';

  @override
  String get errorFailedToLoadInitialImage => 'Failed to load initial image';

  @override
  String get buttonRetry => 'Retry';

  @override
  String get errorCouldNotLoadImage => 'Could not load that image. Try again.';

  @override
  String get errorCouldNotExtractColors =>
      'Could not extract colors from image. Try again.';

  @override
  String get errorImageNotFound => 'Image not found. Please retry.';

  @override
  String get errorAccessDenied =>
      'Access denied (403). Cannot load this image.';

  @override
  String get errorServerError => 'Server error. Please try again.';

  @override
  String get errorImageLoadTimeout => 'Image load timed out. Please try again.';

  @override
  String get errorNetworkError =>
      'Network error. Please check your connection.';

  @override
  String get errorFailedToLoadImage =>
      'Failed to load image. Please try again.';

  @override
  String get errorImageLoadTimeoutAfterSeconds =>
      'Image load timed out after 3 seconds';

  @override
  String get errorRequestTimeout => 'Request timed out. Please try again.';

  @override
  String get errorConnectionError =>
      'Connection error. Please check your internet.';
}
