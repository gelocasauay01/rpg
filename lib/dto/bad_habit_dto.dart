class BadHabitDTO {
  
  String? title;
  int damage;
  List<DateTime>? occurrences;

  BadHabitDTO ({
    this.title,
    this.damage = 2,
    this.occurrences,
  });

  Map<String, dynamic> toJSON() {
    return {
      'Title': title,
      'Damage': damage,
    };
  }

}