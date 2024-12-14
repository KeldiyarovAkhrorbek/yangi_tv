import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

///testToken
///testToken
///testToken
@immutable
abstract class TestEvent extends Equatable {
  const TestEvent();
}

class TestTokenEvent extends TestEvent {
  @override
  List<Object?> get props => [];
}
