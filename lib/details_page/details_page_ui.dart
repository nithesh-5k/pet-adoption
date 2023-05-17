import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_adoption_app/bloc/pet_adoption_bloc.dart';
import 'package:pet_adoption_app/model/pet_details.dart';
import 'package:pet_adoption_app/utils/colors.dart';

class DetailsPage extends StatelessWidget {
  PetDetails petData;
  PetAdoptionBloc bloc;
  DetailsPage({required this.petData, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details page"),
        backgroundColor: purple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InteractiveViewer(
            boundaryMargin: EdgeInsets.all(5.0),
            child: Hero(
                tag: petData.key,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(petData.imageUrl),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Name :       ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Age :",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Price :",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(petData.name),
                  const SizedBox(height: 16),
                  Text(petData.age.toString()),
                  const SizedBox(height: 16),
                  Text(petData.price.toString()),
                ],
              ),
            ],
          ),
          BlocProvider.value(
            value: bloc,
            child: BlocBuilder<PetAdoptionBloc, PetAdoptionState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    if (!petData.adopted) {
                      bloc.add(PetAdoptionAdoptMe(petData.key));
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            elevation: 16,
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                const SizedBox(height: 20),
                                Lottie.asset('assets/confetti.json',
                                    repeat: false, frameRate: FrameRate(20)),
                                const SizedBox(height: 20),
                                Center(
                                    child: Text(
                                  'You’ve now adopted ${petData.name}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                )),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: petData.adopted ? Colors.grey : Colors.blue,
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      petData.adopted ? "Already Adopted" : "Adopt me",
                      style: TextStyle(
                          color: petData.adopted ? Colors.black : Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
