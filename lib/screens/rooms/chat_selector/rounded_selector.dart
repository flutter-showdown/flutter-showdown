import 'package:flutter/material.dart';

class RoundedSelector extends StatelessWidget {
  const RoundedSelector({this.child, this.isSelected = false, this.hasUpdates = false, this.onTap});

  final Widget child;
  final bool isSelected;
  final bool hasUpdates;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: isSelected ? 36 : hasUpdates ? 12 : 0,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: InkWell(
            onTap: () {
              if (onTap != null) {
                onTap();
              }
            },
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(isSelected ? 15 : 25),
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}