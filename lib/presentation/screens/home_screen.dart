import 'package:flutter/material.dart';

import 'package:hw_1/domain/utils/app_strings.dart';
import 'package:hw_1/presentation/screens/breed_list_screen.dart';
import 'package:hw_1/presentation/screens/tinder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appTitle),
          bottom: const TabBar(
            tabs: [
              Tab(text: AppStrings.tabTinder, icon: Icon(Icons.pets_outlined)),
              Tab(text: AppStrings.tabBreeds, icon: Icon(Icons.list_alt)),
            ],
          ),
        ),
        body: const TabBarView(children: [TinderScreen(), BreedListScreen()]),
      ),
    );
  }
}
