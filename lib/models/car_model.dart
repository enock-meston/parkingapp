class CarModel {
  String? carId;
  String? carPlate;
  String? carOnwerNames;
  String? parkingPlace;
  String? phoneNumber;
  String? activeStatus;
  String? timeIn;
  String? timeOut;
  String? agentsID;

  CarModel(
      {this.carId,
      this.carPlate,
      this.carOnwerNames,
      this.parkingPlace,
      this.phoneNumber,
      this.activeStatus,
      this.timeIn,
      this.timeOut,
      this.agentsID});

  CarModel.fromJson(Map<String, dynamic> json) {
    carId = json['car_Id'];
    carPlate = json['car_plate'];
    carOnwerNames = json['car_onwer_Names'];
    parkingPlace = json['parkingPlace'];
    phoneNumber = json['phoneNumber'];
    activeStatus = json['activeStatus'];
    timeIn = json['timeIn'];
    timeOut = json['timeOut'];
    agentsID = json['AgentsID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car_Id'] = this.carId;
    data['car_plate'] = this.carPlate;
    data['car_onwer_Names'] = this.carOnwerNames;
    data['parkingPlace'] = this.parkingPlace;
    data['phoneNumber'] = this.phoneNumber;
    data['activeStatus'] = this.activeStatus;
    data['timeIn'] = this.timeIn;
    data['timeOut'] = this.timeOut;
    data['AgentsID'] = this.agentsID;
    return data;
  }
}