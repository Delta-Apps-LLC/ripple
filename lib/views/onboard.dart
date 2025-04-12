import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/models/onboard_page.dart';
import 'package:ripple/models/person.dart';
import 'package:ripple/models/roundup_setting.dart';
import 'package:ripple/providers/auth_provider.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/providers/user_identity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/misc/snackbar.dart';
import 'package:ripple/views/auth.dart';
import 'package:ripple/views/login.dart';
import 'package:ripple/widgets/misc/app_bar_title.dart';
import 'package:ripple/widgets/misc/custom_icon_button.dart';
import 'package:ripple/widgets/onboard/connect_bank_page.dart';
import 'package:ripple/widgets/onboard/how_it_works_page.dart';
import 'package:ripple/widgets/onboard/select_charity_page.dart';
import 'package:ripple/widgets/onboard/signup_page.dart';
import 'package:ripple/widgets/misc/page_title.dart';

class OnboardView extends StatefulWidget {
  const OnboardView({super.key, this.level});
  final OnboardLevel? level;

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
  final PageController _pageController = PageController();
  static final _firstNameController = TextEditingController();
  static final _lastNameController = TextEditingController();
  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();
  static final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late int _currentPage;
  Charity? _selectedCharity;
  bool _loading = false;
  late final List<OnboardPage> pages;

