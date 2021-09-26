import 'dart:convert';

import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../../constants.dart';
import '../dashboard_screen.dart';
import 'beautiful_textfield.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import 'header.dart';

import 'recent_orders.dart';
import 'package:http/http.dart' as http;


import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:html' as html;
import 'package:path/path.dart' as path;

class Cars extends StatefulWidget {
  final Function callback;
  Data data;
  Cars({
    Key? key,
    required this.callback,
    required this.data,
  }) : super(key: key);

  @override
  _CarsState createState() => _CarsState();
}

class _CarsState extends State<Cars> {
  Map<String, String> parameters = {
    "symboling": "",
    "CarName": "",
    "fueltype": "",
    "aspiration": "",
    "doornumber": "",
    "carbody": "",
    "drivewheel": "",
    "enginelocation": "",
    "wheelbase": "",
    "carlength": "",
    "carwidth": "",
    "carheight": "",
    "curbweight": "",
    "enginetype": "",
    "cylindernumber": "",
    "enginesize": "",
    "fuelsystem": "",
    "boreratio": "",
    "stroke": "",
    "compressionratio": "",
    "horsepower": "",
    "peakrpm": "",
    "citympg": "",
    "highwaympg": "",
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
  void initState() {
    super.initState();
    values = List.filled(parameters.length, "");
  }

  @override
  Widget build(BuildContext context) {
    print("LALALALALA");

    return Column(children: [
      FutureBuilder<String?>(
          future: get("get_car"),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if(snapshot.hasData){
              // data loaded:
              final response = snapshot.data;
              print(response);
              for(int i=0;i<parameters.keys.length;i++){
                if(response!.length>2){
                  var body = json.decode(response!);
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
            // ImagePickerWeb.getImageInfo.then((MediaInfo mediaInfo) async {
            //   String mimeType = mime(path.basename(mediaInfo.fileName));
            //   await uploadImageToServer(File(mediaInfo.fileName));
            //     uploadFile(mediaInfo, 'images', mediaInfo.fileName);
            //   };



            // html.File imageFile = await ImagePickerWeb.getImage(outputType: ImageType.file);

            // if (imageFile != null) {
            //   debugPrint(imageFile.name.toString());
            // }
            List<Map<String, String>> body = [
              {
                "symboling": "",
                "CarName": "",
                "fueltype": "",
                "aspiration": "",
                "doornumber": "",
                "carbody": "",
                "drivewheel": "",
                "enginelocation": "",
                "wheelbase": "",
                "carlength": "",
                "carwidth": "",
                "carheight": "",
                "curbweight": "",
                "enginetype": "",
                "cylindernumber": "",
                "enginesize": "",
                "fuelsystem": "",
                "boreratio": "",
                "stroke": "",
                "compressionratio": "",
                "horsepower": "",
                "peakrpm": "",
                "citympg": "",
                "highwaympg": "",
              }
            ];
            for (int i = 0; i < parameters.keys.length; i++) {
              body[0][body[0].keys.elementAt(i)] = parameters.values.elementAt(i);
            }
            print(body[0]);

            var picked = await FilePicker.platform.pickFiles(allowMultiple: false);
            String resp="";
            if (picked != null) {
              print(picked.files.first.name);
              // String path = picked.files.single.path==null? "" : picked.files.single.path.toString();
              print("Picked");
              // print(path);
                uploadImageToServer(http.MultipartFile.fromBytes('image', picked.files.single.bytes!.toList(), filename: picked.files.single.name), body).then((val2) {
                  resp = val2 != null? val2 : "";
                });
              // predictPrice(body);
              print("AAAOOOAAAA");
              print(resp);

            }

            this.widget.data.predictions[1] = resp;
            this.widget.callback(generalView, this.widget.data);
            // this.widget.data.predictions[1] = "";



            body[0]['price'] = resp;

            save(body, "save_car");


            // _onBasicAlertPressed(context, resp);
            // print(resp);
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
    var uri = Uri.parse("https://finodays-server.herokuapp.com/predict_car");
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

  Future<String?> uploadImageToServer(http.MultipartFile imageFile, var body)async
  {
    print("attempting to connecto server......");
    // var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // var length = await imageFile.length();
    // print(length);

    var uri = Uri.parse('https://finodays-backend.ew.r.appspot.com/car_image');
    print("connection established.");
    var request = new http.MultipartRequest("POST", uri);
    // var multipartFile = new http.MultipartFile('image', imageFile, length,
    //     filename: path.basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(imageFile);
    request.fields['text_data'] = json.encode(body);
    http.Response resp = await http.Response.fromStream(await request.send());
    if (resp.statusCode == 200) {
      print("DATA FETCHED SUCCESSFULLY");
      var result = json.decode(resp.body);
      print(result);
      return result['prediction'];
    }
    return null;
  }
}
