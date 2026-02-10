import 'package:sqflite/sqflite.dart';
import '../models/gym_session.dart';
import 'database_helper.dart';

/// Repository for gym check-in session CRUD.
class GymSessionRepository {
  Future<Database> get _db => DatabaseHelper.instance.database;

  /// Get all sessions for the current week (Mon–Sun).
  Future<List<GymSession>> getThisWeekSessions() async {
    final db = await _db;
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    final from = _dateStr(monday);
    final to = _dateStr(sunday);

    final rows = await db.query(
      'gym_sessions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [from, to],
      orderBy: 'date ASC',
    );
    return rows.map(GymSession.fromMap).toList();
  }

  /// Check if user already checked in today.
  Future<bool> hasCheckedInToday() async {
    final db = await _db;
    final today = _dateStr(DateTime.now());
    final result = await db.query(
      'gym_sessions',
      where: 'date = ?',
      whereArgs: [today],
    );
    return result.isNotEmpty;
  }

  /// Record a check-in for today.
  Future<int> checkIn({
    int durationMinutes = 60,
    int intensityPercent = 80,
  }) async {
    final db = await _db;
    return db.insert(
      'gym_sessions',
      GymSession(
        date: _dateStr(DateTime.now()),
        durationMinutes: durationMinutes,
        intensityPercent: intensityPercent,
      ).toMap(),
    );
  }

  /// Delete a session.
  Future<void> deleteSession(int id) async {
    final db = await _db;
    await db.delete('gym_sessions', where: 'id = ?', whereArgs: [id]);
  }

  /// Get total sessions count.
  Future<int> getTotalSessionCount() async {
    final db = await _db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM gym_sessions',
    );
    return (result.first['cnt'] as int?) ?? 0;
  }

  String _dateStr(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
