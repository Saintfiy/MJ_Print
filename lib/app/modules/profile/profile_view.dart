import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          Obx(() => IconButton(
                icon:
                    Icon(controller.isEditing.value ? Icons.close : Icons.edit),
                onPressed: controller.toggleEditMode,
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 32),
            _buildProfileForm(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Obx(() => Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF2196F3),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              controller.user.value?.name ?? '-',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              controller.user.value?.email ?? '-',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ));
  }

  Widget _buildProfileForm() {
    return Obx(() => Column(
          children: [
            _buildInfoCard(
              'Informasi Pribadi',
              [
                _buildEditableField(
                  label: 'Nama',
                  controller: controller.nameController,
                  icon: Icons.person,
                  enabled: controller.isEditing.value,
                ),
                _buildEditableField(
                  label: 'Email',
                  controller: controller.emailController,
                  icon: Icons.email,
                  enabled: controller.isEditing.value,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildEditableField(
                  label: 'Telepon',
                  controller: controller.phoneController,
                  icon: Icons.phone,
                  enabled: controller.isEditing.value,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              'Alamat Pengiriman',
              [
                _buildEditableField(
                  label: 'Alamat',
                  controller: controller.addressController,
                  icon: Icons.location_on,
                  enabled: controller.isEditing.value,
                  maxLines: 2,
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2196F3)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                enabled
                    ? TextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        maxLines: maxLines,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        controller.text.isEmpty ? '-' : controller.text,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(() => Column(
          children: [
            if (controller.isEditing.value) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.updateProfile,
                  icon: controller.isLoading.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Simpan Perubahan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: controller.toggleEditMode,
                  child: const Text('Batal'),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: controller.toggleEditMode,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profil'),
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: controller.logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ));
  }
}
