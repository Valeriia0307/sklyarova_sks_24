import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyarova_sks_24_1/models/student.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final url = Uri.https(
    'students-62ac6-default-rtdb.europe-west1.firebasedatabase.app',
    'students.json');

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier(super.state);
  bool isLoading = false;

  void addStudent(Student student) async {
    isLoading = true;
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode({
          'id': student.id,
          'firstName': student.firstName,
          'lastName': student.lastName,
          'departmentId': student.departmentId,
          'grade': student.grade,
          'gender': student.gender.name,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final firebaseKey = responseData['name'];

        state = [
          ...state,
          student.copyWith(firebaseKey: firebaseKey),
        ];
      } else {
        throw Exception();
      }
    } catch (e) {
      print('Error adding student: $e');
    } finally {
      isLoading = false;
    }
  }

  void editStudent(Student student, int index) async {
    isLoading = true;
    try {
      final newState = [...state];
      newState[index] = newState[index].copyWith(
        firstName: student.firstName,
        lastName: student.lastName,
        departmentId: student.departmentId,
        gender: student.gender,
        grade: student.grade,
      );
      state = newState;

      final urlItem = Uri.https(
        'students-62ac6-default-rtdb.europe-west1.firebasedatabase.app',
        'students/${student.firebaseKey}.json',
      );

      final response = await http.patch(
        urlItem,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'firstName': student.firstName,
          'lastName': student.lastName,
          'departmentId': student.departmentId,
          'gender': student.gender.name,
          'grade': student.grade,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception();
      }
    } catch (e) {
      print('Error updating student info: $e');
    } finally {
      isLoading = false;
      state = [...state];
    }
  }

  void insertStudentLocal(Student student, int index) {
    state = [
      ...state.sublist(0, index),
      student,
      ...state.sublist(index),
    ];
  }

  void removeStudentLocal(Student student) {
    state = state.where((m) => m.id != student.id).toList();
  }

  void removeStudent(Student student) async {
    final url_item = Uri.https(
        'students-62ac6-default-rtdb.europe-west1.firebasedatabase.app',
        'students/${student.firebaseKey}.json');
    isLoading = true;
    try {
      final previousState = state;
      state = state.where((m) => m.id != student.id).toList();
      final response = await http.delete(url_item);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        state = previousState;
        throw Exception('Failed to delete student from database');
      }
    } catch (e) {
      print('Error deleting a student: $e');
    } finally {
      isLoading = false;
      state = [...state];
    }
  }

  void fetchStudents() async {
    isLoading = true;
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = response.body;
        final parsed = json.decode(body);

        if (parsed == null || parsed == 'null') {
          print('No data found in the database.');
          state = [];
          return;
        }

        if (parsed is Map<String, dynamic>) {
          final List<Student> students = [];
          for (var entry in parsed.entries) {
            students.add(
              Student(
                id: entry.value['id'] ?? '',
                firebaseKey: entry.key,
                firstName: entry.value['firstName'] ?? '',
                lastName: entry.value['lastName'] ?? '',
                departmentId: entry.value['departmentId'] ?? '',
                grade: entry.value['grade'] ?? 0,
                gender: Gender.values.firstWhere(
                  (gen) => gen.name == entry.value['gender'],
                  orElse: () => Gender.female,
                ),
              ),
            );
          }
          state = students;
        } else {
          print('Unexpected data format received.');
          state = [];
        }
      } else {
        state = [];
        throw Exception();
      }
    } catch (e) {
      print('Error fetching students: $e');
      state = [];
    } finally {
      isLoading = false;
    }
  }
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>(
  (ref) {
    return StudentsNotifier([]);
  },
);
