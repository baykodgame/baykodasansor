import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String>? lines;
  final bool isPrimary;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    this.lines,
    this.isPrimary = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isPrimary ? Colors.blue.shade600 : Colors.white;

    final titleColor =
        isPrimary ? Colors.white : Colors.blue.shade700;

    final textColor =
        isPrimary ? Colors.white : Colors.grey.shade800;

    return SizedBox(
      height: 190, // 🔥 SCROLL RAHATLASIN DİYE BÜYÜTTÜK
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Card(
          color: bgColor,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isPrimary
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: 28,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18, // 🔥 BAŞLIK BÜYÜTÜLDÜ
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// CONTENT (İÇ SCROLL)
                if (lines != null && lines!.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: lines!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            lines![index],
                            style: TextStyle(
                              fontSize: 15.5, // 🔥 OKUNAKLI
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              color: textColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
