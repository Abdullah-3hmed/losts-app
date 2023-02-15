import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/network/local/cache_helper.dart';

import '../../cubit/login_cubit/login_cubit.dart';
import '../../cubit/login_cubit/login_states.dart';
import '../../layout/app_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../register/register_screen.dart';

class AppLoginScreen extends StatelessWidget {
  const AppLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => AppLoginCubit(),
      child: BlocConsumer<AppLoginCubit, AppLoginStates>(
        listener: (context, state) {
          if (state is AppLoginErrorState) {
            showToast(
              message: state.error,
              state: ToastStates.error,
            );
          }
          if (state is AppLoginSuccessState) {
            showToast(
              message: 'login Success',
              state: ToastStates.success,
            );
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              uId = state.uId;
              navigateAndFinish(
                context,
                const AppLayout(),
              );
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: Colors.black,
                              ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'login now to to Communicate with friends ',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                          label: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          type: TextInputType.text,
                          controller: emailController,
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                            label: 'Password',
                            prefixIcon: Icons.lock_outline,
                            type: TextInputType.visiblePassword,
                            controller: passwordController,
                            obscureText: AppLoginCubit.get(context).isPassword,
                            suffixIcon: AppLoginCubit.get(context).suffix,
                            function: () {
                              AppLoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                AppLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            }),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! AppLoginLoadingState,
                          builder: (context) => Container(
                            height: 65.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  AppLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              child: const Text('LOGIN'),
                            ),
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                            ),
                            TextButton(
                              onPressed: () {
                                navigateTo(
                                  context: context,
                                  screen: const AppRegister(),
                                );
                              },
                              child: const Text('REGISTER NOW'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
