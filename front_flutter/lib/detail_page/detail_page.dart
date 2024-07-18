import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../api/call_api.dart';
import '../common_widgets/custom_button.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('PRODUCT',
            style: TextStyle(color: secondaryColor, fontFamily: 'FiraSans')),
        backgroundColor: backgroundColor,
        elevation: 0,
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
          ]
        ),
      ),
      //bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildImage() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: const BoxDecoration(
        image: DecorationImage(
          // TO DO : dynamic 
          image: AssetImage("images/intouchable.webp"),
          fit: BoxFit.cover,
        ),
      )
    );
  }

  Widget _buildTitleAndDate() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Nom du Produit', // TO DO dynamic 
             style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "date de sortie - type - 2h32", // TO DO dynamic
            style: TextStyle(
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
                onPressed: () {
                  // TO DO
                },
                backgroundColor: Colors.blue,
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
                backgroundColor: Colors.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',  
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'FiraSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla ", // to do dynamic
            style: TextStyle(
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
      padding: const EdgeInsets.all(2.0),
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
            label: "4.5 /5",
            onPressed: () {},
          ),
        ],
      ),
    );
  }

}