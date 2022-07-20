import 'package:flutter/material.dart';

import 'package:iExchange_it/src/models/question.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:iExchange_it/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'package:iExchange_it/src/repository/qna_repository.dart' as repo;

class QnAController extends ControllerMVC {
  bool isLoading = false;
  String? question = "";

  List<Question> questions = <Question>[];

  User? currentUser;
  GlobalKey<ScaffoldState>? scaffoldKey;
  GlobalKey<FormState>? formKey;

  QnAController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.formKey = new GlobalKey<FormState>();
  }

  getAllQuestions() async {
    setState(() {
      isLoading = true;
      this.questions.clear();
    });
    Stream<Question> stream = await repo.getAllQuestions();
    stream.listen((_question) {
      setState(() {
        isLoading = false;
      });
      setState(() {
        this.questions.add(_question);
      });
    }, onError: (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }, onDone: () {
      setState(() {
        isLoading = false;
      });
    });
  }

  postQuestion() async {
    if (this.formKey!.currentState!.validate()) {
      this.formKey!.currentState!.save();
      setState(() {
        this.isLoading = true;
      });
      repo.createQuestion(this.question).then((value) {
        if (value != null) {
          setState(() {
            isLoading = false;
          });
          showToast("Question posted");
          Navigator.of(this.scaffoldKey!.currentContext!).pop();
        } else {
          setState(() {
            isLoading = false;
          });
          showToast("Error posting question");
        }
      }, onError: (e) {
        print(e);
        setState(() {
          this.isLoading = false;
        });
        // ignore: deprecated_member_use
        // scaffoldKey!.currentState!.showSnackBar(
        //     SnackBar(content: Text("Verify your internet connection")));
      });
    }
  }
}
