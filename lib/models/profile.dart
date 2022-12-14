class Profile {
  final int maxHealth = 20;
  String name;
  String imageUrl;
  int goldValue;
  int healthValue;

  Profile({
    required this.name,
    required this.imageUrl,
    this.goldValue = 2000,
    this.healthValue = 20,
  });

  Profile.fromJSON(Map<String, dynamic> json) :
    name = json["Name"] as String,
    imageUrl = json['ImageUrl'] as String,
    goldValue = json['GoldValue'] as int,
    healthValue = json['HealthValue'] as int;
  
  Map<String,dynamic> toJSON() {
    return {
      'Name': name,
      'ImageUrl': imageUrl,
      'GoldValue': goldValue,
      'HealthValue': healthValue
    };
  }

  bool get isAlive {
    return healthValue > 0;
  }

  void takeDamage(int damage) {
    int currentHealth = healthValue - damage;
    if(currentHealth < 0) {
      healthValue = 0;
    }

    else {
      healthValue = currentHealth;
    }
  }

  void receiveGoldReward(int goldAmount) {
    goldValue += goldAmount;
  }

  void heal(int healValue) {
    healthValue += healValue;
    if(healthValue > maxHealth) {
      healthValue = maxHealth;
    }
    
  }

  void payGold(int paymentValue) {
    goldValue -= paymentValue;
  }

}