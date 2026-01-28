// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Zufälliges Bild';

  @override
  String get buttonAnother => 'Weiteres';

  @override
  String get instructionTapAnother =>
      'Tippen Sie auf \'Weiteres\' für ein neues Bild';

  @override
  String get semanticsImageLoadMessage => 'Bildladungsnachricht';

  @override
  String get semanticsLoadAnotherImage => 'Weiteres zufälliges Bild laden';

  @override
  String get errorFailedToLoadInitialImage =>
      'Fehler beim Laden des ersten Bildes';

  @override
  String get buttonRetry => 'Wiederholen';

  @override
  String get errorCouldNotLoadImage =>
      'Bild konnte nicht geladen werden. Bitte erneut versuchen.';

  @override
  String get errorCouldNotExtractColors =>
      'Farben konnten nicht aus dem Bild extrahiert werden. Bitte erneut versuchen.';

  @override
  String get errorImageNotFound =>
      'Bild nicht gefunden. Bitte erneut versuchen.';

  @override
  String get errorAccessDenied =>
      'Zugriff verweigert (403). Dieses Bild kann nicht geladen werden.';

  @override
  String get errorServerError => 'Serverfehler. Bitte erneut versuchen.';

  @override
  String get errorImageLoadTimeout =>
      'Bildladung abgelaufen. Bitte erneut versuchen.';

  @override
  String get errorNetworkError =>
      'Netzwerkfehler. Bitte überprüfen Sie Ihre Verbindung.';

  @override
  String get errorFailedToLoadImage =>
      'Bild konnte nicht geladen werden. Bitte erneut versuchen.';

  @override
  String get errorImageLoadTimeoutAfterSeconds =>
      'Bildladung nach 3 Sekunden abgelaufen';

  @override
  String get errorRequestTimeout =>
      'Anfrage abgelaufen. Bitte erneut versuchen.';

  @override
  String get errorConnectionError =>
      'Verbindungsfehler. Bitte überprüfen Sie Ihr Internet.';
}
