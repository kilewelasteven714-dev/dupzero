part of 'storage_bloc.dart';

abstract class StorageState extends Equatable {
  const StorageState();
  @override List<Object?> get props => [];
}

class StorageInitial extends StorageState {}
class StorageLoading extends StorageState {}

class StorageLoaded extends StorageState {
  final StorageInfo info;
  final bool alertFired;

  const StorageLoaded({required this.info, this.alertFired = false});

  StorageLoaded copyWith({StorageInfo? info, bool? alertFired}) =>
      StorageLoaded(info: info ?? this.info, alertFired: alertFired ?? this.alertFired);

  @override List<Object?> get props => [info, alertFired];
}
