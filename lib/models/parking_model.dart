class ParkingModel {
  String? pId;
  String? title;
  String? refere;
  String? price;
  String? status;
  String? addedOn;
  String? postedBy;

  ParkingModel(
      {this.pId,
      this.title,
      this.refere,
      this.price,
      this.status,
      this.addedOn,
      this.postedBy});

  ParkingModel.fromJson(Map<String, dynamic> json) {
    pId = json['pId'];
    title = json['title'];
    refere = json['refere'];
    price = json['price'];
    status = json['status'];
    addedOn = json['AddedOn'];
    postedBy = json['PostedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pId'] = this.pId;
    data['title'] = this.title;
    data['refere'] = this.refere;
    data['price'] = this.price;
    data['status'] = this.status;
    data['AddedOn'] = this.addedOn;
    data['PostedBy'] = this.postedBy;
    return data;
  }
}