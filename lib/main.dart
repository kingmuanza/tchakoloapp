import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tchakolo/pages/authentification/accueil.page.dart';
import 'package:tchakolo/pages/authentification/compte.creation.page.dart';
import 'package:tchakolo/pages/authentification/compte.cree.page.dart';
import 'package:tchakolo/pages/authentification/compte.localisation.page.dart';
import 'package:tchakolo/pages/authentification/conditions.utilisation.dart';
import 'package:tchakolo/pages/authentification/connexion.page.dart';
import 'package:tchakolo/pages/authentification/inscription.page.dart';
import 'package:tchakolo/pages/authentification/passe.oubliee.page.dart';
import 'package:tchakolo/pages/utilisation/tabs.dart';
import 'package:tchakolo/pages/utilisation/upload.photo.page.dart';

import 'firebase_options.dart';
import 'pages/authentification/code.validation.page.dart';

// 455665
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    RestartWidget(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('Erreur sur Firebase');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          debugPrint('Tout est bien sur Firebase');
        }
        return application();
      },
    );
  }

  MaterialApp application() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tchakolo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(
            fontSize: 30.0,
          ),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      routes: {
        '/': (context) => const AccueilPage(),
        '/inscription': (context) => const InscriptionPage(),
        '/compte/localisation': (context) => const CompteLocalisationPage(),
        '/compte/creation': (context) => const CompteCreationPage(),
        '/compte/cree': (context) => const CompteCreePage(),
        '/code/validation': (context) => const CodeValidation(),
        '/connexion': (context) => const ConnexionPage(),
        '/tabs': (context) => const Tabs(),
        '/conditions': (context) => const ConditionsUtilisation(),
        '/passe/oubliee': (context) => const PasseOublieePage(),
        '/upload/photo': (context) => const UploadPhotoPage(),
      },
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    if (context.findAncestorStateOfType<_RestartWidgetState>() != null) {
      context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
    }
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
