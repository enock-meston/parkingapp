class AgentsModel {
  String? id;
  String? fname;
  String? lname;
  String? email;
  String? phoneNumber;
  String? password;
  String? addedBy;
  String? addedOn;
  String? activeStatus;
  String? success;
  String? message;

  AgentsModel(
      {this.id,
      this.fname,
      this.lname,
      this.email,
      this.phoneNumber,
      this.password,
      this.addedBy,
      this.addedOn,
      this.activeStatus,
      this.success,
      this.message});

  AgentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    addedBy = json['AddedBy'];
    addedOn = json['addedOn'];
    activeStatus = json['ActiveStatus'];
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['password'] = this.password;
    data['AddedBy'] = this.addedBy;
    data['addedOn'] = this.addedOn;
    data['ActiveStatus'] = this.activeStatus;
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}