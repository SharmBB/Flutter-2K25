import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practise/pages/Home/home.dart';

class EmployeeSignUp extends StatefulWidget {
  const EmployeeSignUp({super.key});

  @override
  _EmployeeSignUpState createState() => _EmployeeSignUpState();
}

class _EmployeeSignUpState extends State<EmployeeSignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _callingNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyRelationshipController =
      TextEditingController();
  final TextEditingController _emergencyEmailController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _permanentAddressController =
      TextEditingController();
  final TextEditingController _temporaryAddressController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? _selectedTitle;
  String? _selectedMaritalStatus;
  String? _selectedGender;
  String? _selectedReligion;

  bool _isLoading = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final List<String> _titles = ["Mr", "Mrs", "Ms"];
  final List<String> _maritalStatuses = ["Single", "Married"];
  final List<String> _genders = ["Male", "Female"];
  final List<String> _religions = [
    "Buddhism",
    "Christianity",
    "Hinduism",
    "Islam"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imagePicker(),
                _dropdownField("Title", _titles, _selectedTitle,
                    (value) => setState(() => _selectedTitle = value)),
                _textField(_fullNameController, "Full Name", true),
                _textField(_callingNameController, "Calling Name", true),
                _textField(_nicController, "NIC Number", true),
                _dropdownField(
                    "Marital Status",
                    _maritalStatuses,
                    _selectedMaritalStatus,
                    (value) => setState(() => _selectedMaritalStatus = value)),
                _dropdownField("Religion", _religions, _selectedReligion,
                    (value) => setState(() => _selectedReligion = value)),
                _textField(
                    _permanentAddressController, "Permanent Address", true),
                _textField(
                    _temporaryAddressController, "Temporary Address", true),
                _dropdownField("Gender", _genders, _selectedGender,
                    (value) => setState(() => _selectedGender = value)),
                _datePicker(), // Updated Date Picker
                _textField(_emailController, "Email", true),
                _textField(_phoneController, "Phone Number", true,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                const Text("Emergency Contact Details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _textField(
                    _emergencyNameController, "Emergency Contact Name", true),
                _textField(
                    _emergencyRelationshipController, "Relationship", true),
                _textField(_emergencyEmailController, "Emergency Email", true),
                _textField(
                    _emergencyPhoneController, "Emergency Phone Number", true,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                const Text("Bank Account Details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _textField(_accountNumberController, "Account Number", true,
                    keyboardType: TextInputType.number),
                _textField(_bankNameController, "Bank Name", true),
                _textField(_branchNameController, "Branch Name", true),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSubmit,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(
      TextEditingController controller, String label, bool isRequired,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return "$label is required";
          }
          return null;
        },
      ),
    );
  }

  Widget _dropdownField(String label, List<String> items, String? value,
      void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: value,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _datePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: _dobController,
        decoration: InputDecoration(
          labelText: "Date of Birth",
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                setState(() {
                  _dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
                });
              }
            },
          ),
        ),
        readOnly: true, // Prevent manual input
        validator: (value) =>
            value == null || value.isEmpty ? "Date of Birth is required" : null,
      ),
    );
  }

  Widget _imagePicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: _image != null ? FileImage(_image!) : null,
          child: _image == null
              ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
              : null,
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        await FirebaseFirestore.instance.collection('employees').add({
          'title': _selectedTitle,
          'fullName': _fullNameController.text,
          'callingName': _callingNameController.text,
          'nic': _nicController.text,
          'maritalStatus': _selectedMaritalStatus,
          'religion': _selectedReligion,
          'permanentAddress': _permanentAddressController.text,
          'temporaryAddress': _temporaryAddressController.text,
          'gender': _selectedGender,
          'dob': _dobController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'emergencyContact': {
            'name': _emergencyNameController.text,
            'relationship': _emergencyRelationshipController.text,
            'email': _emergencyEmailController.text,
            'phone': _emergencyPhoneController.text,
          },
          'bankDetails': {
            'accountNumber': _accountNumberController.text,
            'bankName': _bankNameController.text,
            'branchName': _branchNameController.text,
          },
          'profileImage': "image",
        });

        // Show success toast
        Fluttertoast.showToast(
          msg: "Employee registered successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        // Clear all fields after successful submission
        _formKey.currentState?.reset();
        _callingNameController.clear();
        _fullNameController.clear();
        _nicController.clear();
        _emailController.clear();
        _phoneController.clear();
        _emergencyNameController.clear();
        _emergencyRelationshipController.clear();
        _emergencyEmailController.clear();
        _emergencyPhoneController.clear();
        _permanentAddressController.clear();
        _temporaryAddressController.clear();
        _accountNumberController.clear();
        _bankNameController.clear();
        _branchNameController.clear();
        _dobController.clear();
        _selectedTitle = null;
        _selectedMaritalStatus = null;
        _selectedGender = null;
        _selectedReligion = null;
        _image = null;

        setState(() {}); // Refresh UI
        // Navigate to home after successful addition
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage()), // Replace with your home screen widget
        );
      } catch (e) {
        // Show error toast
        Fluttertoast.showToast(
          msg: "Error: ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
