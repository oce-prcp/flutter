import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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

      String imagePath;

      if (!kIsWeb) {
        // Save the image locally on non-web platforms
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = basename(_image!.path);
        final savedImage =
            await File(_image!.path).copy('${appDir.path}/$fileName');
        imagePath = savedImage.path;
      } else {
        imagePath = _image!.path;
      }

      final loisirData = {
        'nom': _nom,
        'description': _description,
        'dateSortie': _dateSortie!.toIso8601String(),
        'notation': _notation,
        'typeId': _typeId,
        'imagePath': imagePath,
      };

      await ApiService.createLoisir(loisirData);

      Navigator.pop(context as BuildContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextFieldLabel(label: 'Name'),
                      CustomTextField(
                        hintText: 'Enter name',
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
                      const SizedBox(height: 16),
                      const TextFieldLabel(label: 'Description'),
                      CustomTextField(
                        hintText: 'Enter description',
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
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TextFieldLabel(label: 'Notation'),
                                CustomTextField(
                                  hintText: 'Enter notation',
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
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TextFieldLabel(label: 'Release date'),
                                CustomTextField(
                                  hintText: 'Select date',
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
                                        : DateFormat('yyyy-MM-dd')
                                            .format(_dateSortie!),
                                  ),
                                  onSaved: (value) {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const TextFieldLabel(label: 'Image'),
                      _image == null
                          ? const Text('No image selected.')
                          : kIsWeb
                              ? Image.network(_image!.path, height: 200)
                              : Image.file(File(_image!.path), height: 200),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                        ),
                        child: const Text('Select Image'),
                      ),
                      const SizedBox(height: 16),
                      const TextFieldLabel(label: 'Type'),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          hintText: 'Select type',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
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
                      ElevatedButton(
                        onPressed: _saveLoisir,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Ajouter',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      backgroundColor: backgroundColor,
    );
  }
}

class TextFieldLabel extends StatelessWidget {
  final String label;

  const TextFieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool readOnly;
  final TextInputType keyboardType;
  final Function(String?) onSaved;
  final String? Function(String?) validator;
  final Function()? onTap;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    required this.onSaved,
    required this.validator,
    this.onTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
