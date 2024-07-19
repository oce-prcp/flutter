import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../styles/styles.dart';
import '../common_widgets/custom_button.dart';
import '../api/call_api.dart';
import '../config.dart'; // Assurez-vous d'avoir ce fichier de configuration
import '../home_page/search_page.dart';
import '../create_loisir/create_loisir_page.dart';

class DetailPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final double notation;
  final String? description;
  final String? dateSortie;
  final int? typeId;
  final int loisirId; 

  const DetailPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.notation,
    this.description,
    this.dateSortie,
    this.typeId,
    required this.loisirId,  
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String typeName = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getTypeName();
  }

  Future<void> getTypeName() async {
    try {
      dynamic responseData =
          await ApiService.fetchTypeById(widget.typeId ?? -1);
      if (responseData is String) {
        setState(() {
          typeName = responseData;
        });
      } else if (responseData is Map<String, dynamic>) {
        String name = responseData['nom'];
        setState(() {
          typeName = name;
        });
      } else {
        setState(() {
          typeName = '';
        });
      }
    } catch (e) {
      setState(() {
        typeName = '';
      });
    }
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
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _deleteLoisir() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation de suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ce loisir ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.deleteLoisir(widget.loisirId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loisir supprimé avec succès')),
        );
        Navigator.pop(context); // Retourne à la page précédente après la suppression
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.title,
            style:
                const TextStyle(color: secondaryColor, fontFamily: 'FiraSans')),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImage(),
            _buildTitleAndDate(),
            _buildEditDeleteButtons(),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildDescription(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _buildNotation(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildImage() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('${Config.apiUrl}${widget.imagePath}'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitleAndDate() {
    String formattedDate = widget.dateSortie != null
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.dateSortie!))
        : '';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "$formattedDate ${typeName.isNotEmpty ? "- $typeName" : ''}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditDeleteButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CustomButton(
                icon: Icons.delete,
                label: "Delete",
                onPressed: _deleteLoisir, // Appel de la méthode pour supprimer
                backgroundColor: primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: CustomButton(
                icon: Icons.edit,
                label: "Edit",
                onPressed: () {
                  // TO DO
                },
                backgroundColor: secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'FiraSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.description ?? 'Description non disponible.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotation() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 2.0, top: 2.0, right: 16.0, bottom: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'Avis de nos utilisateurs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'FiraSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          CustomButton(
            label: "${widget.notation} / 5",
            onPressed: () {},
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
      items: const [
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
