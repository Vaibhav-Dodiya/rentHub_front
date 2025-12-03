import 'package:flutter/material.dart';
import 'package:loginsignup/core/config/config.dart';
import 'package:loginsignup/data/local/user_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loginsignup/presentation/screens/owner/edit_property_screen.dart';
import 'package:loginsignup/presentation/screens/owner/upload_property_screen.dart';
import 'package:loginsignup/presentation/screens/auth/login_screen.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  List<Map<String, dynamic>> properties = [];
  bool isLoading = true;
  String username = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userData = await UserStorage.getUser();
    setState(() {
      username = userData['username'] ?? 'Owner';
      userId = userData['userId'] ?? '';
    });
    if (userId.isNotEmpty) {
      await loadOwnerProperties();
    }
  }

  Future<void> loadOwnerProperties() async {
    setState(() => isLoading = true);

    try {
      final url = '${Config.baseUrl}/api/properties/owner/$userId';
      debugPrint('Loading owner properties from: $url');

      final response = await http.get(Uri.parse(url));
      debugPrint('Properties response status: ${response.statusCode}');
      debugPrint('Properties response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          properties = data.map((e) => e as Map<String, dynamic>).toList();
          isLoading = false;
        });
        debugPrint('Loaded ${properties.length} properties for owner $userId');
      } else {
        setState(() => isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load properties')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading properties: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    try {
      final response = await http.delete(
        Uri.parse('${Config.baseUrl}/api/properties/$propertyId'),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Property deleted successfully')),
          );
        }
        await loadOwnerProperties(); // Reload list
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete property')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error deleting property: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void showDeleteConfirmation(String propertyId, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteProperty(propertyId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    await UserStorage.clearUser();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyLogin()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owner Dashboard - $username'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadOwnerProperties,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const UploadPropertyScreen(category: 'PROPERTY'),
                ),
              );
              if (result == true) {
                await loadOwnerProperties();
              }
            },
            heroTag: 'property',
            backgroundColor: Colors.green,
            icon: const Icon(Icons.home),
            label: const Text('Upload Property'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const UploadPropertyScreen(category: 'ELECTRONICS'),
                ),
              );
              if (result == true) {
                await loadOwnerProperties();
              }
            },
            heroTag: 'electronics',
            backgroundColor: Colors.purple,
            icon: const Icon(Icons.electrical_services),
            label: const Text('Upload Electronics'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const UploadPropertyScreen(category: 'FURNITURE'),
                ),
              );
              if (result == true) {
                await loadOwnerProperties();
              }
            },
            heroTag: 'furniture',
            backgroundColor: Colors.brown,
            icon: const Icon(Icons.chair),
            label: const Text('Upload Furniture'),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : properties.isEmpty
          ? const Center(
              child: Text(
                'No properties uploaded yet',
                style: TextStyle(fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Properties (${properties.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
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
                        final imageUrls = property['imageUrls'] as List?;
                        final imageUrl =
                            (imageUrls != null && imageUrls.isNotEmpty)
                            ? imageUrls[0]
                            : '';

                        return DataRow(
                          cells: [
                            DataCell(
                              imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.broken_image,
                                                size: 60,
                                              ),
                                    )
                                  : const Icon(
                                      Icons.image_not_supported,
                                      size: 60,
                                    ),
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
                                  color: _getCategoryColor(
                                    property['category'],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  property['category'] ?? 'PROPERTY',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditPropertyScreen(
                                                property: property,
                                              ),
                                        ),
                                      );
                                      if (result == true) {
                                        await loadOwnerProperties();
                                      }
                                    },
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => showDeleteConfirmation(
                                      property['id'] ?? '',
                                      property['title'] ?? '',
                                    ),
                                    tooltip: 'Delete',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toUpperCase()) {
      case 'PROPERTY':
        return Colors.blue;
      case 'ELECTRONICS':
        return Colors.purple;
      case 'FURNITURE':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
