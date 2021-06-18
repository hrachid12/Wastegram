
class Post {
  String imageURL;
  int quantity;
  DateTime date;
  double latitude;
  double longitude;

  Post({this.imageURL, this.quantity, this.date, this.latitude, this.longitude});

  void fromMap(Map values) {
    this.imageURL = values['imageURL'];
    this.quantity = values['quantity'];
    this.date = values['date'];
    this.latitude = values['latitude'];
    this.longitude = values['longitude'];
  
  }
}