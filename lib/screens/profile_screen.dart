import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../localization/translator.dart';
import '../models/user_model.dart';
import '../services/app_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _loading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (file == null) return;
      setState(() => _loading = true);
      final Uint8List bytes = await file.readAsBytes();
      final String base64Str = base64Encode(bytes);
      await context.read<AppData>().updateProfilePhoto(base64Str);
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t('profile_updated'))));
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showPhotoOptions() {
    final user = context.read<AppData>().currentUser;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(context.t('choose_from_gallery')),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.t('take_photo')),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            if (user?.photoBase64 != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(context.t('remove_photo'), style: const TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(ctx);
                  await context.read<AppData>().updateProfilePhoto(null);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppData>().currentUser;
    if (user == null) return const SizedBox.shrink();

    ImageProvider? avatarImage;
    if (user.photoBase64 != null && user.photoBase64!.isNotEmpty) {
      try {
        avatarImage = MemoryImage(base64Decode(user.photoBase64!));
      } catch (_) {
        avatarImage = null;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.t('my_profile'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: avatarImage,
                  child: avatarImage == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white70)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _loading ? null : _showPhotoOptions,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: _loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: _loading ? null : _showPhotoOptions,
              child: Text(context.t('change_photo')),
            ),
          ),
          const SizedBox(height: 24),
          Text(context.t('personal_info'), style: Theme.of(context).textTheme.titleMedium),
          const Divider(height: 24),
          _infoRow(context, Icons.person_outline, user.fullName),
          _infoRow(context, Icons.alternate_email, user.email),
          _infoRow(context, Icons.cake_outlined, '${user.age}'),
          _infoRow(context, Icons.phone_outlined, user.contact),
          if (user.role == UserRole.agent || user.role == UserRole.specialiste) ...[
            if (user.employerFacility != null) _infoRow(context, Icons.local_hospital_outlined, user.employerFacility!),
            if (user.position != null) _infoRow(context, Icons.badge_outlined, user.position!),
            if (user.specialty != null) _infoRow(context, Icons.biotech_outlined, user.specialty!),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
