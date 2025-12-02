import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loginsignup/core/config/config.dart';

class PostsManagement extends StatefulWidget {
  const PostsManagement({super.key});

  @override
  State<PostsManagement> createState() => _PostsManagementState();
}

class _PostsManagementState extends State<PostsManagement> {
  List<dynamic> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/api/properties'),
      );

      if (response.statusCode == 200) {
        setState(() {
          properties = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Failed to load posts')));
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _deleteProperty(String propertyId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await http.delete(
        Uri.parse('${Config.baseUrl}/api/properties/$propertyId'),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post deleted successfully')),
          );
        }
        _loadProperties();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete post')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (properties.isEmpty) {
      return const Center(
        child: Text('No posts found', style: TextStyle(fontSize: 18)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Posts Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Location')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: properties.map((property) {
                  final imageUrl =
                      (property['imageUrls'] as List?)?.isNotEmpty == true
                      ? property['imageUrls'][0]
                      : null;
                  return DataRow(
                    cells: [
                      DataCell(
                        imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                              )
                            : const Icon(Icons.image_not_supported),
                      ),
                      DataCell(Text(property['title'] ?? '')),
                      DataCell(Text(property['location'] ?? '')),
                      DataCell(Text('₹${property['price'] ?? 0}')),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(property['category']),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            property['category'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProperty(property['id']),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toUpperCase()) {
      case 'PROPERTY':
        return Colors.orange;
      case 'FURNITURE':
        return Colors.brown;
      case 'ELECTRONICS':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
