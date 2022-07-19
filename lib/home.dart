import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_rent/login.dart';
import 'package:home_rent/widgets/post.dart';

import 'add_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(),
            ),
          ).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          if (value == 1) {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
            );
            return;
          }
          setState(() {
            _selectedIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: ("Home"),
          ),
          NavigationDestination(
            icon: Icon(Icons.lock),
            label: ("Logout"),
          ),
        ],
        selectedIndex: _selectedIndex,
      ),
      body: FutureBuilder<QuerySnapshot>(
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.requireData.docs;
            var user = FirebaseAuth.instance.currentUser;
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> d =
                    data[index].data() as Map<String, dynamic>;

                d["documentID"] = data[index].id;
                return PostContainer(
                  post: d,
                  owner: user!.uid == d["user"],
                );
              },
              itemCount: data.length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: FirebaseFirestore.instance
            .collection("posts")
            .orderBy("timestamp", descending: true)
            .get(),
      ),
    );
  }
}
