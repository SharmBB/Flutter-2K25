import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

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
    'L3 Foundation 2024', 'L3 Foundation 2025', 'L4 Software Engineering',
    'L4 Mandatory', 'L4 Data Science', 'L4 Week day Project',
    'L4 Week End Project',
    'L5 Week day Project', 'L5 Week End Project', 'L5 Mandatory',
    'L5 Data Science',
    'L5 Software Engineering', 'Off Day' // Added "Off Day" option
  ];

  final Map<String, Color> staffColors = {
    'Sharmilan': Colors.blue,
    'Shenesha': Colors.green,
    'Rohini': Colors.orange,
    'Nishanthan': Colors.red,
  };

  final Map<String, Map<String, List<Map<String, String>>>> schedule = {
    'Sharmilan': {},
    'Shenesha': {},
    'Rohini': {},
    'Nishanthan': {}
  };

  String selectedDay = 'Monday';
  String selectedStaff = 'Sharmilan';
  String selectedModule = 'L3 Foundation 2024';
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
    if (selectedTimeRange == "Pick Time Range" && selectedModule != "Off Day") {
      return;
    }

    setState(() {
      schedule[selectedStaff]?[selectedDay] ??= [];
      if (selectedModule == "Off Day") {
        schedule[selectedStaff]?[selectedDay]
            ?.add({'time': 'Off Day', 'module': 'Lecturer Off Day'});
      } else {
        schedule[selectedStaff]?[selectedDay]
            ?.add({'time': selectedTimeRange, 'module': selectedModule});
      }
    });
  }

  // Function to generate PDF
  Future<void> generatePDF() async {
    final pdf = pw.Document();

    // Adding the title
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Staff Weekly Time Table',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              data: [
                ['Staff\\Day'] + days, // Table header
                ...staffMembers.map((staff) {
                  return [
                    staff,
                    ...days.map((day) {
                      final entries = schedule[staff]?[day];
                      if (entries == null || entries.isEmpty) {
                        return '-';
                      }
                      // Display the schedule
                      return entries.map((entry) {
                        if (entry['module'] == 'Lecturer Off Day') {
                          return 'Off Day';
                        }
                        return '${entry['time']} - ${entry['module']}';
                      }).join("\n");
                    })
                  ];
                }),
              ],
            ),
          ],
        );
      },
    ));

    // Printing the PDF
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
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
              Text('Assign Staff to Time Slots',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedStaff,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStaff = newValue!;
                  });
                },
                items: staffMembers.map((String value) {
                  return DropdownMenuItem(
                      value: value,
                      child: Text(value,
                          style: TextStyle(color: staffColors[value])));
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedDay,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDay = newValue!;
                  });
                },
                items: days
                    .map((String value) =>
                        DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
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
                value: selectedModule,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedModule = newValue!;
                  });
                },
                items: modules
                    .map((String value) =>
                        DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addScheduleEntry,
                child: Text('Assign Staff'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: generatePDF,
                child: Text('Generate Time Table PDF'),
              ),
              SizedBox(height: 20),
              Text('Weekly Time Table',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Table(
                border: TableBorder.all(color: Colors.black),
                children: [
                  TableRow(
                    children: [
                      TableCell(
                          child: Center(
                              child: Text('Staff\\Day',
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
                  for (var staff in staffMembers)
                    TableRow(
                      children: [
                        TableCell(
                            child: Center(
                                child: Text(staff,
                                    style:
                                        TextStyle(color: staffColors[staff])))),
                        for (var day in days)
                          TableCell(
                            child: Center(
                              child: Column(
                                children: schedule[staff]?[day]?.map((entry) {
                                      return entry['module'] ==
                                              'Lecturer Off Day'
                                          ? Text(entry['module']!,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.grey))
                                          : Column(children: [
                                              Text(entry['time']!),
                                              Text(entry['module']!)
                                            ]);
                                    }).toList() ??
                                    [Text('-')],
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
