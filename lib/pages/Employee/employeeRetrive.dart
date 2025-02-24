import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practise/pages/Employee/employeeUpdate.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final CollectionReference _employees =
      FirebaseFirestore.instance.collection('employees');
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee List")),
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
              stream: _employees.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No employees found"));
                }

                var filteredDocs = snapshot.data!.docs.where((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  String name = data['fullName']?.toLowerCase() ?? '';
                  return name.contains(searchQuery);
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

  void _viewEmployee(String id, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailPage(employeeId: id),
      ),
    );
  }

  void _updateEmployee(String id, Map<String, dynamic> data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Update feature not implemented yet")),
    );
  }

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
      appBar: AppBar(title: const Text("Employee Details")),
      body: FutureBuilder<DocumentSnapshot>(
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
                Text("Permanent Address: ${data['permanentAddress'] ?? 'N/A'}"),
                Text("Temporary Address: ${data['temporaryAddress'] ?? 'N/A'}"),
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
                Text("Bank Name: ${data['bankDetails']['bankName'] ?? 'N/A'}"),
                Text(
                    "Branch Name: ${data['bankDetails']['branchName'] ?? 'N/A'}"),

                // Add more fields as necessary
              ],
            ),
          );
        },
      ),
    );
  }
}
