import 'package:clean_architecture_flutter/features/pokemon_image/business/entities/pokemon_image_entity.dart';
import 'package:clean_architecture_flutter/features/pokemon_image/business/repositories/pokemon_image_repository.dart';
import 'package:clean_architecture_flutter/features/pokemon_image/data/datasources/pokemon_image_local_data_source.dart';
import 'package:clean_architecture_flutter/features/pokemon_image/data/datasources/pokemon_image_remote_data_source.dart';
import 'package:clean_architecture_flutter/features/pokemon_image/data/models/pokemon_image_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class PokemonImageRepositoryImpl implements PokemonImageRepository {
  final PokemonImageRemoteDataSource remoteDataSource;
  final PokemonImageLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PokemonImageRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, PokemonImageEntity>> getPokemonImage({
    required PokemonImageParams pokemonimageparams,
  }) async {
    if (await networkInfo.isConnected!) {
      try {
        PokemonImageModel remotePokemonImage = await remoteDataSource
            .getPokemonImage(PokemonImageParams: pokemonimageparams);

        localDataSource.cachePokemonImage(
          PokemonImageToCache: remotePokemonImage,
        );

        return Right(remotePokemonImage);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      try {
        PokemonImageModel localPokemonImage = await localDataSource
            .getLastPokemonImage();

        return Right(localPokemonImage);
      } on CacheException {
        return Left(CacheFailure(errorMessage: 'This is a cache exception'));
      }
    }
  }
}
