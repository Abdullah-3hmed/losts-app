// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> ar = {
    "hi_login": "سجل الدخول الآن للتواصل مع الآخرين",
    "login": "دخول",
    "email_address": "البريد الإلكتروني",
    "password": "كلمة السر",
    "have_account": "ليس لديك حساب ؟",
    "register_now": "سجل الأن",
    "back": "رجوع",
    "register": "تسجيل",
    "hi_register": "سجل الآن للتواصل مع الآخرين",
    "user_name": "اسم المستخدم",
    "phone": "رقم الهاتف",
    "home": "الرئيسية",
    "chats": "المحادثات",
    "post": "نشر",
    "profile": "الشخصية",
    "like": "إعجاب",
    "comment": "تعليق",
  };
  static const Map<String, dynamic> en = {
    "hi_login": "login now to to Communicate with others",
    "login": "LOGIN",
    "email_address": "Email Address",
    "password": "Password",
    "have_account": "Don't have an account ?",
    "register_now": "REGISTER NOW",
    "back": "Back",
    "register": "Register",
    "hi_register": "Register now to Communicate with others",
    "user_name": "User Name",
    "phone": "Phone",
    "home": "Home",
    "chats": "Chats",
    "post": "Post",
    "profile": "My Profile",
    "like": "Like",
    "comment": "Comment",
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "ar": ar,
    "en": en
  };
}
