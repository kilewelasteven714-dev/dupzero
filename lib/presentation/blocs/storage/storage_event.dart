part of 'storage_bloc.dart';

abstract class StorageEvent extends Equatable {
  const StorageEvent();
  @override List<Object?> get props => [];
}

class LoadStorageEvent extends StorageEvent {}
class CheckStorageAlertEvent extends StorageEvent {}
class RefreshStorageEvent extends StorageEvent {}
