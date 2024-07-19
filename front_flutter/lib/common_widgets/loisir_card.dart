import 'package:flutter/material.dart';
import '../detail_page/detail_page.dart';
import '../config.dart';

class LoisirCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final double notation;
  final String? description;
  final String? dateSortie;
  final int? typeId;
  final int loisirId;  

  LoisirCard({
    required this.imagePath,
    required this.title,
    required this.notation,
    this.description,
    this.dateSortie,
    this.typeId,
    required this.loisirId,  
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          color: Colors.black54,
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        imagePath: imagePath,
                        title: title,
                        notation: notation,
                        description: description,
                        dateSortie: dateSortie,
                        typeId: typeId,
                        loisirId: loisirId,  
                      ),
                    ),
                  );
                },
                child: Image.network(
                  '${Config.apiUrl}$imagePath',
                  width: 150,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Notation: $notation',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
