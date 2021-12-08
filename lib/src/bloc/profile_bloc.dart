import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';
import 'package:virtuallab/src/core/models/user/user.dart';
import 'package:virtuallab/src/core/services/auth_service.dart';
import 'package:virtuallab/src/core/services/user_response.dart';

class ProfileState {
  final bool isFetching;
  final bool isSaved;
  final bool hasError;
  final User? user;
  ProfileState({
    required this.isFetching,
    required this.isSaved,
    required this.hasError,
    required this.user,
  });

  ProfileState copyWith({
    bool? isFetching,
    bool? isSaved,
    bool? hasError,
    User? user,
  }) {
    return ProfileState(
      isFetching: isFetching ?? this.isFetching,
      isSaved: isSaved ?? this.isSaved,
      hasError: hasError ?? this.hasError,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileState &&
        other.isFetching == isFetching &&
        other.isSaved == isSaved &&
        other.hasError == hasError &&
        other.user == user;
  }

  @override
  int get hashCode {
    return isFetching.hashCode ^ isSaved.hashCode ^ hasError.hashCode ^ user.hashCode;
  }
}

abstract class ProfileBloc {
  ValueStream<ProfileState> get state;
  ProfileState get initial;

  Future<void> saveProfile(User user);
}

class ProfileBlocImpl implements ProfileBloc {
  ProfileBlocImpl({required AuthService authService, required UserService userService})
      : _authService = authService,
        _userService = userService;

  final AuthService _authService;
  final UserService _userService;

  @override
  ValueStream<ProfileState> get state => _subject.stream;

  StreamSink<ProfileState> get sink => _subject.sink;

  final BehaviorSubject<ProfileState> _subject = BehaviorSubject<ProfileState>();

  @override
  ProfileState get initial =>
      ProfileState(isFetching: false, isSaved: false, hasError: false, user: _authService.currentUser!);

  @override
  Future<void> saveProfile(User user) async {
    sink.add(ProfileState(isFetching: true, isSaved: false, hasError: false, user: null));

    final result = await _userService.updateUser(user);

    if (result.exceptionOrNull != null) {
      sink.add(ProfileState(isFetching: false, isSaved: false, hasError: true, user: null));
    } else {
      _authService.currentUser = user;
      sink.add(ProfileState(isFetching: false, isSaved: true, hasError: false, user: null));
    }
  }
}
