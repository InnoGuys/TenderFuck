class RecentOrder {
  final String? icon, name, date, price;

  RecentOrder({this.icon, this.name, this.date, this.price});

  factory RecentOrder.fromJson(Map<String, dynamic> json) {
    return RecentOrder(
      icon: "assets/icons/camera.svg",
      name: json['name'],
        date: json['date'],
        price: json['price'],
    );
  }
}

List demoRecentOrders = [
  RecentOrder(
    icon: "assets/icons/camera.svg",
    name: "Иван Пупочкин",
    date: "01-03-2021",
    price: "300\$",
  ),

];
