import 'package:iExchange_it/src/models/answer.dart';

class Question {
  int? id;
  int? userId;
  String? question;
  String? createdAt;
  String? updatedAt;
  int? likes;
  List<Answer>? answers;

  Question();

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    question = json['question'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    likes = json['likes'];
    if (json['answers'] != null) {
      answers = <Answer>[];
      json['answers'].forEach((v) {
        answers!.add(new Answer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['question'] = this.question;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['likes'] = this.likes;
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}