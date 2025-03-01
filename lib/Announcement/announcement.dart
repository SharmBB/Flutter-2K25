import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HRAnnouncementScreen extends StatefulWidget {
  final String? announcementId;
  final String? currentAnnouncement;

  const HRAnnouncementScreen({
    super.key,
    this.announcementId,
    this.currentAnnouncement,
  });

  @override
  _HRAnnouncementScreenState createState() => _HRAnnouncementScreenState();
}

class _HRAnnouncementScreenState extends State<HRAnnouncementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _announcementController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentAnnouncement != null) {
      _announcementController.text = widget.currentAnnouncement!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.announcementId == null
            ? "New Announcement"
            : "Edit Announcement"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Announcement:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _announcementInput(),
              const SizedBox(height: 20),
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
                      : Text(
                          widget.announcementId == null
                              ? "Post Announcement"
                              : "Update Announcement",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _announcementInput() {
    return TextFormField(
      controller: _announcementController,
      keyboardType: TextInputType.text,
      maxLines: 4,
      decoration: const InputDecoration(
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
        if (widget.announcementId == null) {
          // Add new announcement
          await FirebaseFirestore.instance.collection('announcement').add({
            'announcement': _announcementController.text,
            'date': Timestamp.now(),
          });
          Fluttertoast.showToast(
            msg: "Announcement posted successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          // Update existing announcement
          await FirebaseFirestore.instance
              .collection('announcement')
              .doc(widget.announcementId)
              .update({
            'announcement': _announcementController.text,
            'date': Timestamp.now(),
          });
          Fluttertoast.showToast(
            msg: "Announcement updated successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }

        // Clear fields and navigate back
        _formKey.currentState?.reset();
        _announcementController.clear();
        Navigator.pop(context);
      } catch (e) {
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
