import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String identifier;
  final VoidCallback onPressed;
  final String value;
  const SettingsItem({super.key, required this.identifier, required this.onPressed, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(padding:EdgeInsets.only(left: 16,right: 14,top: 6,bottom: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(identifier,style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15
            ),),
            SizedBox(height: 4,),
            Text(value)
          ],
        ),
        GestureDetector(
          onTap: onPressed,
          child: Image.asset("assets/icons/pen.png",height: 21),
        )
      ],
    ));
  }
}
