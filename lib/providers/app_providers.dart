import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/auth_provider.dart';
import 'package:ripple/providers/charity_provider.dart';
import 'package:ripple/providers/donation_history_provider.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/providers/simple_change_notifier_proxy_provider.dart';
import 'package:ripple/providers/user_identity_provider.dart';
import 'package:ripple/services/auth_service.dart';
import 'package:ripple/services/charity_service.dart';
import 'package:ripple/services/donation_history_service.dart';
import 'package:ripple/services/roundup_setting_service.dart';
import 'package:ripple/services/user_identity_service.dart';

class AppProviders extends StatefulWidget {
  final Widget child;

  const AppProviders({required this.child, super.key});

  @override
  State<AppProviders> createState() => _AppProvidersState();
}

class _AppProvidersState extends State<AppProviders> {
  final AuthService _authService = AuthService();
  final UserIdentityService _userIdentityService = UserIdentityService();
  final CharityService _charityService = CharityService();
  final RoundupSettingService _roundupSettingService = RoundupSettingService();
  final DonationHistoryService _donationHistoryService =
      DonationHistoryService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add to this section any providers that only maintain state.
        // ChangeNotifierProvider<ExampleProvider>(
        //     create: (_) => ExampleProvider(exampleService)),
        // ChangeNotifierProvider<ScaffoldProvider>(
        //     create: (_) => ScaffoldProvider()),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(_authService),
        ),

        // Add to this section any providers that both maintain their own state
        // and depend upon the state of other providers.
        // SimpleChangeNotifierProxyProvider<OtherProvider, ExampleProvider>(
        //     create: (_, otherProvider) =>
        //         ExampleProvider(exampleService, otherProvider),
        //     update: (_, otherProvider, previous) =>
        //         previous.updateDependencies(otherProvider)),
        SimpleChangeNotifierProxyProvider<AuthProvider, UserIdentityProvider>(
          create: (_, authProvider) =>
              UserIdentityProvider(authProvider, _userIdentityService),
          update: (_, authProvider, previous) =>
              previous.updateDependencies(authProvider),
        ),
        SimpleChangeNotifierProxyProvider<UserIdentityProvider,
            RoundupSettingProvider>(
          create: (_, userIdentityProvider) => RoundupSettingProvider(
              userIdentityProvider, _roundupSettingService),
          update: (_, userIdentityProvider, previous) =>
              previous.updateDependencies(userIdentityProvider),
        ),
        SimpleChangeNotifierProxyProvider<RoundupSettingProvider,
            CharityProvider>(
          create: (_, roundupSettingProvider) =>
              CharityProvider(roundupSettingProvider, _charityService),
          update: (_, roundupSettingProvider, previous) =>
              previous.updateDependencies(roundupSettingProvider),
        ),
        SimpleChangeNotifierProxyProvider<UserIdentityProvider,
            DonationHistoryProvider>(
          create: (_, userIdentityProvider) =>
              DonationHistoryProvider(userIdentityProvider, _donationHistoryService),
          update: (_, userIdentityProvider, previous) =>
              previous.updateDependencies(userIdentityProvider),
        ),

        // Add to this section any providers that only transform the state of
        // other providers.
        // ProxyProvider<OtherProvider, ExampleProvider>(
        //     update: (_, otherProvider, __) =>
        //         ExampleProvider(otherProvider)),
      ],
      child: widget.child,
    );
  }
}
