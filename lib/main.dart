import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/bloc/pet_adoption_bloc.dart';
import 'package:pet_adoption_app/home_page/home_page_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => PetAdoptionBloc()..add(PetAdoptionFetchData()),
        child: HomePage(),
      ),
    );
  }
}
