import 'package:flutter/material.dart';

class LoisirCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final double notation;

  LoisirCard({
    required this.imagePath,
    required this.title,
    required this.notation,
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
              //Image.network(imagePath,
              Image.asset(imagePath,
                  width: 150, height: 200, fit: BoxFit.cover),
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
