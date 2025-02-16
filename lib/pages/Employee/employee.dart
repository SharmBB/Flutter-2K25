import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EmployeeSignUp extends StatefulWidget {
  const EmployeeSignUp({super.key});

  @override
  _EmployeeSignUpState createState() => _EmployeeSignUpState();
}

class _EmployeeSignUpState extends State<EmployeeSignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _employeeNumberController =
      TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedDepartment;
  final List<String> _departments = ["HR", "IT", "Engineering"];

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Staff Management ")),
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
                _nicInput(),
                _phoneInput(),
                _emailInput(),
                _employeeNumberInput(),
                _positionInput(),
                _addressInput(),
                _departmentDropdown(),
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
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Widget _departmentDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: "Department",
          border: OutlineInputBorder(),
        ),
        value: _selectedDepartment,
        items: _departments.map((String department) {
          return DropdownMenuItem<String>(
            value: department,
            child: Text(department),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedDepartment = value;
          });
        },
        validator: (value) => value == null ? 'Select a department' : null,
      ),
    );
  }

  Widget _nameInput() {
    return _buildTextField(_nameController, "Name", TextInputType.text);
  }

  Widget _nicInput() {
    return _buildTextField(_nicController, "NIC", TextInputType.text);
  }

  Widget _phoneInput() {
    return _buildTextField(
        _phoneController, "Phone Number", TextInputType.phone);
  }

  Widget _emailInput() {
    return _buildTextField(
        _emailController, "Email", TextInputType.emailAddress);
  }

  Widget _employeeNumberInput() {
    return _buildTextField(
        _employeeNumberController, "Employee Number", TextInputType.number);
  }

  Widget _positionInput() {
    return _buildTextField(_positionController, "Position", TextInputType.text);
  }

  Widget _addressInput() {
    return _buildTextField(_addressController, "Address", TextInputType.text);
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
