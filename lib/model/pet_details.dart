class PetDetails {
  PetDetails(
      {required this.key,
      required this.name,
      required this.imageUrl,
      required this.age,
      required this.price,
      required this.adopted,
      required this.adoptedDate});

  int key;
  String name;
  String imageUrl;
  int age;
  double price;
  bool adopted;
  DateTime? adoptedDate;
}
