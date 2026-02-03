import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/bina_model.dart';
import '../core/api/api_client.dart';

class BinaListScreen extends StatefulWidget {
  const BinaListScreen({super.key});

  @override
  State<BinaListScreen> createState() => _BinaListScreenState();
}

class _BinaListScreenState extends State<BinaListScreen> {
  bool loading = true;

  List<BinaModel> allBinalar = [];
  List<BinaModel> filteredBinalar = [];

  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBinalar();
  }

  /// 🔥 BİNALARI API'DEN ÇEK
  Future<void> _loadBinalar() async {
    setState(() => loading = true);

    final res = await ApiClient.get("binalar.php");

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final List list = json["data"] ?? [];

      allBinalar = list.map((e) => BinaModel.fromJson(e)).toList();
      filteredBinalar = List.from(allBinalar);
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  /// 🔍 FİLTRE
  void _filter(String q) {
    final query = q.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        filteredBinalar = List.from(allBinalar);
        return;
      }

      filteredBinalar = allBinalar.where((b) {
        return b.ad.toLowerCase().contains(query) ||
            b.bolge.toLowerCase().contains(query) ||
            (b.kubel?.toString().contains(query) ?? false);
      }).toList();
    });
  }

  Color _durumColor(String? durum) {
    switch (durum) {
      case "Yeşil":
        return Colors.green;
      case "Mavi":
        return Colors.blue;
      case "Sarı":
        return Colors.orange;
      case "Kırmızı":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text("Binalar")),
      body: Column(
        children: [
          /// 🔍 ARAMA + ➕ BİNA EKLE
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: _filter,
                    decoration: InputDecoration(
                      hintText: "Bina ara...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
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
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final res = await Navigator.pushNamed(
                        context,
                        "/bina_ekle",
                      );

                      /// 🔁 EKLEME BAŞARILIYSA → API’DEN TEKRAR ÇEK
                      if (res == true && mounted) {
                        searchCtrl.clear();
                        await _loadBinalar();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                      "Bina Ekle",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 📜 LİSTE
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: filteredBinalar.length,
              itemBuilder: (context, i) {
                final b = filteredBinalar[i];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.ad,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _row(Icons.location_on, b.bolge),
                        if (b.not != null) _row(Icons.note, b.not!),
                        if (b.kubel != null)
                          _row(Icons.vpn_key, "Kulübel: ${b.kubel}"),
                        if (b.kontrolTarihi != null)
                          _row(Icons.date_range, b.kontrolTarihi!),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: _durumColor(b.durum),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            b.durum ?? "Bilinmiyor",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String? text) {
    if (text == null || text.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
