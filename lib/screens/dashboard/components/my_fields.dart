import 'dart:convert';

import 'package:admin/models/MyFiles.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/recent_orders.dart';
import 'package:flutter/material.dart';
import 'package:photofilters/photofilters.dart';

import '../../../constants.dart';
import '../dashboard_screen.dart';
import 'cars.dart';
import 'file_info_card.dart';
import 'immovables.dart';
import 'package:http/http.dart' as http;


class MyFiles extends StatelessWidget {
  final Function callback;
  Data data;
  MyFiles({
    Key? key,
    required this.callback,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Оценка",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            // ElevatedButton.icon(
            //   style: TextButton.styleFrom(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: defaultPadding * 1.5,
            //       vertical:
            //           defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
            //     ),
            //   ),
            //   onPressed: () {},
            //   icon: Icon(Icons.add),
            //   label: Text("Оценить"),
            // ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
            callback: callback,
            data: data,
          ),
          tablet: FileInfoCardGridView(callback: callback, data: data,),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
            callback: callback,
            data: data,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatefulWidget {
  FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.callback,
    required this.data,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  Data data;

  Function callback;

  @override
  _FileInfoCardGridViewState createState() => _FileInfoCardGridViewState(
    crossAxisCount: crossAxisCount,
    childAspectRatio: childAspectRatio,
    data: data,
  );
}

class _FileInfoCardGridViewState extends State<FileInfoCardGridView> {
  _FileInfoCardGridViewState({
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.data,
});

  final int crossAxisCount;
  final double childAspectRatio;

  Data data;
  String name="";

  late Widget generalView = Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          children: [
            MyFiles(callback: this.widget.callback, data: data,),
            SizedBox(height: defaultPadding),
            // RecentOrders(),
            if (Responsive.isMobile(context))
              SizedBox(height: defaultPadding),
            // if (Responsive.isMobile(context)) StorageDetails(),
          ],
        ),
      ),
      if (!Responsive.isMobile(context))
        SizedBox(width: defaultPadding),
      // On Mobile means if the screen is less than 850 we dont want to show it
      // if (!Responsive.isMobile(context))
      //   Expanded(
      //     flex: 2,
      //     child: StorageDetails(),
      //   ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: demoMyFiles.length+1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          if(index == 0 || index == 1){
            return Container(
                child: Stack(
                    children: <Widget>[
                      FileInfoCard(
                        info: demoMyFiles[index],
                        data: data,
                        index: index,
                        image: DecorationImage(
                          image: index == 0 ? AssetImage(
                              "assets/images/house1.jpg") : AssetImage(
                              "assets/images/car1.jpg"),
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.dstATop),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                data.isChecked[index] = !data.isChecked[index];
                                this.widget.callback(index == 0
                                    ? Immovables(
                                  callback: this.widget.callback, data: data,)
                                    : Cars(
                                  callback: this.widget.callback, data: data,),
                                    data);
                              });
                            },
                          ),
                        ),
                      ),
                    ]
                )
            );
          }else{
            double total_price=0;
            data.predictions.forEach((element) {
              print("Prices "+element);
              if(element!=null && element.isNotEmpty)
                total_price+=double.parse(element);
            });
            if(total_price!=0){
              return Center(
                child: Container(
                    child: Column(
                      children: [
                        Spacer(),
                        Text(
                          "Итого:",
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          total_price.toStringAsFixed(2)+"\$",
                          style: TextStyle(fontSize: 20),
                        ),
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
                        labelText: "Имя владельца",
                      ),
                      onChanged: (val) {
                        name = val;
                      },
                    ),
                        SizedBox(height: 20,),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20), padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding * 1.5,
                            vertical:
                            defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                          ),),
                          onPressed: () async {
                            List<Map<String, String>> body = [
                              {
                                "name": name,
                                "price": total_price.toStringAsFixed(2)+"\$",
                              }
                            ];
                            save_prediction(body);

                            this.widget.data.predictions[0] = "";
                            this.widget.data.predictions[1] = "";

                            // data.predictions=List.filled(2, "");
                            // data.isChecked=List.filled(2, false);

                            this.widget.callback(generalView, this.widget.data);

                            print("Finished saving");
                          },
                          icon: Icon(Icons.add, size: 18),
                          label: Text('Сохранить'),
                        ),
                        Spacer(),
                      ],
                    )
                ),
              );
            }else{
              return Center(
                child: Container(
                    child: Column(
                      children: [
                        Spacer(),
                        Text(
                          "Оцените имущество",
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          "Кликнув на иконку слева",
                          style: TextStyle(fontSize: 20),
                        ),

                        Spacer(),
                      ],
                    )
                ),
              );
            }

          }

        }

    );
  }
  Future<String?> save_prediction(var body) async {
    var uri = Uri.parse("https://finodays-backend.ew.r.appspot.com/save_prediction");
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonString = json.encode(body);
    try {
      var resp = await http.post(uri, headers: headers, body: jsonString);
      //var resp=await http.get(Uri.parse("http://192.168.1.101:5000"));
      if (resp.statusCode == 200) {
        print("DATA FETCHED SUCCESSFULLY");
        return 'ok';
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return null;
    }
    return null;
  }
}

