import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:virtuallab/src/core/models/user/auth_data.dart';
import 'package:virtuallab/src/core/models/user/identity.dart';
import 'package:virtuallab/src/core/models/user/user.dart';
import 'package:virtuallab/src/core/services/auth_service.dart';

class SignUpState {
  final bool isFirstnameValid;
  final bool isLastnameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isWaiting;
  final bool isSingedUp;
  final bool hasError;
  SignUpState({
    required this.isFirstnameValid,
    required this.isLastnameValid,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isConfirmPasswordValid,
    required this.isWaiting,
    required this.isSingedUp,
    required this.hasError,
  });

  SignUpState copyWith({
    bool? isFirstnameValid,
    bool? isLastnameValid,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isWaiting,
    bool? isSingedUp,
    bool? hasError,
  }) {
    return SignUpState(
      isFirstnameValid: isFirstnameValid ?? this.isFirstnameValid,
      isLastnameValid: isLastnameValid ?? this.isLastnameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isWaiting: isWaiting ?? this.isWaiting,
      isSingedUp: isSingedUp ?? this.isSingedUp,
      hasError: hasError ?? this.hasError,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isFirstnameValid': isFirstnameValid,
      'isLastnameValid': isLastnameValid,
      'isEmailValid': isEmailValid,
      'isPasswordValid': isPasswordValid,
      'isConfirmPasswordValid': isConfirmPasswordValid,
      'isWaiting': isWaiting,
      'isSingedUp': isSingedUp,
      'hasError': hasError,
    };
  }

