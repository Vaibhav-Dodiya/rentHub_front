import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyFurniture extends StatefulWidget {
  const MyFurniture({super.key});

  @override
  State<MyFurniture> createState() => _MyFurnitureState();
}

class _MyFurnitureState extends State<MyFurniture> {
  final List<Map<String, dynamic>> products = [
    {
      "image": "assets/furniture/almirah.jpg",
      "title": "Almirah for your Bedroom",
      "price": 1250,
      "oldPrice": 1680,
      "discount": "41% off",
      "rating": 4.2,
      "reviews": 6331,
      "delivery": "₹350 Delivery",
      "userUploaded": false,
    },
    {
      "image": "assets/furniture/chairs2.jpg",
      "title": "Comfortable Chair",
      "price": 400,
      "oldPrice": 499,
      "discount": "21% off",
      "rating": 4.0,
      "reviews": 3175,
      "delivery": "Delivery ₹140",
      "userUploaded": false,
    },
    {
      "image": "assets/furniture/chairs.jpg",
      "title": "Wooden Chairs Set of 2",
      "price": 700,
      "oldPrice": 900,
      "discount": "18% off",
      "rating": 4.4,
      "reviews": 599,
      "delivery": "Delivery ₹160",
      "userUploaded": false,
    },
    {
      "image": "assets/furniture/almirah.jpg",
      "title": "Almirah for Clothes",
      "price": 900,
      "oldPrice": 1130,
      "discount": "18% off",
      "rating": 4.1,
      "reviews": 2968,
      "delivery": "Delivery ₹240",
      "userUploaded": false,
    },
  ];

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showUploadForm() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final oldPriceController = TextEditingController();
    final deliveryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Upload New Item",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, size: 50),
                          ),
                    if (_selectedImage != null)
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Camera"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo),
                      label: const Text("Gallery"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Item Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "New Price",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: oldPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Old Price",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deliveryController,
                  decoration: const InputDecoration(
                    labelText: "Delivery Info",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        priceController.text.isEmpty ||
                        _selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please fill all fields and select an image",
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      products.add({
                        "image": _selectedImage!.path,
                        "title": titleController.text,
                        "price": int.tryParse(priceController.text) ?? 0,
                        "oldPrice": int.tryParse(oldPriceController.text) ?? 0,
                        "discount": "New",
                        "rating": 0.0,
                        "reviews": 0,
                        "delivery": deliveryController.text,
                        "userUploaded": true,
                      });
                      _selectedImage = null;
                    });

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Add Item"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(
    Map<String, dynamic> product,
    int index,
    double imageHeight,
  ) {
    final imagePath = product["image"];
    final String? discount = product["discount"];
    final bool isNew = discount == "New";

    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: imagePath.startsWith("assets/")
                      ? Image.asset(imagePath, fit: BoxFit.cover)
                      : Image.file(File(imagePath), fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product["title"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "₹${product["price"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (product["oldPrice"] > 0)
                          Text(
                            "₹${product["oldPrice"]}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product["delivery"],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (discount != null && discount.isNotEmpty)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isNew ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                discount,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        if (product["userUploaded"] == true)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  products.removeAt(index);
                });
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    double cardWidth =
        (screenWidth - (crossAxisCount + 1) * 12) / crossAxisCount;
    double imageHeight = cardWidth * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: const Text("✨ Choose Your Furniture"),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: cardWidth / (imageHeight + 100),
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(products[index], index, imageHeight);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.add),
        label: const Text("Upload Item"),
        onPressed: _showUploadForm,
      ),
    );
  }
}
