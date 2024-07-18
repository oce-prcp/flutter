import 'package:flutter/material.dart';
import '../api/call_api.dart';
import '../common_widgets/custom_button.dart';
import '../common_widgets/loisir_card.dart';
import '../styles/styles.dart';
import '../create_loisir/create_loisir.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _loisirs;
  late Future<List<dynamic>> _types;
  late Future<dynamic> _topLoisir;
  int? _selectedTypeId;
  String _selectedTypeName = 'All';

  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _loisirs = ApiService.fetchLoisirs();
    _types = ApiService.fetchTypes();
    _topLoisir = ApiService.fetchTopLoisir();
  }

  void _filterByType(int? typeId, String typeName) {
    setState(() {
      _selectedTypeId = typeId;
      _selectedTypeName = typeName;
      if (typeId == null) {
        _loisirs = ApiService.fetchLoisirs();
      } else {
        _loisirs = ApiService.fetchLoisirsByType(typeId);
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateLoisirPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('HOME',
            style: TextStyle(color: secondaryColor, fontFamily: 'FiraSans')),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderImage(),
            _buildCategories(),
            _buildMostPopular(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeaderImage() {
    return FutureBuilder<dynamic>(
      future: _topLoisir,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(snapshot.data['imagePath']),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data['nom'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.data['description'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Notation: ${snapshot.data['notation']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Categories',
              style: TextStyle(
                  color: Colors.white, fontSize: 24, fontFamily: 'FiraSans')),
          const SizedBox(height: 8),
          FutureBuilder<List<dynamic>>(
            future: _types,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      label: 'All',
                      onPressed: () => _filterByType(null, 'All'),
                    ),
                    ...snapshot.data!.map((type) {
                      return CustomButton(
                        label: type['nom'],
                        onPressed: () => _filterByType(type['id'], type['nom']),
                      );
                    }).toList(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMostPopular() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Most Popular ($_selectedTypeName)',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'FiraSans')),
              const Text('See all', style: TextStyle(color: secondaryColor)),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<dynamic>>(
            future: _loisirs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: snapshot.data!.map((loisir) {
                      return GestureDetector(
                        onTap: () {
                          // Handle card tap
                        },
                        child: LoisirCard(
                          imagePath: loisir['imagePath'],
                          title: loisir['nom'],
                          notation: (loisir['notation'] as num).toDouble(),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: backgroundColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.white,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
      ],
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by title, genre ...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              suffixIcon: IconButton(
                icon: Icon(Icons.mic, color: Colors.grey[400]),
                onPressed: () {},
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Searches',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildChip('Action'),
                  _buildChip('Manga'),
                  _buildChip('Stranger Things'),
                ],
              ),
              SizedBox(height: 16),
              _buildSectionTitle('Popular'),
              _buildHorizontalImageList([
                'images/365dni.jpg',
                'images/got.png',
                'images/jjk.png',
                'images/spiderman.png'
              ]),
              SizedBox(height: 16),
              _buildSectionTitle('Animes'),
              _buildHorizontalImageList([
                'images/hp.jpg',
                'images/hxh.png',
                'images/snk.png',
              ]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
      ),
    );
  }

Widget _buildChip(String label) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4),
    child: Chip(
      label: Text(label),
      backgroundColor: const Color(0xFF2F70AF),
      labelStyle: TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildHorizontalImageList(List<String> imageUrls) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(imageUrls[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
