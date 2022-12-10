class SkillDTO {
  
  String? title;
  int level;  
  int currentExp;

  SkillDTO({
    this.title,
    this.level = 1,
    this.currentExp = 0
  });

  Map<String, dynamic> toJSON() {
    return {
      'Title': title,
      'Level': level,
      'CurrentExp': currentExp
    };
  }

}