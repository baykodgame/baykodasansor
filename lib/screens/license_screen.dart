import 'package:flutter/material.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lisans")),
      body: const Center(
        child: Text(
          "LİSANS SATIN ALMA SAYFASI",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
