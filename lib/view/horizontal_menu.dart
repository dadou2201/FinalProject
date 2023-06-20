import 'package:app_sportner2/utils/global_colors.dart';
import 'package:flutter/material.dart';

class HorizontalMenu extends StatefulWidget {
  final List<String> sports;
  final Function(String) onSportSelected;

  HorizontalMenu({required this.sports, required this.onSportSelected});

  @override
  _HorizontalMenuState createState() => _HorizontalMenuState();
}

class _HorizontalMenuState extends State<HorizontalMenu> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.sports.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (selectedIndex == index) {
                    selectedIndex = -1; // Désélectionner le sport
                    widget.onSportSelected('');
                  } else {
                    selectedIndex = index;
                    widget.onSportSelected(widget.sports[index]);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                primary: selectedIndex == index ? GlobalColors.mainColor : Colors.grey,
              ),
              child: Text(widget.sports[index]),
            ),
          );
        },
      ),
    );
  }
}