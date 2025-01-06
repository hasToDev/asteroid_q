import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyInjection.init();
  await getIt.isReady<AssetByteService>();
  await getIt.isReady<SharedPreferences>();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
    if (kIsWeb) BrowserContextMenu.disableContextMenu();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAPI());
      await Amplify.addPlugin(AmplifyAuthCognito(
        secureStorageFactory: AmplifySecureStorage.factoryFrom(
          webOptions: WebSecureStorageOptions(),
        ),
      ));
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e, s) {
      safePrint('Error configuring Amplify: $e\n$s');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return AmplifyAuth(
              state: state,
              body: SignInForm(),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: getAppElevatedStyle(context)?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  TextButton(
                    onPressed: () => state.changeStep(AuthenticatorStep.signUp),
                    style: TextButton.styleFrom(textStyle: getAppElevatedStyle(context)),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.signUp:
            return AmplifyAuth(
              state: state,
              isSignUp: true,
              body: SignUpForm.custom(
                fields: [
                  SignUpFormField.nickname(required: true),
                  SignUpFormField.email(required: true),
                  SignUpFormField.password(),
                  SignUpFormField.passwordConfirmation(),
                ],
              ),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: getAppElevatedStyle(context)?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  TextButton(
                    onPressed: () => state.changeStep(AuthenticatorStep.signIn),
                    style: TextButton.styleFrom(textStyle: getAppElevatedStyle(context)),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.confirmSignUp:
            return AmplifyAuth(state: state, body: ConfirmSignUpForm());
          case AuthenticatorStep.resetPassword:
            return AmplifyAuth(state: state, body: ResetPasswordForm());
          case AuthenticatorStep.confirmResetPassword:
            return AmplifyAuth(state: state, body: const ConfirmResetPasswordForm());
          case AuthenticatorStep.verifyUser:
            return AmplifyAuth(state: state, body: VerifyUserForm());
          case AuthenticatorStep.confirmVerifyUser:
            return AmplifyAuth(state: state, body: ConfirmVerifyUserForm());
          default:
            return null;
        }
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AsteroidProvider>(create: (_) => getIt<AsteroidProvider>()),
          ChangeNotifierProvider<AudioProvider>(create: (_) => getIt<AudioProvider>()),
          ChangeNotifierProvider<FuelPodProvider>(create: (_) => getIt<FuelPodProvider>()),
          ChangeNotifierProvider<GameBoardProvider>(create: (_) => getIt<GameBoardProvider>()),
          ChangeNotifierProvider<GameFlowProvider>(create: (_) => getIt<GameFlowProvider>()),
          ChangeNotifierProvider<GameStatsProvider>(create: (_) => getIt<GameStatsProvider>()),
          ChangeNotifierProvider<FighterJetProvider>(create: (_) => getIt<FighterJetProvider>()),
          ChangeNotifierProvider<MissileProvider>(create: (_) => getIt<MissileProvider>()),
          ChangeNotifierProvider<LeaderboardSmallProvider>(create: (_) => getIt<LeaderboardSmallProvider>()),
          ChangeNotifierProvider<LeaderboardLargeProvider>(create: (_) => getIt<LeaderboardLargeProvider>()),
          ChangeNotifierProvider<LeaderboardMediumProvider>(create: (_) => getIt<LeaderboardMediumProvider>()),
        ],
        child: MaterialApp.router(
          title: 'Asteroid Q',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: AppRoutes.router,
        ),
      ),
    );
  }
}
