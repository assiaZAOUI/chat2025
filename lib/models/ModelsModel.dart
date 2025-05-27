class ModelsModel {
  final String id;
  final int created;
  final String model;

  ModelsModel({required this.id, required this.model, required this.created});

  factory ModelsModel.fromJson(Map<String, dynamic> json) {
    return ModelsModel(
      id: json["id"],
      // c la route du modele
      model: json["model"],
      created: json["created"],
    );
  }

  static List<ModelsModel> modelsFromSnapshot(List snapshot) {
    return snapshot.map((e) => ModelsModel.fromJson(e)).toList();
  }
}
