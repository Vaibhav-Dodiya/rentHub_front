import 'dart:io';

class GlobalData {
  static final List<Map<String, dynamic>> allUploadedItems = [];

  static void addItem(Map<String, dynamic> newItem) {
    allUploadedItems.add(newItem);
  }

  static void addItems(List<Map<String, dynamic>> items) {
    allUploadedItems.addAll(items);
  }

  static void removeItem(Map<String, dynamic> item) {
    allUploadedItems.remove(item);
  }

  static void clearAll() {
    allUploadedItems.clear();
  }
}

void preloadDummyData() {
  if (GlobalData.allUploadedItems.isEmpty) {
    GlobalData.addItems([
      {
        'title': 'Modern Flat - 2BHK',
        'price': '15000',
        'location': 'Indore',
        'image': File('assets/furniture/chairs.jpg'),
        'category': 'Flats',
      },
      {
        'title': 'Wooden Chair Set',
        'price': '450',
        'location': 'Indore',
        'image': File('assets/furniture/almirah.jpg'),
        'category': 'Furniture',
      },
      {
        'title': 'Drone Camera',
        'price': '900',
        'location': 'Indore',
        'image': File('assets/electronics/DronePic.png'),
        'category': 'Electronics',
      },
    ]);
  }
}
