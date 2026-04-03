class DailyReportModel {
  final int id;
  final String todaysTasks;
  final String? challenges;
  final String status;
  final String createdAt;
  final String fullName;
  final String email;

  DailyReportModel({
    required this.id,
    required this.todaysTasks,
    this.challenges,
    required this.status,
    required this.createdAt,
    required this.fullName,
    required this.email,
  });

  factory DailyReportModel.fromJson(Map<String, dynamic> json) {
    return DailyReportModel(
      id:           json['id'] as int,
      todaysTasks:  json['todays_tasks'] as String? ?? '',
      challenges:   json['challenges'] as String?,
      status:       json['status'] as String? ?? 'submitted',
      createdAt:    json['created_at'] as String? ?? '',
      fullName:     json['full_name'] as String? ?? 'Unknown',
      email:        json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id':           id,
    'todays_tasks': todaysTasks,
    'challenges':   challenges,
    'status':       status,
    'created_at':   createdAt,
    'full_name':    fullName,
    'email':        email,
  };

  /// Returns initials from fullName (e.g. "John Doe" → "JD")
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';
  }

  /// Formats createdAt timestamp into a readable string
  String get formattedTime {
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      final hour   = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } catch (_) {
      return createdAt;
    }
  }

  /// Formats createdAt into date string
  String get formattedDate {
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return '';
    }
  }

  bool get hasChallenges =>
      challenges != null && challenges!.trim().isNotEmpty;
}