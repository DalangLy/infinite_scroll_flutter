part of 'student_bloc.dart';

@immutable
abstract class StudentState {}

class StudentInitial extends StudentState {}

class LoadStudentInProgress extends StudentState {}

class LoadStudentSuccess extends StudentState {
  final List<Student> students;

  LoadStudentSuccess({required this.students});
}

class LoadStudentFailed extends StudentState {
  final String message;

  LoadStudentFailed({required this.message});
}