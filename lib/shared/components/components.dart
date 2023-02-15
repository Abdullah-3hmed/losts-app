import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({
  required String message,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state: state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastStates { success, error, warning }

Color chooseToastColor({required ToastStates state}) {
  Color color;
  switch (state) {
    case ToastStates.success:
      {
        color = Colors.green;
        break;
      }
    case ToastStates.error:
      {
        color = Colors.red;
        break;
      }
    case ToastStates.warning:
      {
        color = Colors.amberAccent;
        break;
      }
  }
  return color;
}

Widget defaultTextFormField({
  TextEditingController? controller,
  required TextInputType type,
  required IconData prefixIcon,
  IconData? suffixIcon,
  required bool obscureText,
  required String label,
  Function(String)? onSubmit,
  VoidCallback? function,
  String? hintText,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscureText,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
          icon: Icon(suffixIcon),
          onPressed: function,
        ),
        label: Text(
          label,
        ),
        contentPadding: const EdgeInsets.all(20.0),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$label required';
        }
        return null;
      },
    );

Future navigateAndFinish(
  BuildContext context,
  Widget screen,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => false,
    );

Future navigateTo({
  required BuildContext context,
  required Widget screen,
}) =>
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );

Widget defaultMaterialButton({
  required VoidCallback function,
  bool isUpperCase = true,
  required String text,
  double radius = 4.0,
  Color color = Colors.blue,
}) =>
    Container(
      width: double.infinity,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: color,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

PreferredSizeWidget? defaultAppBar({
  required BuildContext context,
  String title = '',
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.white),
      ),
      actions: actions,
    );
