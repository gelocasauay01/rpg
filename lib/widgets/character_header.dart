// External Dependencies
import 'dart:io';
import 'package:flutter/material.dart';

// Models
import 'package:rpg/models/profile.dart';

// Widgets
import 'package:rpg/screens/edit_profile_screen.dart';

class CharacterHeader extends StatelessWidget {

  final Profile profile;

  const CharacterHeader({
    required this.profile,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: screenHeight * 0.15,
        child: Row(children: [
          AspectRatio(
            aspectRatio: 1/1,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(EditProfileScreen.routeName),
              child: Image.file(
                File(profile.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(profile.name),
                      Row(children: [
                          SizedBox(
                            height: 16,
                            child: Image.asset(
                              "assets/images/coin.png",
                              fit: BoxFit.cover,
                            )
                          ),
                          Text(profile.goldValue.toString())
                        ],
                      ),
                      ]
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                      height: 20,
                      child: LinearProgressIndicator(
                        backgroundColor: Theme.of(context).backgroundColor,
                        color: Theme.of(context).highlightColor,
                        value: profile.healthValue / profile.maxHealth,
                      ),
                    ),
                    Text("${profile.healthValue} / ${profile.maxHealth}")
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}