import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(),
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
}
