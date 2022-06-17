
import 'package:city_care/view_models/incident_view_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Incident {

  final String userId; 
  final String title; 
  final String description; 
  final String photoURL; 
  final DateTime incidentDate;

  Incident({this.userId, this.title, this.description, this.photoURL,this.incidentDate}); 

  Map<String, dynamic> toMap() {
    return {
      "userId": userId, 
      "title": title, 
      "description": description, 
      "photoURL": photoURL, 
      "incidentDate": incidentDate 
    };
  }

  factory Incident.fromDocument(QueryDocumentSnapshot doc) {
    return Incident(
      title: doc["title"], 
      description: doc["description"], 
      photoURL: doc["photoURL"], 
      userId: doc["userId"], 
      incidentDate: doc["incidentDate"].toDate()
    );
  }

  factory Incident.fromIncidentViewState(IncidentViewState vs) {
    return Incident(
      title: vs.title, 
      description: vs.description, 
      photoURL: vs.photoURL, 
      userId: vs.userId, 
      incidentDate: vs.incidentDate
    );
  }

}