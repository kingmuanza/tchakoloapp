import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/models/demande.credit.model.dart';
import 'package:tchakolo/models/utilisateur.model.dart';

class Jarvis {
  final LocalStorage storage = LocalStorage('tchakolo');
  final demandesFirebase = FirebaseFirestore.instance.collection('demandes');

  Jarvis() {}

  Future<List<DemandeCredit>> getDemandesCredits() async {
    debugPrint("getDemandesCredits");

    Map<String, dynamic> utilisateurString = storage.getItem('tchaUtilisateur');
    Utilisateur utilisateur = Utilisateur.fromMap(utilisateurString);

    List<DemandeCredit> all = [];
    QuerySnapshot<Map<String, dynamic>> datas = await demandesFirebase.get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = datas.docs;
    docs.forEach((doc) {
      DemandeCredit d = DemandeCredit.fromMap(doc.data());
      if (d.idutilisateur == utilisateur.id) {
        debugPrint("jarvis demande de crédit : " + d.id!);
        print(d.toMap());
        all.add(d);
      }
    });
    all.sort((a, b) {
      return b.dateDemande!.millisecondsSinceEpoch -
          a.dateDemande!.millisecondsSinceEpoch;
    });
    debugPrint("Credits démandés récupérés");
    return all;
  }

  Future<bool> annulerDemandesCredits(String id) async {
    debugPrint("getDemandesCredits");

    await demandesFirebase.doc(id).delete();

    return true;
  }
}
