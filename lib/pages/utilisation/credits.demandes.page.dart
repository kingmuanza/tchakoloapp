import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/models/demande.credit.model.dart';
import 'package:tchakolo/services/jarvis.dart';

import 'credits.confirmation.page.dart';

class CreditsDemandes extends StatefulWidget {
  final List<DemandeCredit> demandes;
  const CreditsDemandes({Key? key, required this.demandes}) : super(key: key);

  @override
  _CreditsDemandesState createState() => _CreditsDemandesState();
}

class _CreditsDemandesState extends State<CreditsDemandes> {
  final LocalStorage storage = LocalStorage('tchakolo');
  List<Color> couleurs = [];

  @override
  Widget build(BuildContext context) {
    return contentTab1();
  }

  Widget contentTab1() {
    const texte =
        "Vous n'avez effectué aucune demande de crédit pour l'instant";
    if (widget.demandes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 24,
        ),
        child: const Text(
          texte,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: generateDemandeCredits(widget.demandes),
      );
    }
  }

  Widget generateDemandeCredits(List<DemandeCredit> demandes) {
    print("generateDemandeCredits");
    print(demandes.length);
    List<Widget> widgets = [];
    for (var i = 0; i < demandes.length; i++) {
      var demandeCredit = demandes[i];
      couleurs.add(Colors.grey.shade200);
      widgets.add(createDemandeCredit(demandeCredit, i));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgets,
    );
  }

  Widget createDemandeCredit(DemandeCredit demandeCredit, int indexColor) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: couleurs[indexColor],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: demandeCredit.montant.toString(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: couleurs[indexColor] == Color(0xffeeeeee)
                            ? Colors.black87
                            : Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: ' XAF',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 28,
                        color: couleurs[indexColor] == Color(0xffeeeeee)
                            ? Colors.black87
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            demandeCredit.dateRecue != null
                ? Container(
                    width: double.infinity,
                    child: Text(
                      "Délai de remboursement : " +
                          demandeCredit.delai.toString() +
                          " jours",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: couleurs[indexColor] == Color(0xffeeeeee)
                            ? Colors.grey.shade600
                            : Colors.white,
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        "En attente d'un prêteur. Veuillez patienter, vous serez notifié"),
                  ),
            demandeCredit.dateRecue != null
                ? Container(
                    width: double.infinity,
                    child: Text(
                      'Intérêt : ' + demandeCredit.interet.toString() + ' XAF',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: couleurs[indexColor] == Color(0xffeeeeee)
                            ? Colors.grey.shade600
                            : Colors.white,
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(right: 100),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Jarvis jarvis = Jarvis();
                        confirmDismiss(demandeCredit);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Color.fromRGBO(18, 15, 62, 1),
                        minimumSize: Size.fromHeight(
                          50,
                        ), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  rendreLeResteGris() {
    for (var i = 0; i < couleurs.length; i++) {
      couleurs[i] = Colors.grey.shade200;
    }
  }

  confirmDismiss(DemandeCredit demandeCredit) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text(
              "Etes-vous sûr de vouloir annuler la demande crédit ?"),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.only(top: 16, bottom: 32),
              child: ElevatedButton(
                onPressed: () {
                  Jarvis jarvis = Jarvis();
                  jarvis.annulerDemandesCredits(demandeCredit.id!);
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Color.fromRGBO(18, 15, 62, 1),
                  minimumSize: Size.fromHeight(
                    50,
                  ), // fromHeight use double.infinity as width and 40 is the height
                ),
                child: Text(
                  'Confirmer',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
