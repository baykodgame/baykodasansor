import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/drawer_menu.dart';
import '../core/security/user_role.dart';
import '../core/security/secure_storage.dart';
import '../core/api/dashboard_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserRole? role;
  bool loading = true;
  Map<String, dynamic>? dashboard;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
  final r = await SecureStorage.getRole();

  // 🔥 UI DONMASINI KESER
  final data = await Future.microtask(
    () => DashboardService.getDashboard(),
  );

  if (!mounted) return;

  setState(() {
    role = r;
    dashboard = data;
    loading = false;
  });
}

  // 📍 BÖLGE SAYIMI
  Map<String, int> bolgeSayim(List<dynamic> binalar) {
    final Map<String, int> map = {};
    for (final b in binalar) {
      final bolge = (b["bina_bolgesi"] ?? "Bilinmeyen").toString();
      map[bolge] = (map[bolge] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    if (loading || role == null || dashboard == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List binalar = dashboard!["binalar"]["data"] ?? [];
    final List arizalar = dashboard!["arizalar"]["data"] ?? [];
    final Map bakimlar = dashboard!["bakimlar"]["data"] ?? {};
    final Map periyodik = dashboard!["periyodik"]["data"] ?? {};
    final bolgeler = bolgeSayim(binalar);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      drawer: DrawerMenu(role: role!),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Baykod Asansör Takip Sistemi",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const InfoCard(),
            const SizedBox(height: 20),

            /// 🏢 BİNALAR / 🚨 ARIZALAR
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Binalar",
                    icon: Icons.apartment,
                    isPrimary: true,
                    lines: [
                      "Toplam: ${binalar.length}",
                      ...bolgeler.entries
                          .map((e) => "${e.key}: ${e.value}"),
                    ],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/binalar",
                        arguments: binalar,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: "Arızalar",
                    icon: Icons.build,
                    isPrimary: true,
                    lines: [
                      "Toplam: ${arizalar.length}",
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// 🔧 BAKIM / 📅 PERİYODİK
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Bakımlar",
                    icon: Icons.handyman,
                    isPrimary: true,
                    lines: [
                      "Toplam: ${bakimlar["toplam"] ?? 0}",
                      "Yapılacak: ${bakimlar["yapilacak"] ?? 0}",
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: "Periyodik",
                    icon: Icons.calendar_month,
                    isPrimary: true,
                    lines: [
                      "Yeşil: ${periyodik["Yeşil"] ?? 0}",
                      "Mavi: ${periyodik["Mavi"] ?? 0}",
                      "Sarı: ${periyodik["Sarı"] ?? 0}",
                      "Kırmızı: ${periyodik["Kırmızı"] ?? 0}",
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 📄 RAPOR / ⚙️ AYAR
            Row(
              children: const [
                Expanded(
                  child: DashboardCard(
                    title: "Raporlar",
                    icon: Icons.assignment_outlined,
                    isPrimary: false,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: "Ayarlar",
                    icon: Icons.settings_outlined,
                    isPrimary: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
