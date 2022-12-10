class Profile {

  String name;
  String imageUrl;
  int goldValue;
  int healthValue;
  int maxHealth;

  Profile({
    required this.name,
    required this.imageUrl,
    this.goldValue = 1000,
    this.healthValue = 10,
    this.maxHealth = 10,
  });

  Profile.fromJSON(Map<String, dynamic> json) :
    name = json["Name"],
    imageUrl = json['ImageUrl'],
    goldValue = json['GoldValue'] as int,
    healthValue = json['HealthValue'] as int,
    maxHealth = json['MaxHealth'] as int;
  
  Map<String,dynamic> toJSON() {
    return {
      'Name': name,
      'ImageUrl': imageUrl,
      'GoldValue': goldValue,
      'HealthValue': healthValue,
      'MaxHealth': maxHealth
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