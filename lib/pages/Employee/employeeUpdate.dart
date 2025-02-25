import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practise/pages/Home/home.dart';

class UpdateEmployeeDetails extends StatefulWidget {
  final String employeeId;
  const UpdateEmployeeDetails({super.key, required this.employeeId});

  @override
  _UpdateEmployeeDetailsState createState() => _UpdateEmployeeDetailsState();
}

class _UpdateEmployeeDetailsState extends State<UpdateEmployeeDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _callingNameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _permanentAddressController =
      TextEditingController();
  final TextEditingController _temporaryAddressController =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _employeeNumberController =
      TextEditingController();
  final TextEditingController _dateOfJoinController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _employeeStatusController =
      TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _annualLeaveController = TextEditingController();
  final TextEditingController _casualLeaveController = TextEditingController();
  final TextEditingController _medicalLeaveController = TextEditingController();

  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyRelationshipController =
      TextEditingController();
  final TextEditingController _emergencyEmailController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();

  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();

  String? _selectedTitle;
  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedCompany;
  String? _selectedLocation;
  String? _selectedDesignation;
  String? _selectedEmployeeStatus;
  String? _selectedStatus;

  String? _selectedReligion;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final List<String> _titles = ["Mr", "Mrs", "Ms"];
  final List<String> _employeeStatuses = ["Active", "InActive"];
  final List<String> _maritalStatuses = ["Single", "Married"];
  final List<String> _genders = ["Male", "Female"];
  final List<String> _religions = [
    "Buddhism",
    "Christianity",
    "Hinduism",
    "Islam"
  ];

  final List<String> _companies = ["AIA", "BIET"];
  final List<String> _locations = ["Kandy", "Jaffna"];
  final List<String> _designations = ["HR", "IT", "Engineering"];

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData();
  }

  Future<void> _fetchEmployeeData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('employees')
        .doc(widget.employeeId)
        .get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic>? leaveDetails =
          data['leaveDetails'] as Map<String, dynamic>?;
      setState(() {
        _selectedTitle = data['title'] ?? '';
        _fullNameController.text = data['fullName'] ?? '';
        _callingNameController.text = data['callingName'] ?? '';
        _nicController.text = data['nic'] ?? '';
        _dobController.text = data['dob'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _emergencyNameController.text = data['emergencyContact']['name'] ?? '';
        _emergencyRelationshipController.text =
            data['emergencyContact']['relationship'] ?? '';
        _emergencyPhoneController.text =
            data['emergencyContact']['phone'] ?? '';
        _emergencyEmailController.text =
            data['emergencyContact']['email'] ?? '';

        _accountNumberController.text =
            data['bankDetails']['accountNumber'] ?? '';
        _bankNameController.text = data['bankDetails']['bankName'] ?? '';
        _branchNameController.text = data['bankDetails']['branchName'] ?? '';

        _permanentAddressController.text = data['permanentAddress'] ?? '';
        _temporaryAddressController.text = data['temporaryAddress'] ?? '';
        _selectedGender = data['gender'] ?? '';
        _employeeNumberController.text = data['employeeNumber'] ?? '';
        _dateOfJoinController.text = data['dateOFJoin'] ?? '';
        _companyController.text = data['Company'] ?? '';
        _locationController.text = data['Location'] ?? '';
        _employeeStatusController.text = data['employeeStatus'] ?? '';
        _designationController.text = data['Desigination'] ?? '';
        _annualLeaveController.text = leaveDetails?['annualLeave'] ?? '';
        _casualLeaveController.text = leaveDetails?['casualLeave'] ?? '';
        _medicalLeaveController.text = leaveDetails?['medicalLeave'] ?? '';
        _employeeNumberController.text = data['employeeNumber'] ?? '';
        _dateOfJoinController.text = data['dateOfJoin'] ?? '';
        _selectedCompany = data['company'] ?? '';
        _selectedLocation = data['location'] ?? '';
        _selectedDesignation = data['designation'] ?? '';
        _selectedEmployeeStatus = data['employeeStatus'] ?? '';
        _annualLeaveController.text = data['leaveDetails']['annualLeave'] ?? '';
        _casualLeaveController.text = data['leaveDetails']['casualLeave'] ?? '';
        _medicalLeaveController.text =
            data['leaveDetails']['medicalLeave'] ?? '';
      });
    }
  }

  Future<void> _updateEmployeeDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(widget.employeeId)
            .update({
          'title': _selectedTitle,
          'fullName': _fullNameController.text,
          'callingName': _callingNameController.text,
          'nic': _nicController.text,
          'dob': _dobController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'permanentAddress': _permanentAddressController.text,
          'temporaryAddress': _temporaryAddressController.text,
          'gender': _selectedGender,
          'employeeNumber': _employeeNumberController.text,
          'dateOFJoin': _dateOfJoinController.text,
          'Company': _selectedCompany,
          'Location': _selectedLocation,
          'employeeStatus': _selectedStatus,
          'Desigination': _designationController.text,
          'leaveDetails': {
            'annualLeave': _annualLeaveController.text,
            'casualLeave': _casualLeaveController.text,
            'medicalLeave': _medicalLeaveController.text,
          },
        });
        Fluttertoast.showToast(msg: "Employee details updated successfully");
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Employee Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                const SizedBox(height: 20),
                _textField(
                  _employeeNumberController,
                  "Employee Number",
                  true,
                  keyboardType: TextInputType.number,
                ),
                _datePickerJoin(), // Updated Date Picker
                _companyDropdown(),
                _locationDropdown(),
                _designationDropdown(),
                _employeeStatusDropdown(),
                const SizedBox(height: 20),
                const Text("Leave Details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _textField(_annualLeaveController, "Annual Leave", true,
                    keyboardType: TextInputType.number),
                _textField(_casualLeaveController, "Casual Leave", true,
                    keyboardType: TextInputType.number),
                _textField(_medicalLeaveController, "Medical Leave", true,
                    keyboardType: TextInputType.number),

                // _textField(_fullNameController, "Full Name"),
                // _textField(_callingNameController, "Calling Name"),
                // _textField(_nicController, "NIC Number"),
                // _textField(_dobController, "Date of Birth"),
                // _textField(_emailController, "Email"),
                // _textField(_phoneController, "Phone Number"),
                // _textField(_permanentAddressController, "Permanent Address"),
                // _textField(_temporaryAddressController, "Temporary Address"),
                // _textField(_employeeNumberController, "Employee Number"),
                // _textField(_dateOfJoinController, "Date of Joining"),
                // _textField(_companyController, "Company"),
                // _textField(_locationController, "Location"),
                // _textField(_employeeStatusController, "Employee Status"),
                // _textField(_designationController, "Designation"),
                // _textField(_annualLeaveController, "Annual Leave"),
                // _textField(_casualLeaveController, "Casual Leave"),
                // _textField(_medicalLeaveController, "Medical Leave"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateEmployeeDetails,
                  child: const Text("Update"),
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

  Widget _employeeStatusDropdown() {
    List<String> _statuses = ["Active", "Inactive"];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Employee Status",
          border: const OutlineInputBorder(),
        ),
        value: _statuses.contains(_selectedStatus) ? _selectedStatus : null,
        items: _statuses
            .map((status) =>
                DropdownMenuItem(value: status, child: Text(status)))
            .toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedStatus = newValue;
          });
        },
        validator: (value) => value == null ? "Please select a status" : null,
      ),
    );
  }

  Widget _designationDropdown() {
    List<String> _designations = ["IT", "Engineering", "Staff"];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Designation",
          border: const OutlineInputBorder(),
        ),
        value: _designations.contains(_selectedDesignation)
            ? _selectedDesignation
            : null,
        items: _designations
            .map((designation) =>
                DropdownMenuItem(value: designation, child: Text(designation)))
            .toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedDesignation = newValue;
          });
        },
        validator: (value) =>
            value == null ? "Please select a designation" : null,
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

  Widget _companyDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Company",
          border: const OutlineInputBorder(),
        ),
        value: _companies.contains(_selectedCompany) ? _selectedCompany : null,
        items: _companies
            .map((company) =>
                DropdownMenuItem(value: company, child: Text(company)))
            .toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedCompany = newValue;
          });
        },
        validator: (value) => value == null ? "Please select a company" : null,
      ),
    );
  }

  Widget _locationDropdown() {
    List<String> _locations = ["Kandy", "Colombo"];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Location",
          border: const OutlineInputBorder(),
        ),
        value:
            _locations.contains(_selectedLocation) ? _selectedLocation : null,
        items: _locations
            .map((location) =>
                DropdownMenuItem(value: location, child: Text(location)))
            .toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedLocation = newValue;
          });
        },
        validator: (value) => value == null ? "Please select a location" : null,
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

  Widget _datePickerJoin() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: _dateOfJoinController,
        decoration: InputDecoration(
          labelText: "Date of Join",
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
                  _dateOfJoinController.text =
                      "${pickedDate.toLocal()}".split(' ')[0];
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
}
