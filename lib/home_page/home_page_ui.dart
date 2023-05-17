import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/bloc/pet_adoption_bloc.dart';
import 'package:pet_adoption_app/details_page/details_page_ui.dart';
import 'package:pet_adoption_app/history_page/history_page_ui.dart';
import 'package:pet_adoption_app/home_page/pet_data_card.dart';
import 'package:pet_adoption_app/utils/colors.dart';
import 'package:pet_adoption_app/utils/pet_details_data.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listScrollController.addListener(() {
      // ignore: unrelated_type_equality_checks
      if (listScrollController.offset >=
              listScrollController.position.maxScrollExtent &&
          !listScrollController.position.outOfRange &&
          BlocProvider.of<PetAdoptionBloc>(context).state
              is PetAdoptionFetched) {
        BlocProvider.of<PetAdoptionBloc>(context).add(PetAdoptionAddPetData());
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Adoption App"),
        backgroundColor: purple,
        actions: [
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context1) => BlocProvider.value(
                            value: BlocProvider.of<PetAdoptionBloc>(context),
                            child: HistoryPage(),
                          )));
              BlocProvider.of<PetAdoptionBloc>(context)
                  .add(PetAdoptionFetchData());
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.history),
            ),
          )
        ],
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
                labelText: "Search",
                labelStyle: TextStyle(color: Colors.black),
                suffixIconColor: Colors.black,
                focusColor: purple,
                suffixIcon: Icon(Icons.search),
                border: InputBorder.none),
            onChanged: (value) {
              if (value == "") {
                BlocProvider.of<PetAdoptionBloc>(context)
                    .add(PetAdoptionFetchData());
              } else {
                BlocProvider.of<PetAdoptionBloc>(context)
                    .add(PetAdoptionFetchDataBySearch(value));
              }
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<PetAdoptionBloc, PetAdoptionState>(
            builder: (context, state) {
              if (state is PetAdoptionFetched) {
                return ListView.builder(
                    itemCount: state.petDetails.length,
                    controller: listScrollController,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          PetDataCard(
                              petDetail: state.petDetails[index],
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context1) => DetailsPage(
                                            petData: state.petDetails[index],
                                            bloc: BlocProvider.of<
                                                PetAdoptionBloc>(context))));
                              }),
                          if (index == state.petDetails.length - 1 &&
                              state.petDetails.length !=
                                  PetDetailsData.petNames.length)
                            const CircularProgressIndicator()
                        ],
                      );
                    });
              } else {
                if (state is PetAdoptionFetchedBySearch) {
                  return ListView.builder(
                      itemCount: state.petDetails.length,
                      itemBuilder: (context, index) {
                        return PetDataCard(
                            petDetail: state.petDetails[index],
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context1) => DetailsPage(
                                          petData: state.petDetails[index],
                                          bloc:
                                              BlocProvider.of<PetAdoptionBloc>(
                                                  context))));
                            });
                      });
                } else {
                  return const Center(
                    child: Text("No data available"),
                  );
                }
              }
            },
          ),
        ),
      ]),
    );
  }
}
