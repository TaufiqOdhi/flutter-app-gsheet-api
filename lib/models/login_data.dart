class LoginDataModel {
  String? token;
  String? refreshToken;
  String? tokenUri;
  String? clientId;
  String? clientSecret;
  List<String>? scopes;
  String? raptToken;

  LoginDataModel(
      {this.token,
      this.refreshToken,
      this.tokenUri,
      this.clientId,
      this.clientSecret,
      this.scopes,
      this.raptToken});

  LoginDataModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refresh_token'];
    tokenUri = json['token_uri'];
    clientId = json['client_id'];
    clientSecret = json['client_secret'];
    scopes = json['scopes'].cast<String>();
    raptToken = json['rapt_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['refresh_token'] = refreshToken;
    data['token_uri'] = tokenUri;
    data['client_id'] = clientId;
    data['client_secret'] = clientSecret;
    data['scopes'] = scopes;
    data['rapt_token'] = raptToken;
    return data;
  }
}
