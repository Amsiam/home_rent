import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_rent/home.dart';

class AddPage extends StatefulWidget {
  AddPage({Key? key, this.post}) : super(key: key);

  final post;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _room = TextEditingController();

  final _address = TextEditingController();

  final _rent = TextEditingController();

  final _extra_info = TextEditingController();

  final _mobile = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.post != null) {
      _rent.text = widget.post['rent'].toString();
      _room.text = widget.post['room'].toString();
      _address.text = widget.post['address'].toString();
      _extra_info.text = widget.post['extra_info'].toString();
      _mobile.text = widget.post['mobile'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Your Home'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _room,
                decoration: InputDecoration(
                  labelText: "Room",
                  hintText: "Enter number of rooms",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _rent,
                decoration: InputDecoration(
                  labelText: "Rent",
                  hintText: "Enter rent amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _address,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Address",
                  hintText: "Enter Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _extra_info,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Extra Info",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _mobile,
                decoration: InputDecoration(
                  labelText: "Contact no",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  child: Text(widget.post == null ? "Post" : "Update"),
                  onPressed: () async {
                    var user = FirebaseAuth.instance.currentUser;
                    var mobile = _mobile.text;
                    var name = "";

                    if (_mobile.text == "") {
                      await FirebaseFirestore.instance
                          .collection("profile")
                          .doc(user!.uid)
                          .get()
                          .then(
                        (value) {
                          mobile = value.data()!["mobile"];
                          name = value.data()!["name"];
                        },
                      ).catchError(
                        (onError) => mobile = "Not Available",
                      );
                    }
                    if (widget.post != null) {
                      String url = widget.post["documentID"];
                      FirebaseFirestore.instance
                          .collection("posts")
                          .doc(url)
                          .update({
                        "rent": _rent.text,
                        "room": _room.text,
                        "address": _address.text,
                        "extra_info": _extra_info.text,
                        "mobile": mobile,
                      }).then((value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Updated"),
                          ),
                        );
                      }).catchError(
                        (onError) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("$onError"),
                          ),
                        ),
                      );
                    } else {
                      FirebaseFirestore.instance.collection("posts").doc().set({
                        "room": _room.text,
                        "rent": _rent.text,
                        "address": _address.text,
                        "extra_info": _extra_info.text,
                        "mobile": mobile,
                        "user": user!.uid,
                        "name": name,
                        "timestamp": DateTime.now(),
                      }).then((value) {
                        _address.clear();
                        _rent.clear();
                        _room.clear();
                        _extra_info.clear();
                        _mobile.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Posted"),
                          ),
                        );
                      }).catchError(
                        (onError) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("$onError"),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (widget.post != null)
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection("posts")
                          .doc(widget.post["documentID"])
                          .delete()
                          .then((value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Updated"),
                          ),
                        );
                      }).catchError(
                        (onError) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("$onError"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
