import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_states.dart';


class AppLoginCubit extends Cubit<AppLoginStates> {
  AppLoginCubit() : super(AppLoginInitialState());

  static AppLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(AppLoginLoadingState());
    FirebaseAuth
        .instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      if (kDebugMode) {
        print(value.user!.email);
        print(value.user!.uid);
      }
      emit(AppLoginSuccessState(value.user!.uid));
    }).catchError((error) {
      if (error == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (error == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      }
      emit(AppLoginErrorState(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility;

  changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(AppChanePasswordVisibilityState());
  }
}
