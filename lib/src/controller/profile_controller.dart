// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

class ProfileController extends ControllerMVC {

  User? user;
  User currentUser = User();

  bool isEditingName = false;
  bool isEditingPhone = false;
  bool isEditingAddress = false;
  TextEditingController? nameController;
  TextEditingController? phoneController;
  TextEditingController? addressController;


  bool isLoading = false;
  bool loadingFollow = false;

  GlobalKey<ScaffoldState>? scaffoldKey;

  ProfileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
  }

  void getUserDetails(String userId) async {
    userRepo.getUserProfile(userId).then((_user) {
      setState((){
        if(_user != null) {
          this.user = _user;
        }
        this.isLoading = false;
      });
      if(_user == null) {
        ScaffoldMessenger.of(this.scaffoldKey!.currentContext!).showSnackBar(SnackBar(content: Text('Unable to get user details')));
      }
    },
    onError: (e){
      print(e);
      setState((){
        this.isLoading = false;
      });
    });
  }

  void getCurrentUser() async {
    userRepo.getCurrentUser().then((_user) {
      setState((){
        this.currentUser = _user;
      });
    });
  }

  void followUser() async {
    setState(() {
      loadingFollow = true;
    });
    userRepo.followUser(this.user!).then((value) {
      setState(() {
        this.user!.followed = value ? !this.user!.followed : this.user!.followed;
        this.loadingFollow = false;
      });
    });
  }

  void updateName() async {
    if(nameController!.text.length > 3) {
      User editedUser = this.user!;
      editedUser.name = nameController!.text;
      updateUserProfile(editedUser);
    
    } else {
      
      scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Name must be at least 3 characters long.")));
    }
  }

  void updateEmail() async {
    if(phoneController!.text.length > 5) {
      User editedUser = this.user!;
      editedUser.phone = phoneController!.text;
      updateUserProfile(editedUser);
    } else {
      scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Invalid Phone")));
    }
  }

  void updateAddress() async {
    if(addressController!.text.length > 5) {
      User editedUser = this.user!;
      editedUser.address = addressController!.text;
      updateUserProfile(editedUser);
    } else {
      scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Invalid Address")));
    }
  }


  void updateUserProfile(User _user) async {
    setState((){
      isLoading = true;
    });
    Stream<User> stream = await userRepo.updateUser(_user);
    stream.listen((_newUser) {
      setState((){
        isLoading = false;
        isEditingPhone = false;
        isEditingName = false;
        isEditingAddress = false;
        phoneController!.text = "";
        nameController!.text = "";
        addressController!.text = "";
      });
      setState((){
        this.user = _newUser;
      });
    }, onError: (e){
      setState((){
        isLoading = false;
      });
      print(e);
      scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Verify your internet connection")));
    }, onDone: (){
      setState((){
        isLoading = false;
      });
      scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Details updated")));
    }
    );
  }


  void getGalleryImage() async {
    var _rand = Random();
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if(pickedFile!=null) {
      debugPrint("pickedFile: " + pickedFile.path);
      setState((){
        this.user!.isNewImage = true;
        this.user!.newImgIdentifier = pickedFile.path;
        this.user!.newImgName = "Image_${_rand.nextInt(100000)}";
      });
      this..updateUserProfile(this.user!);
    }
  }

}