import 'package:flutter/material.dart';

class TimeTableScreen extends StatefulWidget {
  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> staffMembers = [
    'Sharmilan',
    'Shenesha',
    'Rohini',
    'Nishanthan'
  ];

  final List<String> modules = [
    'Mathematics',
    'Physics',
    'Computer Science',
    'Artificial Intelligence'
  ];

  final Map<String, Color> staffColors = {
    'Sharmilan': Colors.blue,
    'Shenesha': Colors.green,
    'Rohini': Colors.orange,
    'Nishanthan': Colors.red,
  };

  // Stores assignments { "Monday": { "9:00 AM - 10:00 AM": {"staff": "Sharmilan", "module": "Mathematics"} } }
  final Map<String, Map<String, Map<String, String>>> schedule = {
    'Monday': {},
    'Tuesday': {},
    'Wednesday': {},
    'Thursday': {},
    'Friday': {},
    'Saturday': {},
    'Sunday': {},
  };

  String selectedDay = 'Monday';
  String selectedStaff = 'Sharmilan';
  String selectedModule = 'Mathematics';
  String selectedTimeRange = "Pick Time Range";
  TextEditingController timeController = TextEditingController();

  Future<void> pickTimeRange() async {
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );

    if (startTime != null) {
      TimeOfDay? endTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: startTime.hour + 1, minute: startTime.minute),
      );

      if (endTime != null) {
        setState(() {
          selectedTimeRange =
              "${startTime.format(context)} - ${endTime.format(context)}";
          timeController.text = selectedTimeRange;
        });
      }
    }
  }

  void addScheduleEntry() {
    if (selectedTimeRange == "Pick Time Range") return;

    setState(() {
      schedule[selectedDay]?[selectedTimeRange] = {
        'staff': selectedStaff,
        'module': selectedModule
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Staff Time Table')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assign Staff to Time Slots',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedDay,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDay = newValue!;
                  });
                },
                items: days.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Select Time Range",
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                onTap: pickTimeRange,
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedStaff,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStaff = newValue!;
                  });
                },
                items:
                    staffMembers.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: TextStyle(color: staffColors[value])),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedModule,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedModule = newValue!;
                  });
                },
                items: modules.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addScheduleEntry,
                child: Text('Assign Staff'),
              ),
              SizedBox(height: 20),
              Text(
                'Weekly Time Table',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Table(
                border: TableBorder.all(color: Colors.black),
                children: [
                  TableRow(
                    children: [
                      TableCell(
                          child: Center(
                              child: Text('Time\\Day',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      for (var day in days)
                        TableCell(
                            child: Center(
                                child: Text(day,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)))),
                    ],
                  ),
                  for (var day in days)
                    for (var timeRange in schedule[day]!.keys)
                      TableRow(
                        children: [
                          TableCell(child: Center(child: Text(timeRange))),
                          for (var d in days)
                            TableCell(
                              child: Container(
                                color: schedule[d]?[timeRange] != null
                                    ? staffColors[
                                            schedule[d]![timeRange]!['staff']]!
                                        .withOpacity(0.8)
                                    : Colors.white,
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: schedule[d]?[timeRange] != null
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              schedule[d]![timeRange]![
                                                  'staff']!,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              schedule[d]![timeRange]![
                                                  'module']!,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          'No Lecture',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                        ],
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
