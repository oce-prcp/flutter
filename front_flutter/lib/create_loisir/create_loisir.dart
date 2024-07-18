import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../api/call_api.dart';
import '../styles/styles.dart';

class CreateLoisirPage extends StatefulWidget {
  @override
  _CreateLoisirPageState createState() => _CreateLoisirPageState();
}

class _CreateLoisirPageState extends State<CreateLoisirPage> {
  final _formKey = GlobalKey<FormState>();
  String? _nom;
  String? _description;
  double? _notation;
  String? _dateSortie;
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveLoisir() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save the image locally
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = _image!.path.split('/').last;
      final savedImage = await _image!.copy('${appDir.path}/$fileName');

      // Prepare the data to send to the backend
      final loisirData = {
        'nom': _nom,
        'description': _description,
        'notation': _notation,
        'dateSortie': _dateSortie,
        'imagePath': savedImage.path,
      };

      // Send the data to the backend
      await ApiService.createLoisir(loisirData);

      // Navigate back or show a success message
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Loisir',
            style: TextStyle(color: secondaryColor, fontFamily: 'FiraSans')),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nom = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Notation'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a notation';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _notation = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Date de Sortie'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a release date';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _dateSortie = value;
                  },
                ),
                const SizedBox(height: 16),
                _image == null
                    ? const Text('No image selected.')
                    : Image.file(_image!, height: 200),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Image'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveLoisir,
                  child: const Text('Save Loisir'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
