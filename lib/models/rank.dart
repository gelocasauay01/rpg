class Rank {
  final String title;
  final String iconPath;

  const Rank({
    required this.title,
    required this.iconPath
  });
}

class RankSystem {
  static const Rank _noob = Rank(iconPath: 'assets/images/ranks/Noob.png', title: 'Noob');
  static const Rank _apprentice = Rank(iconPath: 'assets/images/ranks/Apprentice.png', title: 'Apprentice');
  static const Rank _adept = Rank(iconPath: 'assets/images/ranks/Adept.png', title: 'Adept');
  static const Rank _proficient = Rank(iconPath: 'assets/images/ranks/Proficient.png', title: 'Proficient');
  static const Rank _competent = Rank(iconPath: 'assets/images/ranks/Competent.png', title: 'Competent');
  static const Rank _specialist = Rank(iconPath: 'assets/images/ranks/Specialist.png', title: 'Specialist');
  static const Rank _expert = Rank(iconPath: 'assets/images/ranks/Expert.png', title: 'Expert');
  static const Rank _elite = Rank(iconPath: 'assets/images/ranks/Elite.png', title: 'Elite');
  static const Rank _master = Rank(iconPath: 'assets/images/ranks/Master.png', title: 'Master');
  static const Rank _grandmaster = Rank(iconPath: 'assets/images/ranks/Grandmaster.png', title: 'Grandmaster');

  static Rank getRankFromLevel(int level) {
    Rank rank = _noob;

    if(level > 10 && level <= 20) {
      rank = RankSystem._apprentice;
    }

    else if(level > 20 && level <= 30){
      rank = RankSystem._adept;
    }

    else if(level > 30 && level <= 40){
      rank = RankSystem._proficient;
    }

    else if(level > 40 && level <= 50){
      rank = RankSystem._competent;
    }

    else if(level > 50 && level <= 60){
      rank = RankSystem._specialist;
    }

    else if(level > 60 && level <= 70){
      rank = RankSystem._expert;
    }

    else if(level > 70 && level <= 80){
      rank = RankSystem._elite;
    }

    else if(level > 80 && level <= 90){
      rank = RankSystem._master;
    }

    else if(level > 90 && level <= 100){
      rank = RankSystem._grandmaster;
    }

    return rank;
  }
}