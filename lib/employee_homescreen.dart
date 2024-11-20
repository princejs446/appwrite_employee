
import 'package:appwrite_employee/appwriteservices.dart';
import 'package:appwrite_employee/employee.dart';
import 'package:flutter/material.dart';

class EmployeeHomescreen extends StatefulWidget {
  @override
  _EmployeeHomescreen createState() => _EmployeeHomescreen();
}

class _EmployeeHomescreen extends State<EmployeeHomescreen> {
  late AppwriteServices _appwriteService;
  late List<Note> _notes;

  final namecontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final locationcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteServices();
    _notes = [];
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final tasks = await _appwriteService.getNotes();
      setState(() {
        _notes = tasks.map((e) => Note.fromDocument(e)).toList();
      });
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> _addNote() async {
    final name = namecontroller.text;
    final age = agecontroller.text;
    final location = locationcontroller.text;

    if (name.isNotEmpty &&
        age.isNotEmpty &&
        location.isNotEmpty) {
      try {
       
        await _appwriteService.addNote(name, age, location);
        namecontroller.clear();
        agecontroller.clear();
        locationcontroller.clear();
       
        _loadNotes();
      } catch (e) {
        print('Error adding task: $e');
      }
    }
  }

  Future<void> _deleteNote(String taskId) async {
    try {
      await _appwriteService.deleteNote(taskId);
      _loadNotes();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Details')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: namecontroller,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: agecontroller,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: locationcontroller,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
           
            SizedBox(height: 20),
            ElevatedButton(onPressed: _addNote, child: Text('Add Notes')),
            SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                height: 250,
                width: 300,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),

                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final notes = _notes[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notes.name),
                            Text("${notes.age}"),
                            Text(notes.location),
                               Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(notes.name),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deleteNote
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}