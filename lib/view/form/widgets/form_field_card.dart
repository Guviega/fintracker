import 'package:flutter/material.dart';

class FormFieldCard extends StatelessWidget {
  const FormFieldCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.field,
    this.extra,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget field;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon, color: iconColor),
              title: Text(title),
            ),
            Padding(padding: const EdgeInsets.all(8), child: field),
            if (extra != null) extra!,
          ],
        ),
      ),
    );
  }
}
