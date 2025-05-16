import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../services/firebase_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseService firebaseService;

  AuthBloc({required this.firebaseService}) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final user = firebaseService.currentUser;
      if (user != null) {
        emit(Authenticated(uid: user.uid));
      } else {
        emit(Unauthenticated());
      }
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user =
            await firebaseService.signInWithEmail(event.email, event.password);
        if (user != null) {
          emit(Authenticated(uid: user.uid));
        } else {
          emit(const AuthError(message: 'User not found'));
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user =
            await firebaseService.signUpWithEmail(event.email, event.password);
        if (user != null) {
          await firebaseService.saveUserName(user.uid, event.name);
          emit(Authenticated(uid: user.uid));
        } else {
          emit(const AuthError(message: 'Registration failed'));
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<SignOutRequested>((event, emit) async {
      await firebaseService.signOut();
      emit(Unauthenticated());
    });
  }
}