  _OnboardViewState() {
    pages = [
      OnboardPage(
        page: SignupPage(
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            formKey: _formKey),
        hasBackButton: false,
        hasNextButton: true,
      ),
      OnboardPage(
        page: HowItWorksPage(),
        hasBackButton: false,
        hasNextButton: true,
      ),
      OnboardPage(
        page: SelectCharityPage(
          onCharitySelected: onCharitySelected,
        ),
        hasBackButton: true,
        hasNextButton: true,
      ),
      OnboardPage(
        page: ConnectBankPage(),
        hasBackButton: true,
        hasNextButton: false,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _currentPage = switch (widget.level) {
      null => 0,
      OnboardLevel.howItWorks => 1,
      OnboardLevel.selectCharity => 2,
      OnboardLevel.connectBank => 3,
      OnboardLevel.complete =>
        4, // Arbitrary, will never be this state on this page
    };
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _signUp(AuthProvider authProvider,
      UserIdentityProvider userIdentityProvider) async {
    if (_validateForm()) {
      final person = Person(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        onboardLevel: OnboardLevel.howItWorks,
      );

      setState(() => _loading = true);
      final err = await authProvider.signUp(
          _emailController.text, _passwordController.text);

      if (err == null) {
        clearForm();
        final newPerson = await userIdentityProvider.addPerson(person);
        if (newPerson == null) {
          final deleteRes =
              await authProvider.deleteAuthUser(authProvider.user?.id ?? '');
          if (deleteRes == null) {
            setState(() => _loading = false);
            showCustomSnackbar(context,
                'Something went wrong, please try again.', AppColors.errorRed);
          } else {
            setState(() => _loading = false);
            showCustomSnackbar(
                context,
                'There seems to be a system error, please contact us to resolve this.',
                AppColors.errorRed);
          }
        } else {
          setState(() => _loading = false);
          incrementPage(userIdentityProvider, false);
        }
      } else {
        setState(() => _loading = false);
        showCustomSnackbar(context, err.message, AppColors.errorRed);
      }
    }
  }

  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  void setCharity(UserIdentityProvider userIdentityProvider,
      RoundupSettingProvider roundupSettingProvider) async {
    if (_selectedCharity == null) {
      showCustomSnackbar(context, 'You need to select a charity to continue',
          AppColors.errorRed);
    } else {
      setState(() => _loading = true);
      final roundupSettings = (roundupSettingProvider.roundupSetting == null)
          ? RoundupSetting(
              userId: userIdentityProvider.person!.id!,
              charityId: _selectedCharity!.id!,
              isActive: true,
            )
          : RoundupSetting(
              id: roundupSettingProvider.roundupSetting!.id,
              userId: userIdentityProvider.person!.id!,
              charityId: _selectedCharity!.id!,
              isActive: true,
              totalYtd: roundupSettingProvider.roundupSetting!.totalYtd,
              runningTotal: roundupSettingProvider.roundupSetting!.runningTotal,
              roundupAmount:
                  roundupSettingProvider.roundupSetting!.roundupAmount,
              donationThreshold:
                  roundupSettingProvider.roundupSetting!.donationThreshold,
              monthlyCap: roundupSettingProvider.roundupSetting!.monthlyCap,
              hasMonthlyCap: roundupSettingProvider.roundupSetting!.hasMonthlyCap,
              roundupMode: roundupSettingProvider.roundupSetting!.roundupMode,
            );
      await roundupSettingProvider.setRoundupSetting(roundupSettings);
      setState(() => _loading = false);
      incrementPage(userIdentityProvider);
    }
  }

  onCharitySelected(Charity? selectedCharity) {
    setState(() {
      _selectedCharity = selectedCharity;
    });
  }

  void determineNextFunction(
      AuthProvider authProvider,
      UserIdentityProvider userIdentityProvider,
      RoundupSettingProvider roundupSettingProvider) {
    switch (_currentPage) {
      case 0:
        _signUp(authProvider, userIdentityProvider);
      case 1:
        incrementPage(userIdentityProvider);
      case 2:
        setCharity(userIdentityProvider, roundupSettingProvider);
      case 3:
        print('Connect bank page');
    }
  }

  void incrementPage(UserIdentityProvider userIdentityProvider,
      [bool updateLevel = true]) async {
    setState(() => _loading = true);
    if (updateLevel) {
      final level = switch (_currentPage) {
        1 => OnboardLevel.selectCharity,
        2 => OnboardLevel.connectBank,
        3 => OnboardLevel.complete,
        int() => throw UnimplementedError(),
      };
      final updatedPerson = Person(
        id: userIdentityProvider.person!.id,
        firstName: userIdentityProvider.person!.firstName,
        lastName: userIdentityProvider.person!.lastName,
        email: userIdentityProvider.person!.email,
        onboardLevel: level,
      );
      await userIdentityProvider.updatePerson(updatedPerson);
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthPage()));
    setState(() => _loading = false);
  }

  void decrementPage() {
    setState(() {
      _selectedCharity = null;
    });
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String _getPageTitle(int index) {
    return switch (index) {
      0 => 'Personal Details',
      1 => 'How it Works',
      2 => 'Select a Charity',
      3 => 'Connect Your Bank',
      int() => throw UnimplementedError(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: getAppBarTitle(),
          centerTitle: true,
          leading: _currentPage == 0
              ? IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginView()));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.black,
                    size: 30,
                  ))
              : null),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        color: AppColors.white,
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: 4,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Consumer<UserIdentityProvider>(
                        builder: (context, userIdentityProvider, child) =>
                            SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight),
                            child: Consumer<RoundupSettingProvider>(
                              builder:
                                  (context, roundupSettingProvider, child) =>
                                      Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PageTitle(
                                    title: _getPageTitle(_currentPage),
                                  ),
                                  pages[_currentPage].page,
                                  if (_loading)
                                    CircularProgressIndicator(
                                      color: AppColors.darkBlue,
                                    ),
                                  (pages[_currentPage].hasBackButton &&
                                          pages[_currentPage].hasNextButton)
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: CustomIconButton(
                                                text: 'Previous',
                                                colors: [
                                                  AppColors.lightGray,
                                                  AppColors.purple
                                                ],
                                                function: decrementPage,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: CustomIconButton(
                                                text: 'Next',
                                                colors: [
                                                  AppColors.lightGray,
                                                  AppColors.purple
                                                ],
                                                function: () =>
                                                    determineNextFunction(
                                                        authProvider,
                                                        userIdentityProvider,
                                                        roundupSettingProvider),
                                              ),
                                            )
                                          ],
                                        )
                                      : (pages[_currentPage].hasBackButton &&
                                              !pages[_currentPage]
                                                  .hasNextButton)
                                          ? CustomIconButton(
                                              text: 'Previous',
                                              colors: [
                                                AppColors.lightGray,
                                                AppColors.purple
                                              ],
                                              function: decrementPage,
                                            )
                                          : CustomIconButton(
                                              text: 'Next',
                                              colors: [
                                                AppColors.lightGray,
                                                AppColors.purple
                                              ],
                                              function: () =>
                                                  determineNextFunction(
                                                      authProvider,
                                                      userIdentityProvider,
                                                      roundupSettingProvider),
                                            ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
              onPageChanged: _onPageChanged,
            ),
          ],
        ),
      ),
    );
  }
}
