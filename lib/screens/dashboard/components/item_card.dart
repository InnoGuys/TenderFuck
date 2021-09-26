import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../constants.dart';

class ItemCard extends StatefulWidget {

  String heading;
  String subheading;
  NetworkImage cardImage = NetworkImage(
      'https://source.unsplash.com/random/800x600?house');
  String supportingText;

  ItemCard({
    Key? key,
    required this.heading,
    required this.subheading,
    required this.cardImage,
    required this.supportingText
  }) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {

  @override
  Widget build(BuildContext context) {
    String heading = this.widget.heading;
    String subheading = this.widget.subheading;
    NetworkImage cardImage = this.widget.cardImage;
    String supportingText = this.widget.supportingText;

    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                insetPadding: EdgeInsets.all(10),
                content: Builder(
                  builder: (_) {
                    var height = MediaQuery.of(context).size.height;
                    var width = MediaQuery.of(context).size.width;
                    return Container(

                    height: height - 400,
                    width: width - 400,
                    child: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            right: -40.0,
                            top: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                child: Icon(Icons.close),
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              TextField(
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  icon: Icon(Icons.account_circle),
                                  labelText: 'Username',
                                ),
                              ),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.lock),
                                  labelText: 'Password',
                                ),
                              ),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.description),
                                  labelText: 'text',
                                ),
                              ),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.description),
                                  labelText: 'text',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

              );
            });

        // _openPopup(context);

      },
      child: Card(
          elevation: 10.0,
          color: cardColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white54, width: 0.5),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: 200.0,
                  child: Ink.image(
                    image: cardImage,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              ListTile(
                title: Row(
              children: [
                Text(heading),
                Spacer(),
                Text("Поставщик:")
              ],
              ),
                subtitle: Row(
                  children: [
                    Text(subheading),
                    Spacer(),
                    Text('OOO Васи Пупкина')
                  ],
                  ),
                trailing: Icon(Icons.favorite_outline),
              ),


              Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Text(supportingText),
              ),

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
          )),
    );
  }
  _openPopup(context) {
    Alert(
        context: context,
        title: "LOGIN",
        style: AlertStyle(
          backgroundColor: Colors.white
        ),
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Username',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "LOGIN",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
