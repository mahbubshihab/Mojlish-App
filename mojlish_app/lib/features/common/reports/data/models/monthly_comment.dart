/// মাসিক মন্তব্য মডেল
class MonthlyComment {
  final String id;
  final String yearMonth; // yyyy-MM
  final String comment;
  final String signature;
  final int timestamp; // milliseconds since epoch

  const MonthlyComment({
    required this.id,
    required this.yearMonth,
    required this.comment,
    required this.signature,
    required this.timestamp,
  });

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);

  Map<String, dynamic> toJson() => {
    'id': id,
    'yearMonth': yearMonth,
    'comment': comment,
    'signature': signature,
    'timestamp': timestamp,
  };

  factory MonthlyComment.fromJson(Map<String, dynamic> json) {
    return MonthlyComment(
      id: json['id'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      comment: json['comment'] ?? '',
      signature: json['signature'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }

  MonthlyComment copyWith({
    String? comment,
    String? signature,
  }) {
    return MonthlyComment(
      id: id,
      yearMonth: yearMonth,
      comment: comment ?? this.comment,
      signature: signature ?? this.signature,
      timestamp: timestamp,
    );
  }
}
