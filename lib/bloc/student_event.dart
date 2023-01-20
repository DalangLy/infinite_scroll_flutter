part of 'student_bloc.dart';

@immutable
abstract class StudentEvent {}

class LoadStudents extends StudentEvent {}

class LoadMoreStudents extends StudentEvent {}
