import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_adoption_app/model/pet_details.dart';
import 'package:pet_adoption_app/utils/pet_details_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pet_adoption_event.dart';
part 'pet_adoption_state.dart';

class PetAdoptionBloc extends Bloc<PetAdoptionEvent, PetAdoptionState> {
  PetAdoptionBloc() : super(PetAdoptionInitial()) {
    on<PetAdoptionEvent>((event, emit) {
      if (event is PetAdoptionFetchData) {
        fetchPetData();
      } else if (event is PetAdoptionAdoptMe) {
        changeAdoptMeData(event.key);
      } else if (event is PetAdoptionAddPetData) {
        addMorePetData();
      } else if (event is PetAdoptionFetchDataBySearch) {
        fetchPetDataBySearch(event.searchText);
      } else if (event is PetAdoptionFetchDataByChronology) {
        getChronologicalOrder();
      }
    });
  }

  List<PetDetails> petDetails = [];
  Map<String, dynamic> adoptedData = {};
  int paginationCount = 7;
  SharedPreferences? prefs;

  Future<void> fetchPetData() async {
    petDetails.clear();
    await getSharedPrefData();
    for (int i = 0; i < paginationCount; i++) {
      petDetails.add(PetDetails(
          key: i,
          name: PetDetailsData.petNames[i],
          age: PetDetailsData.petAges[i],
          imageUrl: PetDetailsData.petImages[i],
          price: PetDetailsData.price[i],
          adopted: adoptedData.containsKey(i.toString()),
          adoptedDate: adoptedData.containsKey(i.toString())
              ? DateTime.parse(adoptedData[i.toString()])
              : null));
    }
    emit(PetAdoptionFetched(petDetails));
  }

  Future<void> fetchPetDataBySearch(String searchText) async {
    petDetails.clear();
    await getSharedPrefData();
    for (int i = 0; i < PetDetailsData.petNames.length; i++) {
      if (PetDetailsData.petNames[i]
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        petDetails.add(PetDetails(
            key: i,
            name: PetDetailsData.petNames[i],
            age: PetDetailsData.petAges[i],
            imageUrl: PetDetailsData.petImages[i],
            price: PetDetailsData.price[i],
            adopted: adoptedData.containsKey(i.toString()),
            adoptedDate: adoptedData.containsKey(i.toString())
                ? DateTime.parse(adoptedData[i.toString()])
                : null));
      }
    }
    emit(PetAdoptionFetchedBySearch(petDetails));
  }

  void getChronologicalOrder() {
    List<PetDetails> chronologicalOrder = [];
    for (int i = 0; i < PetDetailsData.petNames.length; i++) {
      if (adoptedData.containsKey(i.toString())) {
        chronologicalOrder.add(PetDetails(
            key: i,
            name: PetDetailsData.petNames[i],
            age: PetDetailsData.petAges[i],
            imageUrl: PetDetailsData.petImages[i],
            price: PetDetailsData.price[i],
            adopted: adoptedData.containsKey(i.toString()),
            adoptedDate: adoptedData.containsKey(i.toString())
                ? DateTime.parse(adoptedData[i.toString()])
                : null));
      }
    }
    chronologicalOrder.sort((a, b) => b.adoptedDate!.compareTo(a.adoptedDate!));
    emit(PetAdoptionFetchedByChronology(chronologicalOrder));
  }

  Future<void> addMorePetData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (paginationCount + 7 <= PetDetailsData.petNames.length) {
      paginationCount += 7;
    } else {
      paginationCount = PetDetailsData.petNames.length;
    }
    add(PetAdoptionFetchData());
  }

  void changeAdoptMeData(int index) {
    petDetails[index].adopted = !petDetails[index].adopted;
    petDetails[index].adoptedDate = DateTime.now();
    adoptedData.putIfAbsent(
        index.toString(), () => petDetails[index].adoptedDate.toString());
    updateSharedPrefData();
    emit(PetAdoptionFetched(petDetails));
  }

  Future<void> getSharedPrefData() async {
    prefs ??= await SharedPreferences.getInstance();
    // prefs!.remove("adoptedData");
    if (prefs!.containsKey("adoptedData")) {
      adoptedData = jsonDecode(prefs!.getString("adoptedData")!);
    }
    adoptedData ??= {};
  }

  Future<void> updateSharedPrefData() async {
    prefs ??= await SharedPreferences.getInstance();
    prefs?.setString("adoptedData", jsonEncode(adoptedData));
  }
}
