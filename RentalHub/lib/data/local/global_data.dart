import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class GlobalData {
  // In-memory list. Image field may be a File or a String (path/URL).
  static final List<Map<String, dynamic>> allUploadedItems = [];

  static Future<void> addItem(Map<String, dynamic> newItem, {bool persist = true}) async {
    allUploadedItems.add(newItem);
    if (persist) await _saveToPrefs();
  }

  static Future<void> addItems(List<Map<String, dynamic>> items, {bool persist = true}) async {
    allUploadedItems.addAll(items);
    if (persist) await _saveToPrefs();
  }

  static Future<void> removeItem(Map<String, dynamic> item, {bool persist = true}) async {
    allUploadedItems.remove(item);
    if (persist) await _saveToPrefs();
  }

  static Future<void> clearAll({bool persist = true}) async {
    allUploadedItems.clear();
    if (persist) await _saveToPrefs();
  }

  // ------------------ Persistence ------------------
  static const _prefsKey = 'global_uploaded_items_v1';

  static Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Serialize items: convert File objects to paths, keep strings as-is
      final serializable = allUploadedItems.map((m) {
        final copy = Map<String, dynamic>.from(m);
        final image = copy['image'];
        if (image is File) copy['image'] = image.path;
        return copy;
      }).toList();
      final jsonStr = jsonEncode(serializable);
      await prefs.setString(_prefsKey, jsonStr);
    } catch (_) {
      // ignore persistence errors
    }
  }

  static Future<void> loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefsKey);
      if (jsonStr == null) return;
      final List<dynamic> decoded = jsonDecode(jsonStr) as List<dynamic>;
      allUploadedItems.clear();
      for (final e in decoded) {
        if (e is Map) {
          final map = Map<String, dynamic>.from(e);
          // keep image as String path — UI will handle File vs String
          allUploadedItems.add(map);
        }
      }
    } catch (_) {
      // ignore load errors
    }
  }
}

// Preload some dummy entries if empty. These use asset paths as strings.
Future<void> preloadDummyData() async {
  if (GlobalData.allUploadedItems.isEmpty) {
    await GlobalData.addItems([
      {
        'title': 'Modern Flat - 2BHK',
        'price': '15000',
        'location': 'Indore',
        'image': 'assets/furniture/chairs.jpg',
        'category': 'Flats',
      },
      {
        'title': 'Wooden Chair Set',
        'price': '450',
        'location': 'Indore',
        'image': 'assets/furniture/almirah.jpg',
        'category': 'Furniture',
      },
      {
        'title': 'Drone Camera',
        'price': '900',
        'location': 'Indore',
        'image': 'assets/electronics/DronePic.png',
        'category': 'Electronics',
      },
    ]);
  }
}
