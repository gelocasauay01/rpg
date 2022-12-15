class BadHabitOccurrence {
  final int badHabitId;
  final DateTime dateOccurred;

  const BadHabitOccurrence({
    required this.badHabitId,
    required this.dateOccurred
  });

  BadHabitOccurrence.fromJSON(Map<String, dynamic> json) :
    badHabitId = json['BadHabitId'] as int,
    dateOccurred = DateTime.fromMillisecondsSinceEpoch(json['DateOccurred'] as int);
}