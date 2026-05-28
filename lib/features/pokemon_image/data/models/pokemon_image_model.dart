import 'package:clean_architecture_flutter/features/pokemon_image/business/entities/pokemon_image_entity.dart';

import '../../../../../core/constants/constants.dart';

class PokemonImageModel extends PokemonImageEntity {
  const PokemonImageModel({
    required String PokemonImage,
  }) : super(
          path: PokemonImage,
        );

  factory PokemonImageModel.fromJson({required Map<String, dynamic> json}) {
    return PokemonImageModel(
      PokemonImage: json[kPath],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      kPath: kPath,
    };
  }
}
