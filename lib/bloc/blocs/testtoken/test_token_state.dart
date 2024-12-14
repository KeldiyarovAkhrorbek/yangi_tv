import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:yangi_tv_new/helpers/auth_state.dart';

///testToken
///testToken
///testToken
@immutable
abstract class TestState extends Equatable {}

class TestTokenLoadingState extends TestState {
  @override
  List<Object?> get props => [];
}

class TestTokenDoneState extends TestState {
  final AuthState authState;
  final String? dangerousAppName;

  TestTokenDoneState({required this.authState, this.dangerousAppName});

  @override
  List<Object?> get props => [authState];
}
