import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class StudentSignUp extends StatefulWidget {
  const StudentSignUp({super.key});

  @override
  _StudentSignUpState createState() => _StudentSignUpState();
}

class _StudentSignUpState extends State<StudentSignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _studentIDController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  File? _pdfFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imagePicker(),
                _nameInput(),
                _dobInput(),
                _studentIDInput(),
                _phoneInput(),
                _emailInput(),
                _qualificationInput(),
                _documentPicker(),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _onClick,
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePicker() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? const Icon(Icons.camera_alt, size: 40)
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          const Text("Upload Profile Image",
              style: TextStyle(color: Colors.blue, fontSize: 16)),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _dobInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: _dobController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date of Birth",
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ),
        validator: (value) => value!.isEmpty ? "Select Date of Birth" : null,
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    setState(() {
      _dobController.text = "${picked!.toLocal()}".split(' ')[0];
    });
  }

  Widget _studentIDInput() {
    return _buildTextField(
        _studentIDController, "Student ID", TextInputType.text);
  }

  Widget _phoneInput() {
    return _buildTextField(
        _phoneController, "Phone Number", TextInputType.phone);
  }

  Widget _emailInput() {
    return _buildTextField(
        _emailController, "Email", TextInputType.emailAddress);
  }

  Widget _qualificationInput() {
    return _buildTextField(
        _qualificationController, "Qualification", TextInputType.text);
  }

  Widget _nameInput() {
    return _buildTextField(_nameController, "Name", TextInputType.text);
  }

  Widget _documentPicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ElevatedButton(
        onPressed: _pickDocument,
        child: Text("Upload Document (PDF)"),
      ),
    );
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  void _onClick() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Form Submitted Successfully")),
      );
    }
  }
}
