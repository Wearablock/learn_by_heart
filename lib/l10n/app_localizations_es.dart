// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'De Memoria - Memorizar';

  @override
  String get homeTitle => 'Mis tarjetas';

  @override
  String get emptyStateTitle => 'Aún no hay tarjetas';

  @override
  String get emptyStateSubtitle => 'Añade tu primera tarjeta para empezar';

  @override
  String get addCardButton => 'Añadir tarjeta';

  @override
  String cardStudyCount(int count) {
    return 'Estudiado $count veces';
  }

  @override
  String get cardContentHint => 'Introduce el texto a memorizar';

  @override
  String get deleteCard => 'Eliminar tarjeta';

  @override
  String get deleteCardConfirm => '¿Seguro que quieres eliminar esta tarjeta?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';
}
