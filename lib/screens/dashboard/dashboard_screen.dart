import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/item_card.dart';
import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/recent_orders.dart';
import 'components/storage_details.dart';

int predictionItems = 2;

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class Data {
  List<bool> isChecked = List.filled(predictionItems, false);
  List<String> predictions = List.filled(predictionItems, "");
}

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedDrawerIndex = 0;
  String name = "ГОСУДАРСТВЕННОЕ КАЗЕННОЕ УЧРЕЖДЕНИЕ ГОРОДА МОСКВЫ «ИНФОРМАЦИОННЫЙ ГОРОД";

  //Let's update the selectedDrawerItemIndex the close the drawer
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    //we close the drawer
    Navigator.of(context).pop();
  }
  _getDrawerFragment(int pos) {
    switch (pos) {
      case 0:
        return FutureBuilder<List<Map<String, String>>>(
            future: getPredictions(name),
            builder:(BuildContext context,AsyncSnapshot <List<Map<String, String>>> snapshot){
              if(snapshot.hasData){
                var data = snapshot==null? [] : snapshot.data!;

                return GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: defaultPadding,
                      mainAxisSpacing: defaultPadding,
                      // childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      var prediction = data[index];
                      return ItemCard(
                        heading: prediction['name'],
                        subheading: prediction['price'],
                        supportingText: prediction['date'],
                        cardImage: NetworkImage(
                            'https://source.unsplash.com/random/800x600?house'),
                      );

                    }
                );
              }else {
                return Center(child:CircularProgressIndicator());
              }
            });


      case 1:
        return RecentOrders(
          customer_tin: 7724750113,
        );

      default:
        return new Text("Error");
    }
  }
  late Widget generalView = Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          children: [
            //MyFiles(callback: callback, data: data,),

            // _getDrawerFragment(_selectedDrawerIndex),

            InkWell(
                child: SizedBox(height: defaultPadding),
              onTap: () {
                  _selectedDrawerIndex = _selectedDrawerIndex==0? 1 : 0;
                  _onSelectItem(_selectedDrawerIndex);
                  },
            ),
            _getDrawerFragment(_selectedDrawerIndex),

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
  late Widget currentPage = generalView;
  late Data data;

  @override
  void initState() {
    super.initState();
    data = Data();
  }

  void callback(Widget nextPage, Data data) {
    setState(() {
      this.currentPage = nextPage;
      this.data = data;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: GestureDetector(
        onDoubleTap: () {
          print("SUKA");
          _selectedDrawerIndex = _selectedDrawerIndex==0? 1 : 0;
          _onSelectItem(_selectedDrawerIndex);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              GestureDetector(
                child: SizedBox(height: defaultPadding + 100),
                onDoubleTap: () {

                },
              ),
              generalView,
            ],
          ),
        ),
      ),
    );
  }
  Future<List<Map<String, String>>> getPredictions(String name) async {
    List<Map<String, String>> body = [
      {
        "name": name,
      }
    ];
    var uri = Uri.parse("http://127.0.0.1:5000/predictions");
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      // var resp = await http.get(uri, headers: headers);
      // var  httpClient  =  new  Client();
      var resp = await http.post(uri, headers: headers, body: json.encode(body));

      print("DATA LOG 1");
      // var  response  =  await http.get(uri);
      print("DATA LOG 2");

      // var  response  =  await request.close();


      //var resp=await http.get(Uri.parse("http://192.168.1.101:5000"));
      if (resp.statusCode == 200) {
        print("DATA FETCHED SUCCESSFULLY");
        // var result = json.decode(resp.body);
        var result = json.decode(resp.body);

        return  result;
        print("********");
        // print(result);
        print("********");

        // return result['response_msg'];
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return [];
    }
    return [];
  }

  Future<String?> getContract(String tin) async {
    List<Map<String, String>> body = [
      {
        "customer_tin": tin,
      }
    ];
    var uri = Uri.parse("http://127.0.0.1:5000/contracts");
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      // var resp = await http.get(uri, headers: headers);
      // var  httpClient  =  new  Client();
      var resp = await http.post(uri, headers: headers, body: json.encode(body));

      print("DATA LOG 1");
      // var  response  =  await http.get(uri);
      print("DATA LOG 2");

      // var  response  =  await request.close();


      //var resp=await http.get(Uri.parse("http://192.168.1.101:5000"));
      if (resp.statusCode == 200) {
        print("DATA FETCHED SUCCESSFULLY");
        // var result = json.decode(resp.body);
        var result = json.decode(resp.body);

        return  resp.body;
        print("********");
        // print(result);
        print("********");

        // return result['response_msg'];
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return null;
    }
    return null;
  }

}
