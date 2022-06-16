class GetRowDataModel {
  String? range;
  String? majorDimension;
  List<dynamic>? values;

  GetRowDataModel({this.range, this.majorDimension, this.values});

  GetRowDataModel.fromJson(Map<String, dynamic> json) {
    range = json['range'];
    majorDimension = json['majorDimension'];
    if (json['values'] != null) {
      values = <String>[];
      json['values'][0].forEach((v) {
        values!.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // ignore: unnecessary_this
    data['range'] = this.range;
    data['majorDimension'] = majorDimension;
    if (values != null) {
      data['values'] = values;
    }
    return data;
  }
}
