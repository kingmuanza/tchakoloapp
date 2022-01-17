import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/models/demande.credit.model.dart';
import 'package:tchakolo/models/utilisateur.model.dart';
import 'package:tchakolo/pages/utilisation/credits.confirmation.page.dart';
import 'package:tchakolo/pages/utilisation/credits.demandes.page.dart';
import 'package:tchakolo/pages/utilisation/credits.edit.page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tchakolo/services/jarvis.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({Key? key}) : super(key: key);

  @override
  _CreditsPageState createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  int tabIndex = 0;

  final LocalStorage storage = LocalStorage('tchakolo');
  final demandesFirebase = FirebaseFirestore.instance.collection('demandes');
  List<DemandeCredit> demandes = [];
  bool peutFaireDemande = true;

  Future<List<DemandeCredit>> getDemandesCredits() async {
    Jarvis jarvis = Jarvis();
    return jarvis.getDemandesCredits();
  }

  AlertDialog afficherMessage() {
    return AlertDialog(
      content: Container(
        height: 350,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Une demande à la fois',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff120f3e),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      "Vous ne pouvez effectuer plusiseurs demandes. Veuillez annuler la précédente ou rembourser le montant emprunté",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Color(0xff9dcd21),
                        minimumSize: Size.fromHeight(
                          50,
                        ), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      child: Text(
                        'J\'ai compris',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initPage();
  }

  initPage() {
    getDemandesCredits().then((all) {
      demandes = all;
      controlerQuilPeutFaireUneDemande();
      setState(() {
        demandes = all;
      });
    });
  }

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    print("_onRefresh début");

    getDemandesCredits().then((all) {
      demandes = all;
      controlerQuilPeutFaireUneDemande();
      setState(() {
        _refreshController.refreshCompleted();
        print("_onRefresh fin");
      });
    });
  }

  void _onLoading() async {
    // monitor network fetch
    await this.getDemandesCredits();
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: Scaffold(
        floatingActionButton: genererBouton(context),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 0,
              right: 0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    bottom: 8,
                    left: 24,
                    right: 24,
                  ),
                  width: double.infinity,
                  child: Container(
                    child: Text(
                      'Crédits',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xff120f3e),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DefaultTabController(
                  length: 2,
                  initialIndex: tabIndex,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Color(0xff120f3e),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Color(0xff120f3e),
                        onTap: (index) {
                          tabIndex = index;
                          setState(() {
                            tabIndex = index;
                          });
                        },
                        tabs: [
                          Tab(text: 'Demandes'),
                          Tab(text: 'Prêts'),
                        ],
                      ),
                    ],
                  ),
                ),
                tabIndex == 0
                    ? CreditsDemandes(
                        demandes: demandes,
                      )
                    : contentTab2(),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  controlerQuilPeutFaireUneDemande() async {
    demandes.forEach((d) {
      if (d.dateRecue == null) {
        peutFaireDemande = false;
      }
    });
  }

  faireUneDemande() async {
    print('Vous tentez de faire une demande de crédit');

    if (peutFaireDemande) {
      print('Vous pouvez faire une demande de crédit');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreditsEditPage()),
      );
    } else {
      print('Vous ne pouvez pas faire une demande de crédit');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return afficherMessage();
        },
      );
    }
  }

  Widget genererBouton(BuildContext context) {
    print("peutFaireDemande");
    print(peutFaireDemande);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: () async {
          faireUneDemande();
        },
        backgroundColor: Color.fromRGBO(18, 15, 62, 1),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget contentTab2() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 24,
      ),
      child: Text(
        "Vous n'avez effectué aucun prêt pour l'instant",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
