import 'package:flutter/material.dart';

import '../../../constants.dart';

class OrderItem extends StatefulWidget {
  String orderNumber;
  String orderDate;
  String provider;
  String price;
  String item;
  OrderItem({
    Key? key,
    required this.orderNumber,
    required this.orderDate,
    required this.provider,
    required this.price,
    required this.item,
  }) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10.0,
        color: cardColor,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white54, width: 0.5),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: Expanded(
                  child: Column(
                    children: [
                      Text("Заказ #" + this.widget.orderNumber, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text("Дата: " + this.widget.orderDate),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.all(20),

                child: Column(
                  children: [
                    Text("Поставщик: " + this.widget.provider, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ButtonBar(
                      children: [
                        TextButton(
                          child: const Text('СВЯЗАТЬСЯ С ПОСТАВЩИКОМ'),
                          onPressed: () {/* ... */},
                        ),
                        TextButton(
                          child: const Text('ПОДРОБНЕЕ'),
                          onPressed: () {/* ... */},
                        )
                      ],
                    )
                  ],
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 50),

                child: Column(
                  children: [
                    Text("Товар: "),
                    Text(this.widget.item),
                  ],
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 50),

                child: Column(
                  children: [
                    Text("Цена: "),
                    Text(this.widget.price),
                  ],
                ),
              ),

            ],
          ),

            // Expanded(
            //   child: Container(
            //     height: 200.0,
            //     child: Ink.image(
            //       image: cardImage,
            //       fit: BoxFit.fill,
            //     ),
            //   ),
            // ),
            // ListTile(
            //   title: Text(heading),
            //   subtitle: Text(subheading),
            //   trailing: Icon(Icons.favorite_outline),
            // ),
            //
            //
            // Container(
            //   padding: EdgeInsets.all(16.0),
            //   alignment: Alignment.centerLeft,
            //   child: Text(supportingText),
            // ),


          ],
        ));
  }
}
