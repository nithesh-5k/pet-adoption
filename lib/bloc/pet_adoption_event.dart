part of 'pet_adoption_bloc.dart';

abstract class PetAdoptionEvent extends Equatable {
  const PetAdoptionEvent();

  @override
  List<Object> get props => [];
}

class PetAdoptionFetchData extends PetAdoptionEvent {}

class PetAdoptionFetchDataBySearch extends PetAdoptionEvent {
  String searchText;
  PetAdoptionFetchDataBySearch(this.searchText);

  @override
  List<Object> get props => [searchText];
}

class PetAdoptionFetchDataByChronology extends PetAdoptionEvent {}

class PetAdoptionAdoptMe extends PetAdoptionEvent {
  int key;
  PetAdoptionAdoptMe(this.key);

  @override
  List<Object> get props => [key];
}

class PetAdoptionAddPetData extends PetAdoptionEvent {}
