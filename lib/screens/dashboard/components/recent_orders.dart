import 'dart:io';
import 'dart:convert' show Utf8Decoder;
import 'package:admin/models/RecentOrder.dart';
import 'package:admin/screens/dashboard/components/order_item.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class RecentOrders extends StatelessWidget {
  int customer_tin=7724750113;
  RecentOrders({
    Key? key,
    required this.customer_tin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "История закупок",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 10,
          ),

          FutureBuilder<String?>(
              future: getContract(customer_tin.toString()),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                
                print("BLEEEEEEEEEEEEEEET");
                if (snapshot.hasData) {
                  String data = snapshot==null? " " : snapshot.data!;
                  var data_json = json.decode(data);
                  print(data_json.toString() + "\n\n\n");
                  // data_json.keys.forEach((key){
                  //   print(key);
                  // });
                  var keys = data_json.keys.toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: null == data_json.keys ? 0 : data_json.keys.length,
                    itemBuilder: (context, index) {
                      var item = data_json[keys[index]];
                      // var scu = json.decode(item["СТЕ"]);
                      // print(scu.toString());
                      // print(item["СТЕ"]);
                      String scu_id = item["СТЕ"].toString().substring(item["СТЕ"].toString().indexOf(":")+1, item["СТЕ"].toString().indexOf(";"));

                      // getCTE(scu_id).then((value) {
                      //
                      // });
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                        child: OrderItem(
                          orderNumber: item['НомерКонтракта'],
                          orderDate: item['ДатаЗаключенияКонтракта'],
                          provider: item['НаименованиеПоставщика'],
                          price: item['ЦенаКонтракта'],
                          item: scu_id,
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                  );

                  // final response = snapshot.data;
                  // print("/////////////");
                  // print(response);
                  // print("/////////////");
                  // final List t = json.decode(response!);
                  // print(t);
                  // final List<RecentOrder> recentsList = t.map((item) => RecentOrder.fromJson(item)).toList();
                  // print(t);
                  //
                  // return SizedBox(
                  //       width: double.infinity,
                  //       child: DataTable2(
                  //         columnSpacing: defaultPadding,
                  //         minWidth: 600,
                  //         columns: [
                  //           DataColumn(
                  //             label: Text("Наименование товара"),
                  //           ),
                  //           DataColumn(
                  //             label: Text("Дата"),
                  //           ),
                  //           // DataColumn(
                  //           //   label: Text("Используемая модель"),
                  //           // ),
                  //           DataColumn(
                  //             label: Text("Стоимость"),
                  //           ),
                  //         ],
                  //         rows: List.generate(
                  //           // recentsList.length,
                  //           // (index) => recentOrdersDataRow(recentsList[index]),
                  //           demoRecentOrders.length,
                  //               (index) => recentOrdersDataRow(demoRecentOrders[index]),
                  //         ),
                  //       ));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),


          // ListView.separated(
          //   itemCount: 10,
          //   itemBuilder: (context, index) {
          //     return OrderItem();
          //   },
          //   separatorBuilder: (context, index) {
          //     return Divider();
          //   },
          // )


          
        ],
      ),
    );
  }

  Future<String?> getCTE(String id) async {
    List<Map<String, String>> body = [
      {
        "ID_CTE": id,
      }
    ];
    var uri = Uri.parse("http://127.0.0.1:5000/scu");
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

  Future<String?> get(String subject) async {
    var uri = Uri.parse("http://127.0.0.1:8000/api/contracts" + subject);
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      // var resp = await http.get(uri, headers: headers);
      var  httpClient  =  new  HttpClient();
      print("DATA LOG 1");
      var  request  =  await httpClient.getUrl(uri);
      print("DATA LOG 2");

      var  response  =  await request.close();

      //var resp=await http.get(Uri.parse("http://192.168.1.101:5000"));
      if (response.statusCode == 200) {
        print("DATA FETCHED SUCCESSFULLY");
        // var result = json.decode(resp.body);
        var  responseBody  =  await response.transform(Utf8Decoder()).join();
        return  responseBody;
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

DataRow recentOrdersDataRow(RecentOrder fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(defaultPadding * 0.4),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: SvgPicture.asset(
                fileInfo.icon!,
                color: Colors.green,
              ),
            ),
            // SvgPicture.asset(
            //   fileInfo.icon!,
            //   height: 30,
            //   width: 30,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.name!),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.date!)),
      DataCell(Text(fileInfo.price!)),
    ],
  );
}
