import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'constant.dart';
import 'models/user.dart';
import 'providers/cart.dart';
import 'providers/user_provider.dart';
import 'screens/history_trx.dart';
import 'screens/inventory.dart';
import 'screens/transaction.dart';
import 'screens/login.dart';
import 'screens/users.dart';
import 'services/auth.dart';
import 'utils/utils.dart';
import 'widget/hide_scroll_indicator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeRight,
  //   DeviceOrientation.landscapeLeft,
  // ]);
  await initializeDateFormatting('id_ID', null);
  Intl.defaultLocale = "id_ID";
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AuthService.getProfile(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return MaterialApp(
      title: 'POS Food',
      scrollBehavior: CustomScrollBehavior(),
      home: user.credentials!.isEmpty ? const LoginScreen() : const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String pageActive = 'Transaction';
  late final User user;
  late final bool isAdmin;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).getUser;
    isAdmin = user.slug == "admin" ? true : false;
  }

  _pageView() {
    switch (pageActive) {
      case 'Transaction':
        return const HomePage();
      case 'Inventory':
        return const InventoryScreen();
      case 'History':
        return const HistoryTrxScreen();
      case 'Users':
        return const UsersScreen();
      case 'Logout':
        return Container();

      default:
        return const LoginScreen();
    }
  }

  _setPage(String page) {
    setState(() {
      pageActive = page;
    });
  }

  Widget sideItemBar({
    required String menu,
    required IconData icons,
    VoidCallback? onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ?? () => _setPage(menu),
        child: AnimatedContainer(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 16),
          duration: const Duration(milliseconds: 300),
          curve: Curves.slowMiddle,
          decoration: BoxDecoration(
            color: pageActive == menu
                ? const Color.fromARGB(62, 66, 66, 66)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icons,
            color: primaryColor,
            size: 25,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 90,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  sideItemBar(
                    menu: "Transaction",
                    icons: Icons.sell,
                  ),
                  sideItemBar(
                    menu: "Inventory",
                    icons: Icons.inventory,
                  ),
                  if (isAdmin)
                    sideItemBar(
                      menu: "History",
                      icons: Icons.history,
                    ),
                  if (isAdmin)
                    sideItemBar(
                      menu: "Users",
                      icons: Icons.group,
                    ),
                  sideItemBar(
                    menu: "Logout",
                    icons: Icons.logout,
                    onTap: () => Utils.showConfirmDialog(
                      context: context,
                      title: "Keluar ?",
                      content: "Anda yakin ingin keluar ?",
                      isNegativeAction: true,
                      onNotOke: () => AuthService.logOut(context),
                      onOke: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _pageView(),
          ),
        ],
      ),
    );
  }
}
