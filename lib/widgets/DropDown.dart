import 'package:chat2025/constants/constants.dart';
import 'package:chat2025/models/ModelsModel.dart';
import 'package:chat2025/providers/ModelsProvider.dart';
import 'package:chat2025/services/ApiService.dart';
import 'package:chat2025/widgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DropDown extends StatefulWidget {
  const DropDown({super.key});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? currentModel;

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.getCurrentModel;

    return FutureBuilder<List<String>>(
      future: modelsProvider.getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Aucun modèle trouvé");
        }

        List<String> models = snapshot.data!;
        currentModel ??= models.first;

        return DropdownButton<String>(
          dropdownColor: scaffoldBackgroundColor,
          iconEnabledColor: Colors.white,
          value: currentModel,
          items:
              models.map((model) {
                return DropdownMenuItem<String>(
                  value: model,
                  child: TextWidget(
                    label:
                        model
                            .split("/")
                            .last
                            .split(":")
                            .first, // Affiche uniquement le nom
                    fontSize: 15,
                  ),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              currentModel = value;
            });
            modelsProvider.setCurrentModel(value!);
          },
        );
      },
    );
  }
}
