import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../core/api/api_client.dart';

class BinaEkleScreen extends StatefulWidget {
  const BinaEkleScreen({super.key});

  @override
  State<BinaEkleScreen> createState() => _BinaEkleScreenState();
}

class _BinaEkleScreenState extends State<BinaEkleScreen> {
  final _formKey = GlobalKey<FormState>();

  final binaAdiCtrl = TextEditingController();
  final bolgeCtrl = TextEditingController();
  final bakimUcretCtrl = TextEditingController();
  final yoneticiCtrl = TextEditingController();
  final telefonCtrl = TextEditingController();
  final adresCtrl = TextEditingController();
  final kulbelCtrl = TextEditingController();
  final notCtrl = TextEditingController();

  DateTime? sonKontrol;
  DateTime? sonrakiKontrol;
  String? durum;

  final durumlar = const ["Yeşil", "Mavi", "Sarı", "Kırmızı"];

  final dfApi = DateFormat("yyyy-MM-dd");
  final dfUi = DateFormat("dd.MM.yyyy");

  /// 🔁 DURUMA GÖRE SONRAKİ KONTROL
  void _hesaplaSonrakiKontrol() {
    if (sonKontrol == null || durum == null) return;

    final dt = sonKontrol!;
    DateTime next;

    switch (durum) {
      case "Kırmızı":
        next = DateTime(dt.year, dt.month + 2, dt.day);
        break;
      case "Sarı":
        next = DateTime(dt.year, dt.month + 4, dt.day);
        break;
      default: // Yeşil + Mavi
        next = DateTime(dt.year + 1, dt.month, dt.day);
    }

    setState(() => sonrakiKontrol = next);
  }

  Future<void> _tarihSec() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => sonKontrol = picked);
      _hesaplaSonrakiKontrol();
    }
  }

  Future<void> kaydet() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      "binaAdi": binaAdiCtrl.text.trim(),
      "bolge": bolgeCtrl.text.trim(),
      "kulubel": kulbelCtrl.text.trim(), // 🔥 backend ile birebir
      "durum": durum,
      if (sonKontrol != null)
        "son_kontrol_tarihi": dfApi.format(sonKontrol!),
    };

    debugPrint("📤 BİNA EKLE BODY: $body");

    final res = await ApiClient.post("bina_ekle.php", body);

    debugPrint("📥 STATUS: ${res.statusCode}");
    debugPrint("📥 BODY: ${res.body}");

    if (!mounted) return;

    if (res.statusCode == 200) {
      Navigator.pop(context, true); // 🔥 LİSTEYİ YENİLE SİNYALİ
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bina eklenemedi")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bina Ekle")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _input(binaAdiCtrl, "Bina Adı", hint: "Örn: Emir Apartmanı"),
              _input(bolgeCtrl, "Bölge", hint: "Örn: İlçe / Mahalle"),
              _input(bakimUcretCtrl, "Bakım Ücreti", number: true),
              _input(yoneticiCtrl, "Yönetici Ad Soyad"),
              _input(telefonCtrl, "Yönetici Telefon", number: true),
              _input(adresCtrl, "Bina Adresi"),
              _input(
                kulbelCtrl,
                "Kulbel",
                hint: "4 haneli sayı",
                number: true,
                kulbel: true,
              ),

              const SizedBox(height: 12),

              /// 📅 SON KONTROL
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: _tarihSec,
                leading: const Icon(Icons.calendar_month),
                title: const Text("Son Kontrol Tarihi"),
                subtitle: Text(
                  sonKontrol == null
                      ? "Tarih seçiniz"
                      : dfUi.format(sonKontrol!),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),

              const SizedBox(height: 8),

              /// 🎨 DURUM
              DropdownButtonFormField<String>(
                initialValue: durum,
                items: durumlar
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text(d),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() => durum = v);
                  _hesaplaSonrakiKontrol();
                },
                decoration: const InputDecoration(
                  labelText: "Durum",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? "Durum seçiniz" : null,
              ),

              if (sonrakiKontrol != null)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        "Sonraki Kontrol: ${dfUi.format(sonrakiKontrol!)}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              _input(notCtrl, "Not", maxLines: 3, optional: true),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed:
                      (durum != null && sonKontrol != null) ? kaydet : null,
                  child: const Text(
                    "KAYDET",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController c,
    String label, {
    String? hint,
    bool number = false,
    bool kulbel = false,
    bool optional = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        inputFormatters: kulbel
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ]
            : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const UnderlineInputBorder(),
        ),
        validator: (v) {
          if (optional) return null;
          if (v == null || v.isEmpty) return "$label zorunlu";
          if (kulbel && !RegExp(r'^\d{4}$').hasMatch(v)) {
            return "Kulbel 4 haneli sayı olmalıdır";
          }
          return null;
        },
      ),
    );
  }
}
