import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../data/models/place_suggestion.dart';

class CustomPlacesListItem extends StatelessWidget {
  final PlaceSuggestion place;
  const CustomPlacesListItem({super.key, required this.place});
  @override
  Widget build(BuildContext context) {
    var subTitle =
        place.description.replaceAll(place.description.split(',')[0], "");
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: MyColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.place,
                color: MyColors.blue,
              ),
            ),
            title: RichText(
              text: TextSpan(
                text: '${place.description.split(',')[0]}\n',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: subTitle.substring(2),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
