class Data {
  String? id;
  String? name;
  String? roll;
  String? shift;
  String? technology;

  Data({this.id, this.name, this.roll, this.shift, this.technology});

  Data.fromJson(Map<dynamic, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    roll = json['Roll'];
    shift = json['Shift'];
    technology = json['Technology'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Roll'] = this.roll;
    data['Shift'] = this.shift;
    data['Technology'] = this.technology;
    return data;
  }
}