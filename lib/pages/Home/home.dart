import 'package:flutter/material.dart';
import 'package:practise/Announcement/announcement.dart';
import 'package:practise/Announcement/announcementRetrive.dart';
import 'package:practise/pages/Employee/employee.dart';
import 'package:practise/pages/Employee/employeeRetrive.dart';

import '../leave Request/leave_request.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50), // Spacing from top
          Text(
            " HR DASHBOARD",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildGridItem(context, "Staff ", "assets/images/1.jpeg",
                      EmployeeSignUp()),
                  _buildGridItem(context, "Staff Details",
                      "assets/images/student.jpg", EmployeeListPage()),
                  _buildGridItem(context, "Announcment",
                      "assets/images/ann.jpg", HRAnnouncementScreen()),
                  _buildGridItem(context, "Leave", "assets/images/leave.jpg",
                      ApplyLeavePage()),
                  _buildGridItem(context, "Annocment\nDetils",
                      "assets/images/ann.jpg", HRAnnouncementsListScreen()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, String title, String imagePath, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath,
                  height: 80, width: 80, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages
class StaffPage extends StatelessWidget {
  const StaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Staff Page")));
  }
}

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Students Page")));
  }
}

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Details Added Soon !!!")));
  }
}

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Other Page")));
  }
}
