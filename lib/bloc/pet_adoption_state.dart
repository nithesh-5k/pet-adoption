part of 'pet_adoption_bloc.dart';

abstract class PetAdoptionState extends Equatable {
  const PetAdoptionState();

  @override
  List<Object> get props => [];
}

class PetAdoptionInitial extends PetAdoptionState {}

class PetAdoptionFetched extends PetAdoptionState {
  const PetAdoptionFetched(this.petDetails);

  final List<PetDetails> petDetails;

  @override
  List<Object> get props => [identityHashCode(this)];
}

class PetAdoptionFetchedBySearch extends PetAdoptionState {
  const PetAdoptionFetchedBySearch(this.petDetails);

  final List<PetDetails> petDetails;

  @override
  List<Object> get props => [identityHashCode(this)];
}

class PetAdoptionFetchedByChronology extends PetAdoptionState {
  const PetAdoptionFetchedByChronology(this.petDetails);

  final List<PetDetails> petDetails;

  @override
  List<Object> get props => [identityHashCode(this)];
}
