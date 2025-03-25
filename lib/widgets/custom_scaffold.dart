import 'package:flutter/material.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/views/charities.dart';
import 'package:ripple/views/dashboard.dart';
import 'package:ripple/views/donation_history.dart';
import 'package:ripple/views/settings.dart';
import 'package:ripple/widgets/app_bar_title.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({super.key});

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> pages = [
    DashboardView(),
    CharityView(),
    DonationHistoryView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        backgroundColor: AppColors.darkBlue,
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(
        backgroundColor: AppColors.darkBlue,
        icon: Icon(Icons.volunteer_activism),
        label: 'Charities',
      ),
      const BottomNavigationBarItem(
        backgroundColor: AppColors.darkBlue,
        icon: Icon(Icons.monetization_on),
        label: 'Transactions',
      ),
      const BottomNavigationBarItem(
        backgroundColor: AppColors.darkBlue,
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];

    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: getAppBarTitle(),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 12.0, bottom: 12.0, left: 18.0, right: 18),
          child: pages[_selectedIndex],
        ),
        bottomNavigationBar: ClipRRect(
          child: BottomNavigationBar(
            items: items,
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.darkBlue,
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.black,
            onTap: _onItemTapped,
          ),
        ));
  }
}
