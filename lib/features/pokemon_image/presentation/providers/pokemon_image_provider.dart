import 'package:clean_architecture_flutter/features/pokemon_image/business/usecases/get_pokemon_image.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../business/entities/pokemon_image_entity.dart';
import '../../data/datasources/pokemon_image_local_data_source.dart';
import '../../data/datasources/pokemon_image_remote_data_source.dart';
import '../../data/repositories/pokemon_image_repository_impl.dart';

class PokemonImageProvider extends ChangeNotifier {
  PokemonImageEntity? PokemonImage;
  Failure? failure;

  PokemonImageProvider({
    this.PokemonImage,
    this.failure,
  });

  void eitherFailureOrPokemonImage() async {
    PokemonImageRepositoryImpl repository = PokemonImageRepositoryImpl(
      remoteDataSource: PokemonImageRemoteDataSourceImpl(
        dio: Dio(),
      ),
      localDataSource: PokemonImageLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrPokemonImage = await GetPokemonImage(pokemonImageRepository: repository).call(
      pokemonimageparams: PokemonImageParams(),
    );

    failureOrPokemonImage.fold(
      (Failure newFailure) {
        PokemonImage = null;
        failure = newFailure;
        notifyListeners();
      },
      (PokemonImageEntity newPokemonImage) {
        PokemonImage = newPokemonImage;
        failure = null;
        notifyListeners();
      },
    );
  }
}
