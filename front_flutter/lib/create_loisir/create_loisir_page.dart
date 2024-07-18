import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../api/call_api.dart';
import '../styles/styles.dart';

class CreateLoisirPage extends StatefulWidget {
  const CreateLoisirPage({super.key});

  @override
  _CreateLoisirPageState createState() => _CreateLoisirPageState();
}

class _CreateLoisirPageState extends State<CreateLoisirPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _nom;
  String? _description;
  DateTime? _dateSortie;
  double? _notation;
  int? _typeId;
  List<dynamic>? _types;

  @override
  void initState() {
    super.initState();
    _fetchTypes();
  }

  Future<void> _fetchTypes() async {
    _types = await ApiService.fetchTypes();
    setState(() {});
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _saveLoisir() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_image == null) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(_image!.path);
      final savedImage =
          await File(_image!.path).copy('${appDir.path}/$fileName');

      final loisirData = {
        'nom': _nom,
        'description': _description,
        'dateSortie': _dateSortie!.toIso8601String(),
        'notation': _notation,
        'typeId': _typeId,
        'imagePath': savedImage.path,
      };

      await ApiService.createLoisir(loisirData);

      Navigator.pop(context as BuildContext);
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
      body: _types == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                        decoration:
                            const InputDecoration(labelText: 'Description'),
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
                        decoration:
                            const InputDecoration(labelText: 'Date de Sortie'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dateSortie = pickedDate;
                            });
                          }
                        },
                        readOnly: true,
                        validator: (value) {
                          if (_dateSortie == null) {
                            return 'Please select a release date';
                          }
                          return null;
                        },
                        controller: TextEditingController(
                          text: _dateSortie == null
                              ? ''
                              : DateFormat('yyyy-MM-dd').format(_dateSortie!),
                        ),
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Notation'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a notation';
                          }
                          double? notation = double.tryParse(value);
                          if (notation == null ||
                              notation > 5.0 ||
                              notation < 0.0) {
                            return 'Please enter a valid notation (0-5)';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _notation = double.parse(value!);
                        },
                      ),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(labelText: 'Type'),
                        items: _types!.map<DropdownMenuItem<int>>((type) {
                          return DropdownMenuItem<int>(
                            value: type['id'],
                            child: Text(type['nom']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _typeId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a type';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _typeId = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      _image == null
                          ? const Text('No image selected.')
                          : Image.file(File(_image!.path), height: 200),
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
