import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practise/Announcement/announcement.dart';

class HRAnnouncementsListScreen extends StatefulWidget {
  const HRAnnouncementsListScreen({super.key});

  @override
  _HRAnnouncementsListScreenState createState() =>
      _HRAnnouncementsListScreenState();
}

class _HRAnnouncementsListScreenState extends State<HRAnnouncementsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HRAnnouncementScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Announcements !!!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('announcement')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("No announcements available."));
                  }

                  var announcements = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      var announcement = announcements[index];
                      var data = announcement.data() as Map<String, dynamic>;
                      Timestamp timestamp = data['date'] as Timestamp;
                      DateTime dateTime = timestamp.toDate();
                      String formattedDate =
                          "${dateTime.day}/${dateTime.month}/${dateTime.year}, ${dateTime.hour}:${dateTime.minute}";

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            data['announcement'] ?? "No announcement",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "Posted on: $formattedDate",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _editAnnouncement(
                                      announcement.id, data['announcement']);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteAnnouncement(announcement.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to edit an announcement
  void _editAnnouncement(String id, String currentAnnouncement) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HRAnnouncementScreen(
          announcementId: id,
          currentAnnouncement: currentAnnouncement,
        ),
      ),
    );
  }

  // Function to delete an announcement
  void _deleteAnnouncement(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('announcement')
          .doc(id)
          .delete();
      Fluttertoast.showToast(
        msg: "Announcement deleted successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error deleting announcement: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
