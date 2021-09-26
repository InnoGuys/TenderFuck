import 'package:admin/models/MyFiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FileInfoCard extends StatefulWidget {
  FileInfoCard({
    Key? key,
    required this.info,
    required this.image,
    required this.data,
    required this.index,

  }) : super(key: key);

  final CloudStorageInfo info;
  final DecorationImage image;
  final int index;
  Data data;

  @override
  _FileInfoCardState createState() => _FileInfoCardState();
}

class _FileInfoCardState extends State<FileInfoCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        image: this.widget.image,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(defaultPadding * 0.6),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: this.widget.info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: this.widget.data.predictions[this.widget.index].isNotEmpty? SvgPicture.asset(
                  this.widget.info.svgSrc!,
                  color: this.widget.info.color,
                ) : Container(),
              ),
              Icon(Icons.more_vert, color: dividerColor)
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
            children: [
              FutureBuilder<String?>(
                  future: this.widget.index==0? get("get_immovable") : get("get_car"),
                  builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if(snapshot.hasData && snapshot.data!.length>2){
                      final response = snapshot.data;
                      print(response);
                      print("PRIIICE");
                      var body = json.decode(response!);
                      print(body);

                      String prediction = body[0]['price'];
                      print(prediction);
                      this.widget.data.predictions[this.widget.index] = double.parse(
                          prediction).toStringAsFixed(2);
                      return Text(
                        this.widget.data.predictions[this.widget.index].isNotEmpty ? double.parse(
                            this.widget.data.predictions[this.widget.index]).toStringAsFixed(2) + "\$" : prediction == null? "" : double.parse(
                            prediction).toStringAsFixed(2) + "\$",
                        style: TextStyle(fontSize: 40),
                      );
                    }else{
                      return Text(
                        "",
                        style: TextStyle(fontSize: 40),
                      );
                    }




                  }
              ),
            ],
          ),

          Spacer(),
          Text(
            this.widget.info.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // ProgressLine(
          //   color: info.color,
          //   percentage: info.percentage,
          // ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${this.widget.info.subtitle}",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: hintColor),
              ),
              Text(
                this.widget.info.rightBottomText!,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: sideMenuTextColor),
              ),
            ],
          )
        ],
      ),
    );
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

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
