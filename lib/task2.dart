import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Task2 extends StatefulWidget {
  const Task2({super.key});

  @override
  State<Task2> createState() => _Task2State();
}

class _Task2State extends State<Task2> {
  final textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('PokeAPI'),
        const SizedBox(height: 10),
        SizedBox(
          width: 250,
          child: TextField(
              controller: textFieldController,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Enter Pokemon name...',
                border: UnderlineInputBorder(),
              ),
              onChanged: (value){
                setState(() {});
              },
              ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
            onPressed: textFieldController.text.isEmpty
                ? null
                : () async {
                    try {
                      final PokemonForm result =
                          await getPokemonInfo(textFieldController.text);
                      if(mounted) {
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(result.name),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.network(result.frontDefault),
                                  Text('ID: ${result.id}'),
                                  Text('Name: ${result.name}'),
                                  Text('Types: ${result.types.join(', ')}'),
                                  Text('Version Group: ${result.versionGroup}'),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                      }
                    } catch (e) {
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                          duration: const Duration(seconds: 3),
                        ));
                      }
                    }
                  },
            child: const Text('Get Pokemon Info')),
      ],
    ));
  }
}

//Служебный классы для удобного декодирования JSON ответов
class PokemonForm {
  final String name;
  final int id;
  final String frontDefault;
  final List<String> types;
  final String versionGroup;

  PokemonForm({
    required this.name,
    required this.id,
    required this.frontDefault,
    required this.types,
    required this.versionGroup,
  });

  factory PokemonForm.fromJson(Map<String, dynamic> json) {
    return PokemonForm(
      name: json['name'],
      id: json['id'],
      frontDefault: json['sprites']['front_default'],
      types:
          List<String>.from(json['types'].map((type) => type['type']['name'])),
      //^я хз как, но оно работает....
      versionGroup: json['version_group']['name'],
    );
  }
}

Future<PokemonForm> getPokemonInfo(String pokemonName) async {
  pokemonName = pokemonName.trim();
  pokemonName = pokemonName[0].toLowerCase() + pokemonName.substring(1);
  final infoResponse = await http
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName'));
  if (infoResponse.statusCode != 200) {
    throw Exception('API Error: ${infoResponse.statusCode}');
  } else {
    final formInfo = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon-form/$pokemonName'));

    if (formInfo.statusCode != 200) {
      throw Exception('API Error: ${formInfo.statusCode}');
    } else {
      return PokemonForm.fromJson(jsonDecode(formInfo.body));
    }
  }
}
