import 'package:flutter/material.dart';
import '../api/call_api.dart';
import '../common_widgets/loisir_card.dart';
import '../create_loisir/create_loisir_page.dart';
import '../styles/styles.dart';
import 'home_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<dynamic>> _loisirs;
  List<dynamic> _filteredLoisirs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _loisirs = ApiService.fetchLoisirs();
    _loisirs.then((loisirs) {
      setState(() {
        _filteredLoisirs = loisirs;
      });
    });
  }

  void _filterLoisirs(String query) {
    _loisirs.then((loisirs) {
      setState(() {
        if (query.isEmpty) {
          _filteredLoisirs = loisirs;
        } else {
          _filteredLoisirs = loisirs
              .where((loisir) =>
                  loisir['nom'].toLowerCase().contains(query.toLowerCase()) ||
                  loisir['description']
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList();
        }
      });
    });
  }

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
            color: const Color(0xFF806491),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filterLoisirs,
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
      body: FutureBuilder<List<dynamic>>(
        future: _loisirs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                _buildRecentSearches(),
                const SizedBox(height: 16),
                Text(
                  'Results',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildResultsList(),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFFB9848C),
        unselectedItemColor: Colors.white,
        currentIndex: 0,
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateLoisirPage()),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SearchPage()), // Redirige vers SearchPage
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage()), // Redirige vers SearchPage
            );
          }
        },
        items: const <BottomNavigationBarItem>[
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
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Searches',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: [
            _buildChip('Action'),
            _buildChip('Manga'),
            _buildChip('Stranger Things'),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        label: Text(label),
        backgroundColor: const Color(0xFF2F70AF),
        labelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return _filteredLoisirs.isNotEmpty
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.6,
            ),
            itemCount: _filteredLoisirs.length,
            itemBuilder: (context, index) {
              final loisir = _filteredLoisirs[index];
              return Center(
                child: LoisirCard(
                  imagePath: loisir['imagePath'],
                  title: loisir['nom'],
                  notation: (loisir['notation'] as num).toDouble(),
                  description: loisir['description'], 
                  dateSortie: loisir['dateSortie'],
                  typeId: loisir['typeId'],
                  loisirId: loisir['id'], 
                ),
              );
            },
          )
        : Center(
            child: Text(
              'No results found',
              style: TextStyle(color: Colors.white),
            ),
          );
  }
}
