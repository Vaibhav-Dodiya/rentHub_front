import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginsignup/core/services/api_service.dart';
import 'package:loginsignup/data/local/user_storage.dart';
import 'dart:typed_data';

class UploadPropertyScreen extends StatefulWidget {
  final String category;

  const UploadPropertyScreen({super.key, required this.category});

  @override
  State<UploadPropertyScreen> createState() => _UploadPropertyScreenState();
}

class _UploadPropertyScreenState extends State<UploadPropertyScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  List<XFile> _selectedImages = [];
  bool _isUploading = false;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final userData = await UserStorage.getUser();
    setState(() {
      _userId = userData['userId'] ?? '';
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    if (source == ImageSource.gallery) {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } else {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  String _getCategoryTitle() {
    switch (widget.category) {
      case 'PROPERTY':
        return 'Property';
      case 'ELECTRONICS':
        return 'Electronics Item';
      case 'FURNITURE':
        return 'Furniture Item';
      default:
        return 'Item';
    }
  }

  Color _getCategoryColor() {
    switch (widget.category) {
      case 'PROPERTY':
        return Colors.green;
      case 'ELECTRONICS':
        return Colors.purple;
      case 'FURNITURE':
        return Colors.brown;
      default:
        return Colors.orange;
    }
  }

  Future<void> _uploadProperty() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a location')));
      return;
    }

    if (_priceController.text.trim().isEmpty ||
        int.tryParse(_priceController.text.trim()) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final response = await ApiService.uploadProperty(
        title: _titleController.text.trim(),
        location: _locationController.text.trim(),
        price: int.parse(_priceController.text.trim()),
        category: widget.category,
        images: _selectedImages,
        uploadedBy: _userId,
      );

      if (mounted) {
        if (response['status'] == 'error') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Upload failed'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getCategoryTitle()} uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getCategoryColor().withOpacity(0.05),
      appBar: AppBar(
        title: Text('Upload ${_getCategoryTitle()}'),
        backgroundColor: _getCategoryColor(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Upload New ${_getCategoryTitle()}",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _getCategoryColor(),
              ),
            ),
            const SizedBox(height: 20),

            // Image Preview Section
            if (_selectedImages.isNotEmpty)
              Container(
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FutureBuilder<Uint8List>(
                              future: _selectedImages[index].readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            else
              Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!, width: 2),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No images selected',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),

            // Image Picker Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploading
                        ? null
                        : () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getCategoryColor(),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploading
                        ? null
                        : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Gallery"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getCategoryColor(),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Title Field
            TextField(
              controller: _titleController,
              enabled: !_isUploading,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter ${_getCategoryTitle().toLowerCase()} title',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.title, color: _getCategoryColor()),
              ),
            ),
            const SizedBox(height: 16),

            // Location Field
            TextField(
              controller: _locationController,
              enabled: !_isUploading,
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: 'Enter location',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.location_on, color: _getCategoryColor()),
              ),
            ),
            const SizedBox(height: 16),

            // Price Field
            TextField(
              controller: _priceController,
              enabled: !_isUploading,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price (₹)',
                hintText: 'Enter price per month',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  color: _getCategoryColor(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Upload Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadProperty,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getCategoryColor(),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUploading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Uploading to server...'),
                        ],
                      )
                    : Text(
                        'Upload ${_getCategoryTitle()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
