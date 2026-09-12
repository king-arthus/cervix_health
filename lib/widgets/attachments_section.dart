import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../localization/translator.dart';
import '../models/screening_models.dart';
import '../models/user_model.dart';
import '../services/app_data.dart';

/// Section "Pièces jointes" affichée sur l'écran de dossier, côté agent et
/// côté spécialiste. Permet d'ajouter une photo (galerie ou appareil photo)
/// ou un fichier quelconque (via le gestionnaire de fichiers), et affiche les
/// pièces déjà jointes avec un aperçu pour les images.
///
/// Limites volontaires : maximum 3 pièces jointes par dossier, images
/// compressées avant envoi — pour ne pas alourdir la synchronisation cloud.
class AttachmentsSection extends StatefulWidget {
  final ScreeningRequest request;
  const AttachmentsSection({super.key, required this.request});

  @override
  State<AttachmentsSection> createState() => _AttachmentsSectionState();
}

class _AttachmentsSectionState extends State<AttachmentsSection> {
  static const _maxAttachments = 3;
  final ImagePicker _imagePicker = ImagePicker();
  bool _busy = false;

  Future<void> _addImage(ImageSource source) async {
    try {
      final file = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 65,
      );
      if (file == null) return;
      setState(() => _busy = true);
      final bytes = await file.readAsBytes();
      await _saveAttachment(fileName: file.name, mimeType: 'image/jpeg', bytes: bytes);
    } catch (_) {
      _showError();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(withData: true);
      if (result == null || result.files.isEmpty) return;
      final picked = result.files.first;
      if (picked.bytes == null) return;
      setState(() => _busy = true);
      final ext = (picked.extension ?? '').toLowerCase();
      final mimeType = switch (ext) {
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'pdf' => 'application/pdf',
        _ => 'application/octet-stream',
      };
      await _saveAttachment(fileName: picked.name, mimeType: mimeType, bytes: picked.bytes!);
    } catch (_) {
      _showError();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveAttachment({
    required String fileName,
    required String mimeType,
    required List<int> bytes,
  }) async {
    if (widget.request.attachments.length >= _maxAttachments) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.t('max_attachments_reached'))));
      }
      return;
    }
    final appData = context.read<AppData>();
    final me = appData.currentUser;
    final attachment = DossierAttachment(
      id: const Uuid().v4(),
      fileName: fileName,
      mimeType: mimeType,
      base64Data: base64Encode(bytes),
      addedByName: me?.fullName ?? '',
      addedAt: DateTime.now(),
    );
    widget.request.attachments.add(attachment);
    await appData.updateScreeningRequest(widget.request);
    if (mounted) setState(() {});
  }

  Future<void> _removeAttachment(DossierAttachment attachment) async {
    widget.request.attachments.removeWhere((a) => a.id == attachment.id);
    await context.read<AppData>().updateScreeningRequest(widget.request);
    if (mounted) setState(() {});
  }

  void _showError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t('attachment_error'))));
  }

  void _openPicker() {
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
                _addImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.t('take_photo')),
              onTap: () {
                Navigator.pop(ctx);
                _addImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_open_outlined),
              title: Text(context.t('choose_from_files')),
              onTap: () {
                Navigator.pop(ctx);
                _addFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openPreview(DossierAttachment attachment) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: attachment.isImage
            ? InteractiveViewer(child: Image.memory(base64Decode(attachment.base64Data)))
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.insert_drive_file_outlined, size: 48),
                    const SizedBox(height: 12),
                    Text(attachment.fileName, textAlign: TextAlign.center),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final me = context.watch<AppData>().currentUser;
    final canEdit = me != null &&
        (me.role == UserRole.agent || me.role == UserRole.specialiste);
    final attachments = widget.request.attachments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(context.t('attachments_title'), style: Theme.of(context).textTheme.titleSmall),
            ),
            if (canEdit && attachments.length < _maxAttachments)
              TextButton.icon(
                onPressed: _busy ? null : _openPicker,
                icon: _busy
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.attach_file, size: 18),
                label: Text(context.t('add_attachment')),
              ),
          ],
        ),
        if (attachments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(context.t('no_attachments'), style: Theme.of(context).textTheme.bodySmall),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: attachments.map((a) {
              return GestureDetector(
                onTap: () => _openPreview(a),
                child: Stack(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: a.isImage
                          ? Image.memory(base64Decode(a.base64Data), fit: BoxFit.cover)
                          : const Center(child: Icon(Icons.insert_drive_file_outlined, size: 32)),
                    ),
                    if (canEdit)
                      Positioned(
                        top: -6,
                        right: -6,
                        child: GestureDetector(
                          onTap: () => _removeAttachment(a),
                          child: const CircleAvatar(
                            radius: 11,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
