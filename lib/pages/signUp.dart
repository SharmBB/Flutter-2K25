import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practise/pages/Employee/employee.dart' show EmployeeSignUp;
import 'package:practise/pages/Home/home.dart';
import 'package:practise/pages/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedRole;
  bool _showPassword = true;
  bool _isLoading = false;
  final List<String> _roles = ["HR", "Finance", "IT", "Engineering"];

  File? _image; // To store selected image
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imagePicker(), // Image picker widget
                _nameInput(),
                _phoneInput(),
                _nicInput(),
                _emailInput(),
                _passwordInput(),
                _confirmPasswordInput(),
                _roleDropdown(),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onClick,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                      backgroundColor: Colors.green,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.arrow_forward,
                            size: 35.0, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigate to Signin Password Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already Have an Account?",
                          style: TextStyle(color: Colors.blue)),
                      SizedBox(width: 8),
                      Text("Login",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Image Picker Widget
  Widget _imagePicker() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _showPickerDialog,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Upload Profile Image",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Show Image Picker Dialog
  Future<void> _showPickerDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick Image
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Form Fields
  Widget _nameInput() {
    return _buildTextField(_nameController, "Name", TextInputType.text);
  }

  Widget _phoneInput() {
    return _buildTextField(
      _phoneController,
      "Phone Number",
      TextInputType.phone,
      validator: (value) {
        if (value!.isEmpty || value.length != 10) {
          return "Enter a valid phone number";
        }
        return null;
      },
    );
  }

  Widget _nicInput() {
    return _buildTextField(
      _nicController,
      "NIC",
      TextInputType.text,
      validator: (value) {
        RegExp nicRegExp = RegExp(r'^\d{9}[Vv]$');
        if (!nicRegExp.hasMatch(value!)) {
          return "Enter a valid NIC (e.g., 990361070V)";
        }
        return null;
      },
    );
  }

  Widget _emailInput() {
    return _buildTextField(
      _emailController,
      "Email",
      TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email Required';
        } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _passwordInput() {
    return _buildPasswordField(_passwordController, "Password");
  }

  Widget _confirmPasswordInput() {
    return _buildPasswordField(
      _confirmPasswordController,
      "Confirm Password",
      validator: (value) {
        if (value != _passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }

  Widget _roleDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Role",
        border: OutlineInputBorder(),
      ),
      value: _selectedRole,
      items: _roles.map((String role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedRole = value;
        });
      },
      validator: (value) => value == null ? 'Select a role' : null,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      TextInputType keyboardType,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator:
            validator ?? (value) => value!.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: _showPassword,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
        ),
        validator:
            validator ?? (value) => value!.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  void _onClick() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      setState(() => _isLoading = false);
    }
  }
}
