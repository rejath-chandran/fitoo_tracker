/// Model for a single gym check-in session.
class GymSession {
  final int? id;
  final String date; // ISO 8601 date, e.g. '2026-02-11'
  final int durationMinutes;
  final int intensityPercent; // 0–100

  const GymSession({
    this.id,
    required this.date,
    this.durationMinutes = 0,
    this.intensityPercent = 0,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'date': date,
    'duration_minutes': durationMinutes,
    'intensity_percent': intensityPercent,
  };

  factory GymSession.fromMap(Map<String, dynamic> map) {
    return GymSession(
      id: map['id'] as int,
      date: map['date'] as String,
      durationMinutes: map['duration_minutes'] as int? ?? 0,
      intensityPercent: map['intensity_percent'] as int? ?? 0,
    );
  }
}
