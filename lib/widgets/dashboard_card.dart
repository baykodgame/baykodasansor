import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String>? lines;
  final bool isPrimary;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    this.lines,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isPrimary ? Colors.blue.shade400 : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: isPrimary ? Colors.white : Colors.blue),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isPrimary ? Colors.white : Colors.blue,
              ),
            ),
            if (lines != null)
              ...lines!.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    e,
                    style: TextStyle(
                      color: isPrimary ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
