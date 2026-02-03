import 'package:flutter/material.dart';
import '../core/security/user_role.dart';
import '../core/security/secure_storage.dart';

class DrawerMenu extends StatelessWidget {
  final UserRole role;

  const DrawerMenu({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00C6A7), Color(0xFF0072BC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(child: _menuByRole(context)),
              _logout(context),
            ],
          ),
        ),
      ),
    );
  }

  // 🔷 HEADER
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        role == UserRole.admin
            ? "ADMIN PANEL"
            : role == UserRole.muhasebe
                ? "MUHASEBE PANELİ"
                : "TEKNİSYEN PANELİ",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 🔷 ROLE MENÜ
  Widget _menuByRole(BuildContext context) {
    switch (role) {
      case UserRole.admin:
        return _adminMenu(context);
      case UserRole.muhasebe:
        return _muhasebeMenu(context);
      case UserRole.teknisyen:
        return _teknisyenMenu(context);
    }
  }

  // 🟢 ADMIN
  Widget _adminMenu(BuildContext context) {
    return ListView(
      children: [
        _item(context, Icons.home, "Anasayfa", "/home"),
        _item(context, Icons.apartment, "Binalar", "/binalar"),
        _item(context, Icons.build, "Arızalar", "/arizalar"),
        _item(context, Icons.handyman, "Bakımlar", "/bakimlar"),
        _item(context, Icons.calendar_month, "Periyodik", "/periyodik"),
        _item(context, Icons.assignment, "Raporlar", "/raporlar"),
        _item(context, Icons.settings, "Ayarlar", "/ayarlar"),
      ],
    );
  }

  // 🟡 MUHASEBE
  Widget _muhasebeMenu(BuildContext context) {
    return ListView(
      children: [
        _item(context, Icons.home, "Anasayfa", "/home"),
        _item(context, Icons.receipt_long, "Faturalar", "/faturalar"),
        _item(context, Icons.payment, "Ödemeler", "/odemeler"),
        _item(context, Icons.assignment, "Raporlar", "/raporlar"),
      ],
    );
  }

  // 🔵 TEKNİSYEN
  Widget _teknisyenMenu(BuildContext context) {
    return ListView(
      children: [
        _item(context, Icons.home, "Anasayfa", "/home"),
        _item(context, Icons.build, "Arızalar", "/arizalar"),
        _item(context, Icons.handyman, "Bakımlar", "/bakimlar"),
        _item(context, Icons.calendar_month, "Periyodik", "/periyodik"),
      ],
    );
  }

  // 🔹 MENU ITEM
  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }

  // 🔴 ÇIKIŞ (TOKEN + ROLE TEMİZLE)
  Widget _logout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
        ),
        icon: const Icon(Icons.logout),
        label: const Text("Çıkış Yap"),
        onPressed: () async {
          await SecureStorage.clear(); // 🔥 token + role sil
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
        },
      ),
    );
  }
}
