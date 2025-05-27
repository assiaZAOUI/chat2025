import 'package:chat2025/models/ModelsModel.dart';
import 'package:chat2025/services/ApiService.dart';
import 'package:flutter/material.dart';

//nitifcateur de changement
class ModelsProvider with ChangeNotifier {
  //un provider c'est comme un ecouteur (listener) , donc quand il y a
  //un changement dans le provider, il faut dire au provider d'ecouter cet echange
  // :  il notifie les widgets qui l'écoutent
  //et les widgets se reconstruisent avec les nouvelles données

  //pour que le provider peut ecouter les changements de donnees
  // le provider doit etre un parent de ce widget (MaterielApp)
  //notre point le plus elever c'est le MaterialApp (widget)

  String currentModel = "deepseek/deepseek-prover-v2:free";
  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String model) {
    currentModel = model;
    //si currentModel est changer dire au provider d'ecouter cet echange de donnees
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];
  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<String>> getAllModels() {
    return ApiService.getFreeModels();
  }
}
