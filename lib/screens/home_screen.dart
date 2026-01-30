import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/drawer_menu.dart';
import '../core/security/user_role.dart';
import '../core/security/secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserRole? role;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final r = await SecureStorage.getRole();
    if (!mounted) return;
    setState(() => role = r);
  }

  @override
  Widget build(BuildContext context) {
    // ⏳ Role gelene kadar bekle
    if (role == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: DrawerMenu(role: role!), // 🔥 GERÇEK ROLE
      appBar: AppBar(
        title: const Text("Baykod Asansör Takip Sistemi"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            InfoCard(),
            SizedBox(height: 16),

            /// GRID
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Binalar",
                    icon: Icons.apartment,
                    lines: [
                      "Toplam: 8",
                      "1: 2",
                      "333: 1",
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: "Arızalar",
                    icon: Icons.build,
                    lines: [
                      "Toplam: 0",
                      "Yapılmadı: 0",
                      "Yapıldı: 0",
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Bakımlar",
                    icon: Icons.handyman,
                    lines: [
                      "Toplam: 0",
                      "Yapılacak: 1",
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: "Periyodik",
                    icon: Icons.calendar_month,
                    lines: [
                      "Yeşil: 3",
                      "Mavi: 1",
                      "Kırmızı: 2",
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Raporlar",
                    icon: Icons.assignment,
                    isPrimary: false,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: "Ayarlar",
                    icon: Icons.settings,
                    isPrimary: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
