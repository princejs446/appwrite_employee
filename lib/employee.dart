import 'package:appwrite/models.dart';

class Note {
  final String name;
  final int age;
  final String location;
  

  Note({
    required this.name,
    required this.age,
    required this.location,
   
  });

  factory Note.fromDocument(Document doc) {
    return Note(
      name: doc.data['name'],
      age: doc.data['age'],
      location: doc.data['location'],
      
    );
  }
}