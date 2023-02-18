import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model/user_model.dart';
import 'register_states.dart';

class AppRegisterCubit extends Cubit<AppRegisterStates> {
  AppRegisterCubit() : super(AppRegisterInitialState());

  static AppRegisterCubit get(context) => BlocProvider.of(context);

  Future<void> userRegister({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) async {
    emit(AppRegisterLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      //  emit(AppRegisterSuccessState());
      // if (kDebugMode) {
      //   print(value.user!.email);
      //   print(value.user!.uid);
      // }
      userCreate(
        email: email,
        phone: phone,
        name: name,
        userId: value.user!.uid,
      );
    }).catchError((error) {
      if (error == 'weak-password') {
        error = 'The password provided is too weak.';
      } else if (error == 'email-already-in-use') {
        error = 'The account already exists for that email.';
      }
      emit(AppRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String email,
    required String phone,
    required String name,
    required String userId,
  }) {
    AppUserModel model = AppUserModel(
      email: email,
      name: name,
      phone: phone,
      uId: userId,
      bio: 'write your bio ...',
      image: '',
      cover: '',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(
          model.toMap(),
        )
        .then((value) {
      emit(AppCreateUserSuccessState(userId));
    }).catchError((error) {
      emit(AppCreateUserErrorState(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility;

  changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(AppRegisterChanePasswordVisibilityState());
  }
}
