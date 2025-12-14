import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'location_controller.dart';
import 'package:mj_print/core/models/location_model.dart'; // IMPORT INI DITAMBAHKAN

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi & Peta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showLocationHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildLocationInfo(),
          Expanded(
            child: _buildMap(),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Obx(() => Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Status Lokasi',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Text(controller.getLocationProviderText()),
                      backgroundColor:
                          controller.locationProvider.value == 'gps'
                              ? Colors.blue[100]
                              : Colors.green[100],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (controller.hasLocation) ...[
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${controller.latitude.toStringAsFixed(6)}, ${controller.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // PERBAIKAN: Ganti Icons.accuracy dengan Icons.gps_fixed
                      const Icon(Icons.gps_fixed, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('Akurasi: ${controller.getAccuracyText()}'),
                    ],
                  ),
                ] else ...[
                  const Text(
                    'Lokasi belum tersedia',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
                if (controller.isTracking.value) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.track_changes,
                          size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Live Tracking: AKTIF',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ));
  }

  Widget _buildMap() {
    return Obx(() => FlutterMap(
          options: MapOptions(
            center: controller.hasLocation
                ? LatLng(controller.latitude, controller.longitude)
                : const LatLng(-7.250445, 112.768845), // Default to Malang
            zoom: 15.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.mjprint.app',
            ),
            if (controller.hasLocation)
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(controller.latitude, controller.longitude),
                    width: 40,
                    height: 40,
                    builder: (context) => const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        ));
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.3 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => ElevatedButton.icon(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.getCurrentLocation,
                  icon: controller.isLoading.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: const Text('Dapatkan Lokasi'),
                )),
          ),
          const SizedBox(width: 12),
          Obx(() => IconButton(
                onPressed: controller.toggleTracking,
                icon: Icon(
                  controller.isTracking.value
                      ? Icons.stop_circle
                      : Icons.play_arrow,
                  color:
                      controller.isTracking.value ? Colors.red : Colors.green,
                ),
                tooltip: controller.isTracking.value
                    ? 'Stop Tracking'
                    : 'Start Tracking',
              )),
          const SizedBox(width: 8),
          IconButton(
            onPressed: controller.toggleLocationProvider,
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Ganti Provider',
          ),
        ],
      ),
    );
  }

  void _showLocationHistory() {
    Get.bottomSheet(
      Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            const Text(
              'Riwayat Lokasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() => Expanded(
                  child: controller.locationHistory.isEmpty
                      ? const Center(
                          child: Text('Tidak ada riwayat lokasi'),
                        )
                      : ListView.builder(
                          itemCount: controller.locationHistory.length,
                          itemBuilder: (context, index) {
                            final location = controller.locationHistory[index];
                            return _buildHistoryItem(location, index);
                          },
                        ),
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.clearLocationHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Hapus Riwayat'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(LocationModel location, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.location_history, color: Colors.blue),
        title: Text(
          '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
          style: const TextStyle(fontFamily: 'monospace'),
        ),
        subtitle: Text(
          'Akurasi: ${location.accuracy?.toStringAsFixed(1) ?? 'N/A'}m • ${location.provider.toUpperCase()}',
        ),
        trailing: Text(
          '${location.timestamp.hour}:${location.timestamp.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
