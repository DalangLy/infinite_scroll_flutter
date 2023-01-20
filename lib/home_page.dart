import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reload_test/bloc/student_bloc.dart';
import 'package:reload_test/my_scroll_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    BlocProvider.of<StudentBloc>(context).loadStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SafeArea(
        child: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if(state is LoadStudentSuccess){
              return MyScrollView(
                itemCount: state.students.length,
                builder: (context, index) {
                  return ListTile(
                    title: Text(state.students[index].name),
                  );
                },
                onLoadMore: () async {
                  // await Future.delayed(const Duration(seconds: 10));
                  final StudentBloc bloc = BlocProvider.of<StudentBloc>(context)..loadMoreStudents();
                  await bloc.stream.firstWhere((state) => state is LoadStudentSuccess || state is LoadStudentFailed);
                },
              );
            }
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}