  factory SignUpState.fromMap(Map<String, dynamic> map) {
    return SignUpState(
      isFirstnameValid: map['isFirstnameValid'],
      isLastnameValid: map['isLastnameValid'],
      isEmailValid: map['isEmailValid'],
      isPasswordValid: map['isPasswordValid'],
      isConfirmPasswordValid: map['isConfirmPasswordValid'],
      isWaiting: map['isWaiting'],
      isSingedUp: map['isSingedUp'],
      hasError: map['hasError'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUpState.fromJson(String source) => SignUpState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SignUpState(isFirstnameValid: $isFirstnameValid, isLastnameValid: $isLastnameValid, isEmailValid: $isEmailValid, isPasswordValid: $isPasswordValid, isConfirmPasswordValid: $isConfirmPasswordValid, isWaiting: $isWaiting, isSingedUp: $isSingedUp, hasError: $hasError)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SignUpState &&
        other.isFirstnameValid == isFirstnameValid &&
        other.isLastnameValid == isLastnameValid &&
        other.isEmailValid == isEmailValid &&
        other.isPasswordValid == isPasswordValid &&
        other.isConfirmPasswordValid == isConfirmPasswordValid &&
        other.isWaiting == isWaiting &&
        other.isSingedUp == isSingedUp &&
        other.hasError == hasError;
  }

  @override
  int get hashCode {
    return isFirstnameValid.hashCode ^
        isLastnameValid.hashCode ^
        isEmailValid.hashCode ^
        isPasswordValid.hashCode ^
        isConfirmPasswordValid.hashCode ^
        isWaiting.hashCode ^
        isSingedUp.hashCode ^
        hasError.hashCode;
  }
}

abstract class SignUpBloc {
  ValueStream<SignUpState> get state;
  SignUpState get initial;
  Future<void> trySignUp(String firstname, String lastname, String email, String password, String confirmPassword);

  Future<void> tryLogin(String email, String password);
  Future<void> tryAutologin();
}

class SignUpBlocImpl implements SignUpBloc {
  SignUpBlocImpl({required AuthService authService}) : _authService = authService;

  final AuthService _authService;

  @override
  ValueStream<SignUpState> get state => _subject.stream;

  @override
  SignUpState get initial => SignUpState(
        hasError: false,
        isConfirmPasswordValid: true,
        isEmailValid: true,
        isFirstnameValid: true,
        isLastnameValid: true,
        isPasswordValid: true,
        isSingedUp: false,
        isWaiting: false,
      );

  StreamSink<SignUpState> get sink => _subject.sink;

  final BehaviorSubject<SignUpState> _subject = BehaviorSubject<SignUpState>();

  @override
  Future<void> trySignUp(
      String firstname, String lastname, String email, String password, String confirmPassword) async {
    final isFirstnameValid = _validate(firstname);
    final isLastnameValid = _validate(lastname);
    final isEmailValid = _validate(email);
    final isPasswordValid = _validate(password);
    final isConfirmPasswordValid = _checkEquals(confirmPassword, password);

    final isValid = (isFirstnameValid && isLastnameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid);
    sink.add(SignUpState(
      hasError: false,
      isConfirmPasswordValid: isConfirmPasswordValid,
      isEmailValid: isEmailValid,
      isFirstnameValid: isFirstnameValid,
      isPasswordValid: isPasswordValid,
      isSingedUp: false,
      isLastnameValid: isLastnameValid,
      isWaiting: false,
    ));

    if (!isValid) return;

    final authData = Identity(passwordHash: password, id: 0);
    final user = User(
      email: email,
      firstName: firstname,
      group: '',
      id: 0,
      identity: authData,
      identityId: 0,
      isAdmin: false,
      lastName: lastname,
    );
    sink.add(SignUpState(
      hasError: false,
      isConfirmPasswordValid: isConfirmPasswordValid,
      isEmailValid: isEmailValid,
      isFirstnameValid: isFirstnameValid,
      isPasswordValid: isPasswordValid,
      isSingedUp: false,
      isLastnameValid: isLastnameValid,
      isWaiting: true,
    ));
    final result = await _authService.register(user);

    if (result.valueOrNull != null) {
      sink.add(SignUpState(
        hasError: false,
        isConfirmPasswordValid: isConfirmPasswordValid,
        isEmailValid: isEmailValid,
        isFirstnameValid: isFirstnameValid,
        isPasswordValid: isPasswordValid,
        isSingedUp: true,
        isLastnameValid: isLastnameValid,
        isWaiting: false,
      ));
    } else {
      sink.add(SignUpState(
        hasError: true,
        isConfirmPasswordValid: isConfirmPasswordValid,
        isEmailValid: isEmailValid,
        isFirstnameValid: isFirstnameValid,
        isPasswordValid: isPasswordValid,
        isSingedUp: false,
        isLastnameValid: isLastnameValid,
        isWaiting: false,
      ));
    }
  }

  bool _validate(String value) {
    return value.isNotEmpty;
  }

  bool _checkEquals(String value1, String value2) {
    return value1.compareTo(value2) == 0 && value1.isNotEmpty;
  }

  @override
  Future<void> tryLogin(String email, String password) async {
    final authData = AuthData(passwordHash: password, email: email);

    sink.add(SignUpState(
      hasError: false,
      isConfirmPasswordValid: true,
      isEmailValid: true,
      isFirstnameValid: true,
      isPasswordValid: true,
      isSingedUp: false,
      isLastnameValid: true,
      isWaiting: true,
    ));
    final result = await _authService.login(authData);

    if (result.valueOrNull != null) {
      sink.add(SignUpState(
        hasError: false,
        isConfirmPasswordValid: true,
        isEmailValid: true,
        isFirstnameValid: true,
        isPasswordValid: true,
        isSingedUp: true,
        isLastnameValid: true,
        isWaiting: false,
      ));
    } else {
      sink.add(SignUpState(
        hasError: true,
        isConfirmPasswordValid: true,
        isEmailValid: true,
        isFirstnameValid: true,
        isPasswordValid: true,
        isSingedUp: false,
        isLastnameValid: true,
        isWaiting: false,
      ));
    }
  }

  @override
  Future<void> tryAutologin() async {
    final result = await _authService.tryAutologin();
    if (result.valueOrNull != null) {
      sink.add(SignUpState(
        hasError: false,
        isConfirmPasswordValid: true,
        isEmailValid: true,
        isFirstnameValid: true,
        isPasswordValid: true,
        isSingedUp: true,
        isLastnameValid: true,
        isWaiting: false,
      ));
    }
  }
}
