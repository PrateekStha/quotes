import 'package:adminapp/admin/admin.dart';
import 'package:flutter/material.dart';

//Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class changePassword extends StatefulWidget {
  @override
  _changePasswordState createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  String email;
  String password;
  bool loading = false;
  bool isLogedin = false;
  bool hidePass = true;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/back.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            
          ),
//TODO:: make the logo show

          Container(
            color: Colors.black.withOpacity(0.8),
            width: double.infinity,
            height: double.infinity,
          ),

          Container(
              height: 300,
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/logo.png',
                height: 150,
              )),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: Center(
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.4),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: _emailTextController,
                                decoration: InputDecoration(
                                  hintText: "Update Email",
                                  icon: Icon(Icons.alternate_email),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(value))
                                      return 'Please make sure your email address is valid';
                                    else
                                      return null;
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.4),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _passwordTextController,
                                  obscureText: hidePass,
                                  decoration: InputDecoration(
                                    hintText: "Update Password",
                                    icon: Icon(Icons.vpn_key),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return " password field cannot be empty";
                                    } else if (value.length < 6) {
                                      return "the password has to be at least 6 characters long";
                                    }
                                    return null;
                                  },
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      setState(() {
                                        hidePass = false;
                                      });
                                  
                                    }),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.green,
                              elevation: 0.0,
                              child: MaterialButton(

                                 onPressed: ()  async{
                                   FirebaseUser user = await firebaseAuth.currentUser();
       user.delete().then((value) {});
                    
                    Fluttertoast.showToast(msg: "Updating");
                                  validateForm();
                                //    FirebaseUser user = await firebaseAuth.currentUser();
                                //   FirebaseAuth.instance
                                //       .createUserWithEmailAndPassword(
                                //           email: _emailTextController.text,
                                //           password:
                                //               _passwordTextController.text)
                                //       .then((FirebaseUser user) {
                                //     Fluttertoast.showToast(
                                //         msg: "Updated Successful");
                                //     Navigator.of(context)
                                //         .pushReplacement(MaterialPageRoute(
                                //       builder: (context) => Admin(),
                                //     ));
                                //   }).catchError((e) {
                                //     print(e.message);
                                //     Fluttertoast.showToast(
                                //         msg: "Username and password mismatch");
                                //    });
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Update",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              )),
                        ),
                        
                      ],
                    )),
              ),
            ),
          ),

          Visibility(
            visible: loading ?? true,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.9),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Future validateForm() async {
    
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      
      FirebaseUser user = await firebaseAuth.currentUser();
      
      print('error');
      
        firebaseAuth
            .createUserWithEmailAndPassword(
                email: _emailTextController.text,
                password: _passwordTextController.text)
            .catchError((err) => {print('error is: '+ err.toString())});

    Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (context) => Admin()));

      
    }
  }
}
