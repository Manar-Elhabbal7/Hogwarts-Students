import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _firestore;
  StreamSubscription<QuerySnapshot>? _studentsSubscription;

  HomeCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(HomeInitial());

  /// Listens to real-time changes in the 'students' Firestore collection.
  void watchStudents() {
    emit(HomeLoading());
    _studentsSubscription?.cancel();
    _studentsSubscription = _firestore
        .collection('students')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final students = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'] ?? '',
            'age': _parseInt(data['age']),
            'house': data['house'] ?? 'Unknown',
          };
        }).toList();
        emit(StudentsLoaded(students));
      },
      onError: (error) {
        emit(HomeError('Failed to load students: ${error.toString()}'));
      },
    );
  }

  /// Adds a new student record to Cloud Firestore.
  Future<void> addStudent({
    required String name,
    required int age,
    required String house,
  }) async {
    emit(AddingStudentInProgress());
    try {
      await _firestore.collection('students').add({
        'name': name,
        'age': age,
        'house': house,
        'createdAt': FieldValue.serverTimestamp(),
      });
      emit(const StudentAddedSuccessfully('Student added to Hogwarts successfully!'));
      
      // Resume watching the list of students
      watchStudents();
    } catch (e) {
      emit(HomeError('Failed to enroll student: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _studentsSubscription?.cancel();
    return super.close();
  }

  /// Helper to safely parse any Firestore numeric representation (including Web Int64) to a Dart int.
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
