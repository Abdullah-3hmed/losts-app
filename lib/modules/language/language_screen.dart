import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/app_cubit/app_cubit.dart';
import 'package:social_app/cubit/app_cubit/app_states.dart';
import 'package:social_app/translations/locale_keys.g.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
             LocaleKeys.language.tr(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                 LocaleKeys.select_your_language.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).iconTheme.color!,
                    ),
                  ),
                  child: InkWell(
                    onTap: (){
                      AppCubit.get(context).setEnglish(context: context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.ac_unit,
                          size: 26.0,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                         LocaleKeys.english.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).iconTheme.color!,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      AppCubit.get(context).setArabic(context: context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.ac_unit,
                          size: 26.0,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                         LocaleKeys.arabic.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
