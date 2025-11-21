import 'package:flutter/material.dart';
import 'package:loginsignup/presentation/screens/categories/electronics_screen.dart';
import 'package:loginsignup/presentation/screens/categories/furniture_screen.dart';
import 'package:loginsignup/presentation/screens/categories/property_screen.dart';
import 'package:loginsignup/presentation/screens/profile/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.electrical_services, "title": "Electronics"},
    {"icon": Icons.chair, "title": "Furniture"},
    {"icon": Icons.home, "title": "Flats"},
  ];

  final List<Map<String, String>> featuredProducts = [
    {
      "image": "assets/electronics/cameraHD.png",
      "title": "Nikon Camera",
      "price": "₹650",
    },
    {
      "image": "assets/furniture/chairs.jpg",
      "title": "Wooden Chair",
      "price": "₹450",
    },
    {
      "image": "assets/electronics/mic.png",
      "title": "Recording Mic",
      "price": "₹300",
    },
    {
      "image": "assets/electronics/DronePic.png",
      "title": "Drone Camera",
      "price": "₹900",
    },
  ];

  final List<Map<String, String>> bestSellers = [
    {
      "image": "assets/electronics/headphone.png",
      "title": "Boat Headphones",
      "price": "₹400",
    },
    {
      "image": "assets/furniture/almirah.jpg",
      "title": "Almirah for Bedroom",
      "price": "₹1200",
    },
    {"image": "assets/electronics/tv.jpg", "title": "LED TV", "price": "₹1500"},
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("RENT HUB"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 28, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              size: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(screenWidth),
            const SizedBox(height: 16),
            _buildSectionTitle("Shop by Category"),
            _buildCategoryList(),
            const SizedBox(height: 20),
            _buildSectionTitle("Featured Items"),
            _buildProductList(featuredProducts, screenWidth),
            const SizedBox(height: 20),
            _buildSectionTitle("Best Sellers"),
            _buildProductList(bestSellers, screenWidth),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.brown.shade50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown),
              child: Center(
                child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.brown),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.electrical_services,
                color: Colors.brown,
              ),
              title: const Text("Electronics"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyElectronics()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chair, color: Colors.brown),
              title: const Text("Furniture"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyFurniture()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.home_repair_service_outlined,
                color: Colors.brown,
              ),
              title: const Text("Property"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyProperty()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.brown),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfilePage(role: '', userId: ''),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.brown),
              title: const Text("Settings"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(double screenWidth) {
    final double bannerHeight = screenWidth < 600 ? 150 : 250;
    return SizedBox(
      height: bannerHeight,
      child: PageView(
        children: [
          _bannerCard("assets/banners/banner2.jpg"),
          _bannerCard("assets/banners/banner1.jpg"),
          _bannerCard("assets/banners/banner3.jpg"),
        ],
      ),
    );
  }

  Widget _bannerCard(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                elevation: 4,
              ),
              onPressed: () {
                if (cat['title'] == "Electronics") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyElectronics()),
                  );
                } else if (cat['title'] == "Furniture") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyFurniture()),
                  );
                } else if (cat['title'] == "Flats") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyProperty()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${cat['title']} screen not linked yet"),
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat['icon'], size: 36, color: Colors.brown),
                  const SizedBox(height: 6),
                  Text(
                    cat['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductList(
    List<Map<String, String>> products,
    double screenWidth,
  ) {
    final double cardWidth = screenWidth < 600 ? 140 : 200;
    return SizedBox(
      height: cardWidth + 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final prod = products[index];
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${prod['title']} clicked")),
              );
            },
            child: Container(
              width: cardWidth,
              margin: const EdgeInsets.symmetric(horizontal: 8),
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
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(
                      prod['image']!,
                      height: cardWidth,
                      width: cardWidth,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: cardWidth,
                        width: cardWidth,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      prod['title']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      prod['price']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
