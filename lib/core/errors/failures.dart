import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}
class LocalFailure extends Failure {
  const LocalFailure(super.message);
}
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
class ScanFailure extends Failure {
  const ScanFailure(super.message);
}
class CloudFailure extends Failure {
  const CloudFailure(super.message);
}
class PremiumRequiredFailure extends Failure {
  const PremiumRequiredFailure(super.message);
}
