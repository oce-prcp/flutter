import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../common_widgets/custom_button.dart';

class DetailPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final double notation;
  final String? description;
  final String? dateSortie;
  final int? typeId;

  const DetailPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.notation,
    this.description,
    this.dateSortie,
    this.typeId,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(color: secondaryColor, fontFamily: 'FiraSans')),
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
          ],
        ),
      ),
      //bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildImage() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitleAndDate() {
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
            "${widget.dateSortie ?? 'Date de sortie inconnue'} - type ${widget.typeId ?? 'Inconnu'} - 2h32",
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
            label: "${widget.notation} / 5",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
