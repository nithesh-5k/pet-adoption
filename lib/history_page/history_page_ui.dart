import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/bloc/pet_adoption_bloc.dart';
import 'package:pet_adoption_app/details_page/details_page_ui.dart';
import 'package:pet_adoption_app/model/pet_details.dart';
import 'package:pet_adoption_app/utils/colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PetAdoptionBloc>(context)
        .add(PetAdoptionFetchDataByChronology());
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: purple,
      ),
      body: Column(children: [
        Expanded(
          child: BlocBuilder<PetAdoptionBloc, PetAdoptionState>(
            builder: (context, state) {
              if (state is PetAdoptionFetchedByChronology &&
                  state.petDetails.isNotEmpty) {
                return ListView.builder(
                    itemCount: state.petDetails.length,
                    itemBuilder: (context, index) {
                      return PetHistoryCard(petDetail: state.petDetails[index]);
                    });
              } else {
                return const Center(
                  child: Text("No data available"),
                );
              }
            },
          ),
        ),
      ]),
    );
  }
}

class PetHistoryCard extends StatelessWidget {
  PetDetails petDetail;
  PetHistoryCard({super.key, required this.petDetail});

  @override
  Widget build(BuildContext context) {
    DateTime ad = petDetail.adoptedDate!;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context1) => DetailsPage(
                    petData: petDetail,
                    bloc: BlocProvider.of<PetAdoptionBloc>(context))));
      },
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: lightYellow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black38)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Hero(
              tag: petDetail.key,
              child: Image.network(
                petDetail.imageUrl,
                height: 100,
                width: 100,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Name:"),
                SizedBox(height: 10),
                Text("Adopted on:")
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(petDetail.name),
                const SizedBox(height: 10),
                Text(
                    "${ad.year.toString()}-${ad.month.toString().padLeft(2, '0')}-${ad.day.toString().padLeft(2, '0')} ${ad.hour.toString().padLeft(2, '0')}:${ad.minute.toString().padLeft(2, '0')}")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
