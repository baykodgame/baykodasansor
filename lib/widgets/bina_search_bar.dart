import 'package:flutter/material.dart';

class BinaSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const BinaSearchBar({
    super.key,
    required this.controller,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      color: const Color(0xFFF5F7FB),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Bina ara (ad, bölge, kulbel...)",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 46,
            width: 46,
            child: ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: Colors.blue,
                padding: EdgeInsets.zero,
              ),
              child: const Icon(Icons.add, size: 26),
            ),
          ),
        ],
      ),
    );
  }
}
