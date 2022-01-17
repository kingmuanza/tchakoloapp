import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/composants/champ.composant.dart';
import 'package:tchakolo/models/utilisateur.model.dart';

class SupportContacterPage extends StatefulWidget {
  const SupportContacterPage({Key? key}) : super(key: key);

  @override
  _SupportContacterPageState createState() => _SupportContacterPageState();
}

class _SupportContacterPageState extends State<SupportContacterPage> {
  TextEditingController objetControleur = TextEditingController();
  TextEditingController contenuControleur = TextEditingController();
  TextEditingController pieceJointeControleur = TextEditingController();

  final LocalStorage storage = new LocalStorage('tchakolo');
  String pieceJointe = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(
          top: 50,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: 12,
              ),
              width: double.infinity,
              child: Container(
                child: Text(
                  'Contacter le support',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff120f3e),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Text(
                "Votre compte n'a pas encore été validé. Veuillez enregistrer votre pièce d'identité",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Champ(
                libelle: 'Objet',
                leControleur: objetControleur,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Champ(
                libelle: 'Contenu',
                leControleur: contenuControleur,
                multiline: 4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Champ(
                libelle: 'Joindre un fichier',
                leControleur: pieceJointeControleur,
                readOnly: true,
                bouton: IconButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      print("ujdfuhdhuduhduhfs de resultat");
                      print(result.files.single.name);
                      pieceJointe = result.files.single.name;
                      File file = File(pieceJointe);
                      pieceJointeControleur.text = pieceJointe;
                      setState(() {
                        pieceJointeControleur.text = pieceJointe;
                      });
                    } else {
                      print("cest comme si ya pas de resultat");
                    }
                  },
                  icon: Icon(Icons.attach_file),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // onFormSubmit();
                        sendMail();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Color.fromRGBO(18, 15, 62, 1),
                        minimumSize: Size.fromHeight(
                          50,
                        ), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      child: Text(
                        "Envoyer",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Annuler',
                      style: TextStyle(
                        color: Color.fromRGBO(18, 15, 62, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  sendMail() async {
    Random random = new Random();
    int randomNumber = random.nextInt(899999) + 100000;
    var code = randomNumber.toString();
    if (storage.getItem('tchaUtilisateur') != null) {
      Map<String, dynamic> utilisateurString =
          storage.getItem('tchaUtilisateur');

      print('on check le statut... actu');
      Utilisateur u = Utilisateur.fromMap(utilisateurString);

      print('Début envoiSMSEtValidation');
      var url = Uri.https(
          'moneytrans.waveslights.com', '/administration/sendmail.php', {
        'objet': objetControleur.text,
        'contenu': contenuControleur.text,
        'tel': u.id
      });

      try {
        var response = await http.get(url);
        print('FIN de l envoiSMSEtValidation');
        if (response.statusCode == 200) {
          var jsonResponse = response.body;

          print(jsonResponse);
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
      } catch (e) {
        // print(e);
      }
    }
  }
}
