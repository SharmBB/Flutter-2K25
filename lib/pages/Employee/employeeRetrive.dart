import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:practise/pages/Employee/employeeUpdate.dart';
import 'package:printing/printing.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final CollectionReference _employees =
      FirebaseFirestore.instance.collection('employees');
  String searchQuery = "";

  String statusFilter = "all"; // Filter by all, active, or inactive

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
              // Add your print functionality here
              print("Print button clicked");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter employee name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _employees
                  .where('employeeStatus',
                      isEqualTo: statusFilter == "all" ? null : statusFilter)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No employees found"));
                }

                // Filter the documents based on the search query
                var filteredDocs = snapshot.data!.docs.where((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  String name = data['employeeNumber']?.toLowerCase() ?? '';

                  // You can also ensure that the employee status field matches the exact value
                  String status = data['employeeStatus']?.toLowerCase() ?? '';
                  return name.contains(searchQuery.toLowerCase()) &&
                      (statusFilter == "all" ||
                          status == statusFilter.toLowerCase());
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(
                      child: Text("No matching employees found"));
                }
                return ListView(
                  children: filteredDocs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(data['fullName'] ?? 'Unknown',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Phone: ${data['phone'] ?? 'N/A'}"),
                                  Text("Email: ${data['email'] ?? 'N/A'}"),
                                  Text("NIC: ${data['nic'] ?? 'N/A'}"),
                                  Text(
                                      "Employee Number: ${data['employeeNumber'] ?? 'N/A'}"),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility,
                                      color: Colors.blue),
                                  onPressed: () => _viewEmployee(doc.id, data),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.green),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateEmployeeDetails(
                                                employeeId: doc.id),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteEmployee(doc.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Employees'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All'),
                leading: Radio<String>(
                  value: "all",
                  groupValue: statusFilter,
                  onChanged: (value) {
                    setState(() {
                      statusFilter = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Active'),
                leading: Radio<String>(
                  value: "Active",
                  groupValue: statusFilter,
                  onChanged: (value) {
                    setState(() {
                      statusFilter = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Inactive'),
                leading: Radio<String>(
                  value: "InActive",
                  groupValue: statusFilter,
                  onChanged: (value) {
                    setState(() {
                      statusFilter = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _viewEmployee(String id, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailPage(employeeId: id),
      ),
    );
  }

//delete the particular Employee
  void _deleteEmployee(String id) async {
    await _employees.doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Employee deleted successfully")),
    );
  }
}

class EmployeeDetailPage extends StatelessWidget {
  final String employeeId;

  const EmployeeDetailPage({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final CollectionReference employees =
        FirebaseFirestore.instance.collection('employees');

    return Scaffold(
        appBar: AppBar(
          title: const Text("Employee Details"),
          actions: [
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: () async {
                await _printPdf(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () async {
                await _generateAndSharePdf(context);
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: FutureBuilder<DocumentSnapshot>(
              future: employees.doc(employeeId).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("Employee not found"));
                }

                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                // Safe access to nkDetails
                Map<String, dynamic>? nkDetails =
                    data['nkDetails'] as Map<String, dynamic>?;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Full Name: ${data['fullName'] ?? 'N/A'}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("Phone: ${data['phone'] ?? 'N/A'}"),
                      Text("Email: ${data['email'] ?? 'N/A'}"),
                      Text("NIC: ${data['nic'] ?? 'N/A'}"),
                      Text("Calling Name: ${data['callingName'] ?? 'N/A'}"),
                      Text("DOB: ${data['dob'] ?? 'N/A'}"),
                      Text("Religion: ${data['religion'] ?? 'N/A'}"),
                      Text("Marital Status: ${data['maritalStatus'] ?? 'N/A'}"),
                      Text("Gender: ${data['gender'] ?? 'N/A'}"),
                      Text(
                          "Permanent Address: ${data['permanentAddress'] ?? 'N/A'}"),
                      Text(
                          "Temporary Address: ${data['temporaryAddress'] ?? 'N/A'}"),
                      SizedBox(height: 20),
                      Text("Emergency Contact Details",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                          "Emergency Contact Name: ${data['emergencyContact']?['name'] ?? 'N/A'}"),
                      Text(
                          "Emergency Contact Phone: ${data['emergencyContact']?['phone'] ?? 'N/A'}"),
                      Text(
                          "Emergency Contact Relationship: ${data['emergencyContact']?['relationship'] ?? 'N/A'}"),
                      Text(
                          "Emergency Contact Email: ${data['emergencyContact']?['email'] ?? 'N/A'}"),
                      SizedBox(height: 20),
                      Text("Bank Account Detils",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                          "Account Number: ${data['bankDetails']['accountNumber'] ?? 'N/A'}"),
                      Text(
                          "Bank Name: ${data['bankDetails']['bankName'] ?? 'N/A'}"),
                      Text(
                          "Branch Name: ${data['bankDetails']['branchName'] ?? 'N/A'}"),
                      SizedBox(height: 20),
                      Text(
                          "Employee Number : ${data['employeeNumber'] ?? 'N/A'}"),
                      Text("Date of Join : ${data['dateOFJoin'] ?? 'N/A'}"),
                      Text("Company : ${data['Company'] ?? 'N/A'}"),
                      Text("Location : ${data['Location'] ?? 'N/A'}"),
                      Text("Desigination : ${data['Desigination'] ?? 'N/A'}"),
                      Text(
                          "Employement Status : ${data['employeeStatus'] ?? 'N/A'}"),
                      SizedBox(height: 20),
                      Text("Bank Account Details",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                          "Salary Account Number : ${data['bankDetails']['accountNumber'] ?? 'N/A'}"),

                      Text(
                          "Bank Name : ${data['bankDetails']['bankName'] ?? 'N/A'}"),
                      Text(
                          "Branch Name : ${data['bankDetails']['branchName'] ?? 'N/A'}"),
                      SizedBox(height: 20),
                      Text("Leave  Details",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                          "Annual Leave : ${data['leaveDetails']['annualLeave'] ?? 'N/A'}"),
                      Text(
                          "Casual Leave : ${data['leaveDetails']['casualLeave'] ?? 'N/A'}"),
                      Text(
                          "Medical Leave : ${data['leaveDetails']['medicalLeave'] ?? 'N/A'}"),
                      // Add more fields as necessary
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }

  Future<void> _generateAndSharePdf(BuildContext context) async {
    final doc = await _createPdf();
    await Printing.sharePdf(bytes: await doc.save(), filename: 'employee.pdf');
  }

  Future<void> _printPdf(BuildContext context) async {
    final doc = await _createPdf();
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  Future<pw.Document> _createPdf() async {
    final doc = pw.Document();

    final employeeData = await FirebaseFirestore.instance
        .collection('employees')
        .doc(employeeId)
        .get();

    if (!employeeData.exists) {
      return doc;
    }

    Map<String, dynamic> data = employeeData.data() as Map<String, dynamic>;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Employee Details",
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                _buildPdfText("Full Name", data['fullName']),
                _buildPdfText("Employee Number", data['employeeNumber']),
                _buildPdfText("Phone", data['phone']),
                _buildPdfText("Email", data['email']),
                _buildPdfText("NIC", data['nic']),
                _buildPdfText("Calling Name", data['callingName']),
                _buildPdfText("DOB", data['dob']),
                _buildPdfText("Religion", data['religion']),
                _buildPdfText("Marital Status", data['maritalStatus']),
                _buildPdfText("Gender", data['gender']),
                _buildPdfText("Permanent Address", data['permanentAddress']),
                _buildPdfText("Temporary Address", data['temporaryAddress']),
                _buildPdfText("Date of Join", data['dateOFJoin']),
                _buildPdfText("Company", data['Company']),
                _buildPdfText("Location", data['Location']),
                _buildPdfText("Desigination", data['Desigination']),
                _buildPdfText("Employement Status", data['employeeStatus']),
                pw.SizedBox(height: 15),
                pw.Text("Emergency Contact Details",
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                _buildPdfText("Emergency Contact Name",
                    data['emergencyContact']?['name']),
                _buildPdfText("Emergency Contact Phone:",
                    data['emergencyContact']?['phone']),
                _buildPdfText("Emergency Contact Relationship:",
                    data['emergencyContact']?['relationship']),
                _buildPdfText("Emergency Contact Email: ",
                    data['emergencyContact']?['email']),
                pw.SizedBox(height: 10),
                pw.Text("Bank Account Details",
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                _buildPdfText(
                    "Account Number", data['bankDetails']['accountNumber']),
                _buildPdfText("Bank Name", data['bankDetails']['bankName']),
                _buildPdfText("Branch Name", data['bankDetails']['branchName']),
                pw.SizedBox(height: 10),
                pw.SizedBox(height: 10),
                pw.SizedBox(height: 10),
                pw.Text("Leave Details",
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                _buildPdfText(
                    "Annual Leave", data['leaveDetails']['annualLeave']),
                _buildPdfText(
                    "Casual Leave", data['leaveDetails']['casualLeave']),
                _buildPdfText(
                    "Medical Leave", data['leaveDetails']['medicalLeave']),
              ],
            ),
          );
        },
      ),
    );

    return doc;
  }

  pw.Widget _buildPdfText(String label, dynamic value) {
    return pw.Text("$label: ${value ?? 'N/A'}",
        style: pw.TextStyle(fontSize: 12));
  }
}
