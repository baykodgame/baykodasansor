import 'package:flutter/material.dart';
import '../models/bina_model.dart';

class BinaDetailScreen extends StatelessWidget {
  final BinaModel bina;

  const BinaDetailScreen({super.key, required this.bina});

  Color _statusColor(String? durum) {
    switch (durum) {
      case "Yeşil":
        return Colors.green;
      case "Sarı":
        return Colors.orange;
      case "Mavi":
        return Colors.blue;
      case "Kırmızı":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bina.ad),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {}, // düzenle
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {}, // bina ekle
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row(Icons.location_on, "Bölge", bina.bolge),
                _row(Icons.note, "Not", bina.not ?? "-"),
                _row(Icons.vpn_key, "Kulbel No", bina.kubel ?? "-"),
                _row(Icons.date_range, "Sonraki Kontrol",
                    bina.kontrolTarihi ?? "-"),
                const SizedBox(height: 12),

                // 🔴 DURUM
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor(bina.durum),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    bina.durum ?? "Bilinmiyor",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔘 BUTONLAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _btn(Icons.info, "Detay", () {}),
                    _btn(Icons.edit, "Düzelt", () {}),
                    _btn(Icons.map, "Konum", () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text("$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, String text, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(text),
    );
  }
}
