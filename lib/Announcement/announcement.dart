import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practise/pages/Home/home.dart';

class HRAnnouncementScreen extends StatefulWidget {
  const HRAnnouncementScreen({super.key});

  @override
  _HRAnnouncementScreenState createState() => _HRAnnouncementScreenState();
}

class _HRAnnouncementScreenState extends State<HRAnnouncementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _announcementController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("New Announcement")),
        // appBar: AppBar(
        //   title: Text("HR Announcement"),
        //   backgroundColor: Colors.blueAccent,
        // ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Announcement:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _announcementInput(),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.green,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Post Announcement",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _announcementInput() {
    return TextFormField(
      controller: _announcementController,
      keyboardType: TextInputType.text,
      maxLines: 4,
      decoration: const InputDecoration(
        //labelText: "Email",
        hintText: "Type your announcement here ...",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Announcement Required';
        }
        return null;
      },
    );
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        await FirebaseFirestore.instance.collection('announcement').add({
          'announcement': _announcementController.text,
          'date': Timestamp.now(), // Stores the current date and time
        });

        // Show success toast
        Fluttertoast.showToast(
          msg: "Announcement Posted  successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        // Clear all fields after successful submission
        _formKey.currentState?.reset();
        _announcementController.clear();

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
