import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class AddingStudentInProgress extends HomeState {}

class StudentAddedSuccessfully extends HomeState {
  final String message;
  const StudentAddedSuccessfully(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class StudentsLoaded extends HomeState {
  final List<Map<String, dynamic>> students;
  const StudentsLoaded(this.students);

  @override
  List<Object?> get props => [students];
}
