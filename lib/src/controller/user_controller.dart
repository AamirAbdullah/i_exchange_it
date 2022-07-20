import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iExchange_it/src/models/user.dart' as U;
import 'package:iExchange_it/src/pages/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

class UserController extends ControllerMVC {
  U.User? user;
  U.User currentUser = U.User();
  bool isLoading = false;
  TextEditingController? passwordController;

  GlobalKey<ScaffoldState>? scaffoldKey;
  GlobalKey<FormState>? formKey;

  // GoogleSignIn _googleSignIn = GoogleSignIn();

  UserController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.formKey = new GlobalKey<FormState>();
    passwordController = TextEditingController();
  }

  void login() async {
    if (formKey!.currentState!.validate()) {
      formKey!.currentState!.save();
      setState(() {
        isLoading = true;
      });
      userRepo.login(currentUser).then((_user) {
        setState(() {
          isLoading = false;
        });
        if (_user.apiToken != null && _user.apiToken.toString().length > 0) {
          Navigator.of(this.scaffoldKey!.currentContext!)
              .pushNamedAndRemoveUntil("/Pages", (route) => false,
                  arguments: 0);
        } else {
          // scaffoldKey!.currentState!
          //     // ignore: deprecated_member_use
          //     .showSnackBar(SnackBar(content: Text("Wrong email or password")));
        }
      }, onError: (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
        // ignore: deprecated_member_use
        // scaffoldKey!.currentState!.showSnackBar(
        //     SnackBar(content: Text("Verify your internet connection")));
      });
    }
  }

  void register() async {
    if (formKey!.currentState!.validate()) {
      formKey!.currentState!.save();
      setState(() {
        isLoading = true;
      });
      userRepo.register(currentUser).then((_user) {
        setState(() {
          isLoading = false;
        });
        if (_user.apiToken != null && _user.apiToken.toString().length > 0) {
          Navigator.of(this.scaffoldKey!.currentContext!)
              .pushNamedAndRemoveUntil("/Pages", (route) => false,
                  arguments: 0);
        } else {
          // scaffoldKey!.currentState!
          //     // ignore: deprecated_member_use
          //     .showSnackBar(SnackBar(content: Text("Wrong email or password")));
        }
      }, onError: (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
        // ignore: deprecated_member_use
        // scaffoldKey!.currentState!.showSnackBar(
        //     SnackBar(content: Text("Verify your internet connection")));
      });
    }
  }

  void getCurrentUser() async {
    userRepo.getCurrentUser().then((_user) {
      setState(() {
        this.currentUser = _user;
      });
    });
  }



  void signUpWithFacebook(context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(permissions: (['email', 'public_profile']));
      final token = result.accessToken!.token;
      print('Facebook token userID : ${result.accessToken!.grantedPermissions}');
      final graphResponse = await http.get(Uri.parse( 'https://graph.facebook.com/'
          'v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));

      final profile = jsonDecode(graphResponse.body);
      print("Profile is equal to $profile");
      String email=profile['email'];
      String name=profile['name'];
      U.User _facebookuser = U.User();
      _facebookuser.email = email;
      _facebookuser.name = name;

      userRepo.socialLogin(_facebookuser, 'facebook').then((_user) {
        if (_user.alreadyExists) {
          // scaffoldKey!.currentState!
          // // ignore: deprecated_member_use
          //     .showSnackBar(SnackBar(content: Text("Email already registered")));
        } else {
          if (_user.apiToken != null && _user.apiToken.toString().length > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PagesWidget()),
            );
          } else {
            // scaffoldKey!.currentState!
            // // ignore: deprecated_member_use
            //     .showSnackBar(SnackBar(content: Text("Wrong email or password")));
          }
        }
      });
      try {
        final AuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.token);
        // ignore: unused_local_variable
        final userCredential = await FirebaseAuth.instance.signInWithCredential(facebookCredential);

      }catch(e)
      {
        final snackBar = SnackBar(
          margin: const EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content:  Text(e.toString()),
          backgroundColor: (Colors.redAccent),
          action: SnackBarAction(
            label: 'dismiss',
            onPressed: () {
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

    } catch (e) {
      print("error occurred");
      print(e.toString());
    }
  }



  // Future<UserCredential> signUpWithFacebook(context) async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => PagesWidget()),
  //   );
  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

  // void signUpWithGoogle() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   if (await isInternetConnection()) {
  //     try {
  //       if (await _googleSignIn.isSignedIn()) {
  //         await _googleSignIn.signOut();
  //       }
  //       GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  //       if (googleSignInAccount != null) {
  //         debugPrint("Google Signin not null ");
  //         String? email = googleSignInAccount.email;
  //         String? name = googleSignInAccount.displayName;
  //          U.User _googleUser =  U.User();
  //         _googleUser.email = email;
  //         _googleUser.name = name;

  //         socialLogin(_googleUser, "google");
  //       } else {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       }
  //     } catch (error) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       print("Error Google Signin");
  //       print(error);
  //     }
  //   } else {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     // ignore: deprecated_member_use
  //     scaffoldKey!.currentState!.showSnackBar(
  //         SnackBar(content: Text("Verify your internet connection")));
  //   }
  // }

  void socialLogin(U.User _user, String method) async {
    userRepo.socialLogin(_user, method).then((_user) {
      setState(() {
        isLoading = false;
      });
      if (_user.alreadyExists) {
        // scaffoldKey!.currentState!
        //     // ignore: deprecated_member_use
        //     .showSnackBar(SnackBar(content: Text("Email already registered")));
      } else {
        if (_user.apiToken != null && _user.apiToken.toString().length > 0) {
          Navigator.of(this.scaffoldKey!.currentContext!)
              .pushNamedAndRemoveUntil("/Pages", (route) => false,
                  arguments: 0);
        } else {
          // scaffoldKey!.currentState!
          //     // ignore: deprecated_member_use
          //     .showSnackBar(SnackBar(content: Text("Wrong email or password")));
        }
      }
    }, onError: (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      // // ignore: deprecated_member_use
      // scaffoldKey!.currentState!.showSnackBar(
      //     SnackBar(content: Text("Verify your internet connection")));
    });
  }

}


class GoogleSignInController extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GlobalKey<ScaffoldState>? scaffoldKey;
  GlobalKey<FormState>? formKey;
  bool isLoading = false;
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user!;
  Future googleLogin(context) async {

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    _user = googleUser;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();

    String? email = _user!.email;
    String? name = _user!.displayName;
    U.User _googleUser = U.User();
    _googleUser.email = email;
    _googleUser.name = name;

    userRepo.socialLogin(_googleUser, 'google').then((_user) {
      if (_user.alreadyExists) {
        // scaffoldKey!.currentState!
        //     // ignore: deprecated_member_use
        //     .showSnackBar(SnackBar(content: Text("Email already registered")));
      } else {
        if (_user.apiToken != null && _user.apiToken.toString().length > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PagesWidget()),
          );
        } else {
          // scaffoldKey!.currentState!
          //     // ignore: deprecated_member_use
          //     .showSnackBar(SnackBar(content: Text("Wrong email or password")));
        }
      }
    }, onError: (e) {
      print(e);

      // ignore: deprecated_member_use
      // scaffoldKey!.currentState!.showSnackBar(
      //     SnackBar(content: Text("Verify your internet connection")));
    });
  }
}
