import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/app_failure.dart';
import '../../../data/character/character_repository.dart';
import '../../../data/character/models/character.dart';

part 'character_list_cubit.freezed.dart';
part 'character_list_state.dart';

@lazySingleton
class CharacterListCubit extends Cubit<CharacterListState> {
  CharacterListCubit(this._repository) : super(const _Initial());

  final CharacterRepository _repository;

  Future<void> getCharacterList() async {
    emit(const _GetInProgress());

    final failureOrCharacters = await _repository.getCharacterList();

    failureOrCharacters.fold(
      (failure) => emit(_GetFailure(failure: failure)),
      (characters) => emit(_GetSuccess(characters: characters)),
    );
  }

  Future<void> fetchCharacterList() async {
    emit(const _FetchInProgress());

    final failureOrVoid = await _repository.fetchCharacterList();

    failureOrVoid.fold(
      (failure) => emit(_FetchFailure(failure: failure)),
      (_) => emit(const _FetchSuccess()),
    );
  }
}