import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAppearanceSection(),
          const SizedBox(height: 24),
          _buildPreferencesSection(),
          const SizedBox(height: 24),
          _buildStorageSection(),
          const SizedBox(height: 24),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tampilan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() => _buildSettingSwitch(
                  title: 'Mode Gelap',
                  subtitle: 'Menggunakan tema gelap',
                  value: controller.isDarkMode.value,
                  onChanged: controller.toggleDarkMode,
                  icon: Icons.dark_mode,
                )),
            const SizedBox(height: 16),
            _buildLanguageSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferensi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() => _buildSettingSwitch(
                  title: 'Notifikasi',
                  subtitle: 'Terima notifikasi pesanan',
                  value: controller.notificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                  icon: Icons.notifications,
                )),
            const SizedBox(height: 16),
            Obx(() => _buildSettingSwitch(
                  title: 'Lokasi',
                  subtitle: 'Gunakan layanan lokasi',
                  value: controller.locationEnabled.value,
                  onChanged: controller.toggleLocation,
                  icon: Icons.location_on,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Penyimpanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSettingButton(
              title: 'Hapus Cache',
              subtitle: 'Bersihkan data sementara',
              icon: Icons.cleaning_services,
              onTap: controller.clearCache,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildSettingButton(
              title: 'Reset Pengaturan',
              subtitle: 'Kembalikan ke pengaturan default',
              icon: Icons.restore,
              onTap: controller.resetSettings,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tentang Aplikasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text('Versi Aplikasi'),
              subtitle: const Text('1.0.0'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: Colors.green),
              title: const Text('Kebijakan Privasi'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.purple),
              title: const Text('Syarat & Ketentuan'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.contact_support, color: Colors.orange),
              title: const Text('Bantuan & Dukungan'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFF2196F3),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      children: [
        const Icon(Icons.language, color: Colors.blue),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bahasa', style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 2),
              Text('Pilih bahasa aplikasi',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Obx(() => DropdownButton<String>(
              value: controller.language.value,
              items: const [
                DropdownMenuItem(value: 'id', child: Text('Indonesia')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.changeLanguage(value);
                }
              },
            )),
      ],
    );
  }

  Widget _buildSettingButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
