
import 'package:city_care/pages/my_incidents_page.dart';
import 'package:city_care/utils/app_navigator.dart';
import 'package:city_care/view_models/incident_list_view_model.dart';
import 'package:city_care/widgets/empty_or_no_items.dart';
import 'package:city_care/widgets/incident_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IncidentListPage extends StatefulWidget {
  @override
  _IncidentListPage createState() => _IncidentListPage();
}

class _IncidentListPage extends State<IncidentListPage> {
  
  IncidentListViewModel _incidentListVM = IncidentListViewModel();
  List<IncidentViewModel> _incidents = List<IncidentViewModel>();
  
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _subscribeToFirebaseAuthChanges(); 
    _populateAllIncidents();
  }

  void _subscribeToFirebaseAuthChanges() {

    FirebaseAuth.instance
      .authStateChanges()
      .listen((user) {
        if(user == null) {
          setState(() {
            _isSignedIn = false; 
          });
        } else {
          setState(() {
            _isSignedIn = true; 
          });
        }
       });

  }

  void _populateAllIncidents() async {

    final incidents = await _incidentListVM.getAllIncidents();
    setState(() {
      _incidents = incidents; 
    });

    print(_incidents); 

  }

  void _navigateToRegisterPage(BuildContext context) async {
    final bool isRegistered =
        await AppNavigator.navigateToRegisterPage(context);
    if (isRegistered) {
      AppNavigator.navigateToLoginPage(context);
    }
  }

  void _navigateToLoginPage(BuildContext context) async {
    final bool isLoggedIn = await AppNavigator.navigateToLoginPage(context);
    if (isLoggedIn) {
      // go to the my incidents page
      AppNavigator.navigateToMyIncidentsPage(context);
    }
  }

  void _navigateToMyIncidentsPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyIncidentsPage()));
  }

  void _navigateToAddIncidentsPage(BuildContext context) async {
    bool incidentAdded = await AppNavigator.navigateToAddIncidentsPage(context);
    if(incidentAdded) {
      _populateAllIncidents(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Latest Incidents")),
        drawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(child: Text("Menu")),
            ListTile(title: Text("Home")),
            _isSignedIn ? ListTile(
                title: Text("My Incidents"),
                onTap: () async {
                  _navigateToMyIncidentsPage(context);
                }) : SizedBox.shrink(),
            _isSignedIn ? ListTile(
              title: Text("Add Incident"),
              onTap: () {
                _navigateToAddIncidentsPage(context);
              },
            ) : SizedBox.shrink(),
            !_isSignedIn ? ListTile(
                title: Text("Login"),
                onTap: () {
                  _navigateToLoginPage(context);
                }) : SizedBox.shrink(),
            !_isSignedIn ? ListTile(
                title: Text("Register"),
                onTap: () {
                  _navigateToRegisterPage(context);
                }) : SizedBox.shrink(),
            _isSignedIn ? ListTile(title: Text("Logout"), onTap: () async {
              // logout the user 
              await FirebaseAuth.instance.signOut();
            }) : SizedBox.shrink()
          ],
        )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _incidents.length > 0 ? IncidentList(_incidents) : EmptyOrNoItems(message: "No incidents found"),
        ));
  }
}
