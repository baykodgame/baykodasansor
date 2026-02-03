import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/api/license_service.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({super.key});

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  bool loading = true;
  int? kalanGun;

  static const int fiveYears = 1825; // 🔥 5 YIL

  @override
  void initState() {
    super.initState();
    _loadLicense();
  }

  Future<void> _loadLicense() async {
    try {
      final data = await LicenseService.checkLicense();
      if (!mounted) return;

      setState(() {
        kalanGun = data["kalan_gun"];
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  String lisansText(int gun) {
    if (gun >= fiveYears) return "Süresiz / Yönetici Lisansı";
    if (gun >= 30) return "Lisans aktif ($gun gün)";
    if (gun >= 7) return "Lisans bitiyor ($gun gün)";
    return "Lisans kritik ($gun gün)";
  }

  Color lisansColor(int gun) {
    if (gun >= 30) return Colors.green;
    if (gun >= 7) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final today =
        DateFormat("dd MMMM yyyy, EEEE", "tr_TR").format(DateTime.now());

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Baykod Asansör Takip Sistemi",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // 📅 CANLI TARİH
            Text(
              today,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 8),

            // 🔐 LİSANS DURUMU
            if (loading)
              const LinearProgressIndicator(minHeight: 3)
            else if (kalanGun != null)
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: lisansColor(kalanGun!),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      lisansText(kalanGun!),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: lisansColor(kalanGun!),
                      ),
                    ),
                  ),
                ],
              )
            else
              const Text(
                "Lisans bilgisi alınamadı",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
