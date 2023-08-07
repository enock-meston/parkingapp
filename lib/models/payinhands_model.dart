class PayInHandsModel {
  String? payId;
  String? carId;
  String? ownerName;
  String? phoneNumber;
  String? price;
  String? transactionId;
  String? agentId;
  String? status;
  String? date;

  PayInHandsModel(
      {this.payId,
      this.carId,
      this.ownerName,
      this.phoneNumber,
      this.price,
      this.transactionId,
      this.agentId,
      this.status,
      this.date});

  PayInHandsModel.fromJson(Map<String, dynamic> json) {
    payId = json['payId'];
    carId = json['carId'];
    ownerName = json['ownerName'];
    phoneNumber = json['phoneNumber'];
    price = json['price'];
    transactionId = json['transactionId'];
    agentId = json['agentId'];
    status = json['status'];
    date = json['dateOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payId'] = this.payId;
    data['carId'] = this.carId;
    data['ownerName'] = this.ownerName;
    data['phoneNumber'] = this.phoneNumber;
    data['price'] = this.price;
    data['transactionId'] = this.transactionId;
    data['agentId'] = this.agentId;
    data['status'] = this.status;
    data['dateOn'] = this.date;
    return data;
  }
}