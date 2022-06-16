class AppendRowDataModel {
  String? spreadsheetId;
  String? tableRange;
  Updates? updates;

  AppendRowDataModel({this.spreadsheetId, this.tableRange, this.updates});

  AppendRowDataModel.fromJson(Map<String, dynamic> json) {
    spreadsheetId = json['spreadsheetId'];
    tableRange = json['tableRange'];
    updates =
        json['updates'] != null ? Updates.fromJson(json['updates']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['spreadsheetId'] = spreadsheetId;
    data['tableRange'] = tableRange;
    if (updates != null) {
      data['updates'] = updates!.toJson();
    }
    return data;
  }
}

class Updates {
  String? spreadsheetId;
  String? updatedRange;
  int? updatedRows;
  int? updatedColumns;
  int? updatedCells;
  UpdatedData? updatedData;

  Updates(
      {this.spreadsheetId,
      this.updatedRange,
      this.updatedRows,
      this.updatedColumns,
      this.updatedCells,
      this.updatedData});

  Updates.fromJson(Map<String, dynamic> json) {
    spreadsheetId = json['spreadsheetId'];
    updatedRange = json['updatedRange'];
    updatedRows = json['updatedRows'];
    updatedColumns = json['updatedColumns'];
    updatedCells = json['updatedCells'];
    updatedData = json['updatedData'] != null
        ? UpdatedData.fromJson(json['updatedData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['spreadsheetId'] = spreadsheetId;
    data['updatedRange'] = updatedRange;
    data['updatedRows'] = updatedRows;
    data['updatedColumns'] = updatedColumns;
    data['updatedCells'] = updatedCells;
    if (updatedData != null) {
      data['updatedData'] = updatedData!.toJson();
    }
    return data;
  }
}

class UpdatedData {
  String? range;
  String? majorDimension;
  List<dynamic>? values;

  UpdatedData({this.range, this.majorDimension, this.values});

  UpdatedData.fromJson(Map<String, dynamic> json) {
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
    data['range'] = range;
    data['majorDimension'] = majorDimension;
    if (values != null) {
      data['values'] = values!.map((v) => v).toList();
    }
    return data;
  }
}
