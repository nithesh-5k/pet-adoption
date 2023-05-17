import 'package:flutter/material.dart';
import 'package:pet_adoption_app/model/pet_details.dart';
import 'package:pet_adoption_app/utils/colors.dart';

class PetDataCard extends StatelessWidget {
  PetDetails petDetail;
  Function onTap;
  PetDataCard({required this.petDetail, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Hero(
            tag: petDetail.key,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0)),
              child: Image.network(
                petDetail.imageUrl,
                width: MediaQuery.of(context).size.width - 100,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          ),
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 100,
              decoration: BoxDecoration(
                color: lightOrange,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      petDetail.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () => onTap(),
                      child: Container(
                        decoration: BoxDecoration(
                            color: purple,
                            borderRadius: BorderRadius.circular(3)),
                        padding: const EdgeInsets.all(4),
                        child: const Text(
                          "Check Details",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
