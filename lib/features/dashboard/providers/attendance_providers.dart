import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/gym_session_repository.dart';
import '../../../core/models/gym_session.dart';

/// Singleton repository provider.
final gymSessionRepositoryProvider = Provider<GymSessionRepository>((ref) {
  return GymSessionRepository();
});

/// Weekly attendance data used by the dashboard.
class AttendanceState {
  final List<GymSession> weekSessions;
  final bool checkedInToday;
  final int weeklyGoal;

  const AttendanceState({
    this.weekSessions = const [],
    this.checkedInToday = false,
    this.weeklyGoal = 5,
  });

  int get completedSessions => weekSessions.length;

  int get totalDuration =>
      weekSessions.fold(0, (sum, s) => sum + s.durationMinutes);

  int get avgIntensity {
    if (weekSessions.isEmpty) return 0;
    return (weekSessions.fold(0, (sum, s) => sum + s.intensityPercent) /
            weekSessions.length)
        .round();
  }

  /// Returns set of weekday indices (1=Mon..7=Sun) that have a session.
  Set<int> get checkedInDays {
    return weekSessions.map((s) {
      final dt = DateTime.parse(s.date);
      return dt.weekday;
    }).toSet();
  }
}

/// Provides the current week's attendance state.
final attendanceProvider =
    AsyncNotifierProvider<AttendanceNotifier, AttendanceState>(
      AttendanceNotifier.new,
    );

class AttendanceNotifier extends AsyncNotifier<AttendanceState> {
  @override
  Future<AttendanceState> build() async {
    final repo = ref.read(gymSessionRepositoryProvider);
    final sessions = await repo.getThisWeekSessions();
    final checkedIn = await repo.hasCheckedInToday();
    return AttendanceState(weekSessions: sessions, checkedInToday: checkedIn);
  }

  /// Check in to the gym for today.
  Future<void> checkIn() async {
    final repo = ref.read(gymSessionRepositoryProvider);
    final alreadyCheckedIn = await repo.hasCheckedInToday();
    if (alreadyCheckedIn) return; // prevent double check-in

    await repo.checkIn(durationMinutes: 60, intensityPercent: 80);

    final sessions = await repo.getThisWeekSessions();
    state = AsyncData(
      AttendanceState(weekSessions: sessions, checkedInToday: true),
    );
  }

  /// Refresh data from DB.
  Future<void> reload() async {
    final repo = ref.read(gymSessionRepositoryProvider);
    final sessions = await repo.getThisWeekSessions();
    final checkedIn = await repo.hasCheckedInToday();
    state = AsyncData(
      AttendanceState(weekSessions: sessions, checkedInToday: checkedIn),
    );
  }
}
