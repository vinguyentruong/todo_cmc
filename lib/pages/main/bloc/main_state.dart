import 'package:equatable/equatable.dart';

import '../../../common/enums/status.dart';

class MainState extends Equatable {
  MainState({
    this.userVerified = true,
    this.status = RequestStatus.initial,
    this.message,
  });

  final bool userVerified;
  final RequestStatus status;
  final String? message;

  MainState copyWith({
    bool? userVerified,
    RequestStatus? status,
    String? message,
  }) {
    return MainState(
      userVerified: userVerified ?? this.userVerified,
      status: status ?? RequestStatus.initial,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[userVerified, status, message];
}
