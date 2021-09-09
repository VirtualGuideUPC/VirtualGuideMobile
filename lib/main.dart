import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pvd;
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/ui/bloc/provider.dart' as ownpvd;
import 'package:tour_guide/ui/helpers/themeNotifier.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/pages/home/HomePage.dart';
import 'package:tour_guide/ui/pages/login/LoginPage.dart';
import 'package:tour_guide/ui/pages/register/CountryInformation.dart';
import 'package:tour_guide/ui/pages/register/FinishRegister.dart';
import 'package:tour_guide/ui/pages/register/PersonalInformationPage.dart';
import 'package:tour_guide/ui/pages/register/SigninPage.dart';
import 'package:tour_guide/ui/pages/register/TravelStylesPage.dart';
import 'package:tour_guide/ui/pages/register/TravelSubcategoryPage.dart';
import 'package:tour_guide/ui/pages/register/TravelTypePage.dart';
import 'package:tour_guide/ui/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(pvd.ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => new ThemeNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ownpvd.Provider(
      child: pvd.Consumer<ThemeNotifier>(
        builder: (ctx, theme, _) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', 'US'), // English
                const Locale('es', 'ES'),
              ],
              title: 'VirtualGuide',
              navigatorKey: Utils.mainNavigator,
              home: LoginPage(),
              onGenerateRoute: (settings) {
                Widget page;
                if (settings.name == routeLogin) {
                  page = LoginPage();
                } else if (settings.name == routeSignin) {
                  page = SigninPage();
                } else if (settings.name.startsWith(routePersonalInformation)) {
                  page = PersonalInformationPage();
                } else if (settings.name.startsWith(routeCountryInformation)) {
                  page = CountryInformationPage();
                } else if (settings.name.startsWith(routeTravelType)) {
                  page = TravelTypePage();
                } else if (settings.name.startsWith(routeTravelStyles)) {
                  page = TravelStylesPage();
                } else if (settings.name.startsWith(routeTravelSubcategories)) {
                  page = TravelSubcategoryPage();
                } else if (settings.name.startsWith(routeFinishRegister)) {
                  page = FinishRegisterPage();
                }else if (settings.name.startsWith(routePrefixHome)) {
                  final subRoute =
                  settings.name.substring(routePrefixHome.length);
                  page = HomePage(homePageRoute: subRoute);
                } else {
                  throw Exception('Unknown route: ${settings.name}');
                }

                return MaterialPageRoute<dynamic>(
                  builder: (context) {
                    return page;
                  },
                  settings: settings,
                );
              },
              theme: theme.getTheme());
        },
      ),
    );
  }
}

