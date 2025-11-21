// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:loginsignup/data/local/global_data.dart';

// class UploadedItemsScreen extends StatefulWidget {
//   const UploadedItemsScreen({super.key});

//   @override
//   State<UploadedItemsScreen> createState() => _UploadedItemsScreenState();
// }

// class _UploadedItemsScreenState extends State<UploadedItemsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final items = GlobalData.allUploadedItems;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.brown,
//         title: const Text(
//           "Your Uploaded Items",
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         elevation: 4,
//       ),
//       backgroundColor: Colors.brown.shade50,
//       body: items.isEmpty
//           ? const Center(
//               child: Text(
//                 "No items uploaded yet!",
//                 style: TextStyle(fontSize: 18, color: Colors.brown),
//               ),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: MediaQuery.of(context).size.width < 600
//                       ? 2
//                       : 4,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 0.8,
//                 ),
//                 itemCount: items.length,
//                 itemBuilder: (context, index) {
//                   final item = items[index];
//                   return _buildAnimatedCard(item);
//                 },
//               ),
//             ),
//     );
//   }

//   Widget _buildAnimatedCard(Map<String, dynamic> item) {
//     return TweenAnimationBuilder(
//       tween: Tween<double>(begin: 0.9, end: 1.0),
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeOutBack,
//       builder: (context, scale, child) {
//         return Transform.scale(scale: scale, child: child);
//       },
//       child: InkWell(
//         onTap: () {
//           _showItemDetails(item);
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           curve: Curves.easeInOut,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 6,
//                 offset: Offset(2, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(16),
//                   ),
//                   child: Image.file(
//                     item['image'] is File
//                         ? item['image'] as File
//                         : File(item['image'].toString()),
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       color: Colors.grey[300],
//                       child: const Icon(Icons.image_not_supported, size: 50),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Text(
//                   item['title'] ?? 'Untitled',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Text(
//                   "Rent: ₹${item['price'] ?? 'N/A'}",
//                   style: const TextStyle(
//                     color: Colors.brown,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       color: Colors.brown,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         item['location'] ?? 'Indore',
//                         style: const TextStyle(
//                           fontSize: 13,
//                           color: Colors.black54,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showItemDetails(Map<String, dynamic> item) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               color: Colors.white,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.file(
//                     item['image'] is File
//                         ? item['image'] as File
//                         : File(item['image'].toString()),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   item['title'] ?? 'Untitled Property',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   "Rent: ₹${item['price'] ?? 'N/A'}",
//                   style: const TextStyle(fontSize: 16, color: Colors.brown),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   "Location: ${item['location'] ?? 'Indore'}",
//                   style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton.icon(
//                   onPressed: () => Navigator.pop(context),
//                   icon: const Icon(Icons.close),
//                   label: const Text("Close"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.brown,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loginsignup/data/local/global_data.dart';

class UploadedItemsScreen extends StatefulWidget {
  const UploadedItemsScreen({super.key});

  @override
  State<UploadedItemsScreen> createState() => _UploadedItemsScreenState();
}

class _UploadedItemsScreenState extends State<UploadedItemsScreen> {

  @override
  Widget build(BuildContext context) {
    final items = GlobalData.allUploadedItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Your Uploaded Items", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.brown.shade50,

      body: items.isEmpty
          ? const Center(
              child: Text(
                "No items uploaded yet!",
                style: TextStyle(fontSize: 18, color: Colors.brown),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildAnimatedCard(item);
                },
              ),
            ),
    );
  }

  // ------------------------------------------------------
  // 🔥 FIXED IMAGE LOADING (File or Cloudinary URL)
  // ------------------------------------------------------
  Widget _buildImage(dynamic image) {
    if (image is File) {
      return Image.file(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 50),
        ),
      );
    } else if (image is String) {
      if (image.startsWith('http')) {
        return Image.network(
          image,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 50),
          ),
        );
      }

      // treat as local file path
      try {
        final file = File(image);
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 50),
          ),
        );
      } catch (e) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported, size: 50),
        );
      }
    } else {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported, size: 50),
      );
    }
  }

  // ------------------------------------------------------
  // CARD UI
  // ------------------------------------------------------
  Widget _buildAnimatedCard(Map<String, dynamic> item) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: InkWell(
        onTap: () => _showItemDetails(item),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- IMAGE ----
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: _buildImage(item["image"]), // FIXED
                ),
              ),

              // ---- TITLE ----
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  item["title"] ?? "Untitled",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // ---- PRICE ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Rent: ₹${item['price'] ?? 'N/A'}",
                  style: const TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // ---- LOCATION ----
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.brown, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item["location"] ?? "Unknown",
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // DETAILS POPUP
  // ------------------------------------------------------
  void _showItemDetails(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImage(item["image"]),  // FIXED
                ),
                const SizedBox(height: 12),

                Text(
                  item["title"] ?? "Untitled Property",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),
                Text("Rent: ₹${item['price'] ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16, color: Colors.brown)),

                const SizedBox(height: 6),
                Text("Location: ${item['location'] ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 14, color: Colors.black54)),

                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text("Close"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
