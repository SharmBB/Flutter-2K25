import 'package:flutter/material.dart';

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  _ApplyLeavePageState createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _employeeNumberController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _selectedLeaveType;
  String? _selectedDepartment;
  DateTime? _fromDate;
  DateTime? _toDate;

  void _pickDate(Function(DateTime) onDatePicked) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    setState(() {
      onDatePicked(pickedDate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leave Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Employee Name",
                  hintText: "Enter your name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                decoration: const InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(),
                ),
                items: ["HR", "Finance", "IT", "Engineering", "Marketing"]
                    .map((dept) => DropdownMenuItem(
                          value: dept,
                          child: Text(dept),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _employeeNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Employee Number",
                  hintText: "Enter your employee number",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text("Reason for Leave",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: [
                  for (var leaveType in [
                    "Annual Leave",
                    "Medical Leave",
                    "WFH",
                    "Casual Leave",
                    "Short Leave",
                    "Half Day",
                    "Lieu Leave"
                  ])
                    RadioListTile(
                      title: Text(leaveType),
                      value: leaveType,
                      groupValue: _selectedLeaveType,
                      onChanged: (value) {
                        setState(() {
                          _selectedLeaveType = value;
                          // Clear dates if new leave type is selected
                          if (_selectedLeaveType != "WFH" &&
                              _selectedLeaveType != "Short Leave" &&
                              _selectedLeaveType != "Lieu Leave") {
                            _fromDate = null;
                            _toDate = null;
                          }
                        });
                      },
                    ),
                ],
              ),
              SizedBox(height: 20),
              if (_selectedLeaveType == "WFH" ||
                  _selectedLeaveType == "Short Leave" ||
                  _selectedLeaveType == "Lieu Leave")
                Column(
                  children: [
                    Text("Select Date",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () => _pickDate((date) => _fromDate = date),
                      child: Text(_fromDate == null
                          ? "Select Date"
                          : _fromDate!.toLocal().toString().split(' ')[0]),
                    ),
                  ],
                )
              else ...[
                Text("From Date",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => _pickDate((date) => _fromDate = date),
                  child: Text(_fromDate == null
                      ? "Select From Date"
                      : _fromDate!.toLocal().toString().split(' ')[0]),
                ),
                SizedBox(height: 10),
                Text("To Date", style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => _pickDate((date) => _toDate = date),
                  child: Text(_toDate == null
                      ? "Select To Date"
                      : _toDate!.toLocal().toString().split(' ')[0]),
                ),
              ],
              SizedBox(height: 20),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Comments / Notes",
                  hintText: "Enter any additional notes",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Submit logic
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
