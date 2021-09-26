import 'dart:convert';

import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../../constants.dart';
import '../dashboard_screen.dart';
import 'beautiful_textfield.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import 'header.dart';

import 'recent_orders.dart';
import 'package:http/http.dart' as http;

class Immovables extends StatefulWidget {
  final Function callback;
  Data data;

  Immovables({
    Key? key,
    required this.callback,
    required this.data,
  }) : super(key: key);

  @override
  _ImmovablesState createState() => _ImmovablesState();
}

class _ImmovablesState extends State<Immovables> {
  Map<String, String> parameters = {
    "Кол-во спален": "",
    "Кол-во ванных": "",
    "Площадь всего дома в кв. футах": "",
    "Площадь участка дома в кв. футах": "",
    "Кол-ва этажей": "",
    "Наличие водоема поблизости (1/0)": "",
    "Красота вида по шкале от 0 до 4": "",
    "Оценка жилищных условий по шкале от 1 до 5": "",
    "Площадь надземных помещений в кв. футах": "",
    "Площадь подземных помещений в кв. футах": "",
    "Год постройки": "",
    "Год последнего ремонта": "",
    "Адрес": "18810 Densmore Ave N, Shoreline, WA 98133, USA",
  };

  late List<String> values;

  late Widget generalView = Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 5,
        child: Column(
          children: [
            MyFiles(callback: this.widget.callback, data: this.widget.data),
            SizedBox(height: defaultPadding),
            // RecentOrders(),
            if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
            // if (Responsive.isMobile(context)) StorageDetails(),
          ],
        ),
      ),
      if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
      // On Mobile means if the screen is less than 850 we dont want to show it
      // if (!Responsive.isMobile(context))
      //   Expanded(
      //     flex: 2,
      //     child: StorageDetails(),
      //   ),
    ],
  );

  @override
  void initState() {
    super.initState();
    values = List.filled(parameters.length, "");
  }

  @override
  Widget build(BuildContext context) {
    print("LALALALALA");

    return Column(children: [
      FutureBuilder<String?>(
        future: get("get_immovable"),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if(snapshot.hasData){
            // data loaded:
            final response = snapshot.data;
            print(response);
            print("HERE");
            for(int i=0;i<parameters.keys.length;i++){
              if(response!.length>2){
                var body = json.decode(response);
                parameters[parameters.keys.elementAt(i)] = (body[0][body[0].keys.elementAt(i)]==null? "5" : body[0][body[0].keys.elementAt(i)])!;
              }else{
                parameters[parameters.keys.elementAt(i)] = "5";
              }
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount: null == parameters ? 0 : parameters.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: parameters.keys.elementAt(index),
                    ),
                    controller: TextEditingController()
                      ..text = parameters.values.elementAt(index),
                    onChanged: (val) {
                      parameters[parameters.keys.elementAt(index)] = val;
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 10,
                );
              },
            );
          }else{
            return CircularProgressIndicator();
          }

        }
      ),
      SizedBox(height: 30),
      Container(
        padding: EdgeInsets.only(bottom: 50),
        child: ElevatedButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding * 1.5,
              vertical:
              defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
            ),
          ),
          onPressed: () async {
            List<Map<String, String>> body = [
              {
                "bedrooms": "",
                "bathrooms": "",
                "sqft_living": "",
                "sqft_lot": "",
                "floors": "",
                "waterfront": "",
                "view": "",
                "condition": "",
                "sqft_above": "",
                "sqft_basement": "",
                "yr_buit": "",
                "yr_renovation": "",
                "address": "",
              }
            ];
            for (int i = 0; i < parameters.keys.length; i++) {
              body[0][body[0].keys.elementAt(i)] = parameters.values.elementAt(i);
            }
            print(body[0]);
            var resp = await predictPrice(body);
            this.widget.data.predictions[0] = resp!;
            this.widget.callback(generalView, this.widget.data);

            body[0]['price'] = resp;

            save(body, "save_immovable");

            // _onBasicAlertPressed(context, resp);
            print(resp);
          },
          child: const Text('Сохранить и посчитать'),
        ),
      )
    ]);
    Expanded(
      flex: 5,
      child: Column(
        children: [
          TextField(
              decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueAccent,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: "Enabled decoration text ...",
          )),
          SizedBox(
            height: 5,
          ),
          TextField(
              decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueAccent,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintText: "Enabled decoration text ...",
          )),
          if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
          // if (Responsive.isMobile(context)) StorageDetails(),
        ],
      ),
    );
    // On Mobile means if the screen is less than 850 we dont want to show it
    // if (!Responsive.isMobile(context))
    //   Expanded(
    //     flex: 2,
    //     child: StorageDetails(),
    //   ),
  }

  Future<String?> predictPrice(var body) async {
    var client = new http.Client();
    var uri = Uri.parse("https://finodays-backend.ew.r.appspot.com/predict_immovable");
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonString = json.encode(body);
    try {
      var resp = await http.post(uri, headers: headers, body: jsonString);
      //var resp=await http.get(Uri.parse("http://192.168.1.101:5000"));
      if (resp.statusCode == 200) {
        print("DATA FETCHED SUCCESSFULLY");
        var result = json.decode(resp.body);
        print(result["prediction"]);
        return result["prediction"];
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return null;
    }
    return null;
  }

  //function from rflutter pkg to display alert
  _onBasicAlertPressed(context, resp) {
    Alert(context: context, title: "Predicted price", desc: resp).show();
  }

  Future<void> save(var body, String subject) async {
    var uri = Uri.parse("https://finodays-backend.ew.r.appspot.com/" + subject);
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonString = json.encode(body);
    try {
      var resp = await http.post(uri, headers: headers, body: jsonString);
      //var resp=await http.get(Uri.parse("http://192.168.1.101:5000"));
      if (resp.statusCode == 200) {
        print("DATA FETCHED SUCCESSFULLY");
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return null;
    }
    return null;
  }

  Future<String?> get(String subject) async {
    var uri = Uri.parse("https://finodays-backend.ew.r.appspot.com/" + subject);
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      var resp = await http.get(uri, headers: headers);
      //var resp=await http.get(Uri.parse("http://192.168.1.101:5000"));
      if (resp.statusCode == 200) {
        print("DATA FETCHED SUCCESSFULLY");
        var result = json.decode(resp.body);
        print(result);
        return result['response'];
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return null;
    }
    return null;
  }
}
