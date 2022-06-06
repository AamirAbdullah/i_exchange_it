class Option {
  int? id;
  int? attributeId;
  String? option;
  var createdAt;
  var updatedAt;

  Option(
      {this.id, this.attributeId, this.option, this.createdAt, this.updatedAt});

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeId = json['attribute_id'];
    option = json['option'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['attribute_id'] = this.attributeId;
    data['option'] = this.option;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}