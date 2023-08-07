class TransactionModel {
  String? transId;
  String? carId;
  String? ownerName;
  String? phone;
  String? amount;
  String? trstatus;
  String? transactionId;
  String? transactionIDMoMo;
  String? addedOn;

  TransactionModel(
      {this.transId,
      this.carId,
      this.ownerName,
      this.phone,
      this.amount,
      this.trstatus,
      this.transactionId,
      this.transactionIDMoMo,
      this.addedOn});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    transId = json['trans_id'];
    carId = json['carId'];
    ownerName = json['ownerName'];
    phone = json['phone'];
    amount = json['amount'];
    trstatus = json['trstatus'];
    transactionId = json['transactionId'];
    transactionIDMoMo = json['TransactionIDMoMo'];
    addedOn = json['addedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trans_id'] = this.transId;
    data['carId'] = this.carId;
    data['ownerName'] = this.ownerName;
    data['phone'] = this.phone;
    data['amount'] = this.amount;
    data['trstatus'] = this.trstatus;
    data['transactionId'] = this.transactionId;
    data['TransactionIDMoMo'] = this.transactionIDMoMo;
    data['addedOn'] = this.addedOn;
    return data;
  }
}