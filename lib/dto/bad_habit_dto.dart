class BadHabitDTO {
  
  String? title;
  int damage;
  DateTime? lastOccurred;
  int occurrenceCount;

  BadHabitDTO ({
    this.title,
    this.damage = 2,
    this.lastOccurred,
    this.occurrenceCount = 0
  });

  Map<String, dynamic> toJSON() {
    return {
      'Title': title,
      'Damage': damage,
    };
  }

}