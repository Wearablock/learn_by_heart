import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/card/data/models/memory_card.dart';
import '../../features/study/data/models/study_session.dart';
import '../../features/study/data/models/study_record.dart';

class DatabaseService {
  static Isar? _isar;

  static Isar get instance {
    if (_isar == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _isar!;
  }

  static Future<void> initialize() async {
    if (_isar != null) return;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        MemoryCardSchema,
        StudySessionSchema,
        StudyRecordSchema,
      ],
      directory: dir.path,
    );
  }

  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }

  static Future<void> clear() async {
    await _isar?.writeTxn(() async {
      await _isar!.clear();
    });
  }
}
