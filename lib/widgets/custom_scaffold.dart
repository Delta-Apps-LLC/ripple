import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/views/charities.dart';
import 'package:ripple/views/dashboard.dart';
import 'package:ripple/views/settings.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({super.key});

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> pages = [
    DashboardView(),
    CharityView(),
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
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];

    Widget getAppBarTitle() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ripple-logo-sm.png',
            width: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 35,
              width: 2,
              color: AppColors.black.withOpacity(0.3),
            ),
          ),
          Text(
            'ripple',
            style: GoogleFonts.montserrat(color: AppColors.black, fontSize: 30),
          )
        ],
      );
    }

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
