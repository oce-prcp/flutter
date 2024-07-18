import 'package:flutter/material.dart';
import '../api/call_api.dart';
import '../common_widgets/custom_button.dart';
import '../common_widgets/loisir_card.dart';
import '../styles/styles.dart';
import '../home_page/search_page.dart';
import '../create_loisir/create_loisir_page.dart';

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

  int _selectedIndex = 0;

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
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateLoisirPage()),
      );
    } else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),  // Redirige vers SearchPage
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
                    return LoisirCard(
                      imagePath: loisir['imagePath'],
                      title: loisir['nom'],
                      notation: (loisir['notation'] as num).toDouble(),
                      description: loisir['description'],
                      dateSortie: loisir['dateSortie'],
                      typeId: loisir['typeId'],
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
          icon: Icon(Icons.playlist_add),
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