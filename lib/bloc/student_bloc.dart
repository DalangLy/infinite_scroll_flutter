import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reload_test/models/student.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {

  final List<Student> students = [];

  int _counter = 0;

  StudentBloc() : super(StudentInitial()) {
    on<StudentEvent>((event, emit) async {
      if(event is LoadStudents){
        emit(LoadStudentInProgress());
        await Future.delayed(const Duration(seconds: 3));
        final List<Student> newStudents = List.generate(20, (index) {
          return Student(id: index, name: "Name $index");
        });
        students.addAll(newStudents);
        emit(LoadStudentSuccess(students: students));
      }
      else if(event is LoadMoreStudents){
        print("load more");

        await Future.delayed(const Duration(seconds: 3));
        if(_counter <= 2){
          print("is smaller than two");
          _counter++;
          final List<Student> newStudents = List.generate(20, (index) {
            final int newIndex = students.length + 1;
            return Student(id: newIndex, name: "Name $newIndex");
          });
          students.addAll(newStudents);

        }
        emit(LoadStudentInProgress());
        emit(LoadStudentSuccess(students: students));
      }
    });
  }

  void loadStudents(){
    add(LoadStudents());
  }

  void loadMoreStudents(){
    add(LoadMoreStudents());
  }
}
