import 'package:firebase_auth/firebase_auth.dart';
import 'app_router.dart';
import 'constants/my_strings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

late String initialRoute;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth.instance.authStateChanges().listen(
    (user) {
      if (user == null) {
        initialRoute = loginScreen;
      } else {
        initialRoute = mapScreen;
      }
    },
  );

  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({required this.appRouter});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute,
    );
  }
}
