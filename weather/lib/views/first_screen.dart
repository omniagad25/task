import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int temperature=0;
  String location='SEARCH NOW';
  int woeid=2487956;
  String weather='clear';
  var searchApiUrl='https://www.metaweather.com/api/location/search/?query=';
  var locationApiUrl='https://www.metaweather.com/api/location/';
  void fetchSearch(String input) async {
    var searchResult= await http.get(Uri.parse(searchApiUrl + input));
    var result= json.decode(searchResult.body)[0];

    setState(() {
      location=result["title"];
      woeid=result["woeid"];
    });
  }
  void fetchLocation() async{
    var locationResult=await http.get(Uri.parse(locationApiUrl+woeid.toString()));
    var result=json.decode(locationResult.body);
    var consolidated_weather=result["consolidated_weather"];
    var data= consolidated_weather[0];
    setState(() {
      temperature=data["the_temp"].round();
      weather=data["weather_state_name"].replaceAll(' ','').toLowerCase();
    });
  }
  void onSubmit(String input){
    fetchSearch(input);
    fetchLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Weather Today'),
          backgroundColor: Colors.blue,
          shadowColor: Color(0xFFffffff),

        ),
      backgroundColor: Colors.blue,
      body:
      SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/weather.jpg'),
                fit: BoxFit.cover,
              )
          ),



          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  
                  Center(
                    child: Text(temperature.toString()+ ' °C',
                    style: TextStyle(color: Colors.white,fontSize: 60,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                    ),
                  ),

                  Center(
                    child: Text(location,
                      style: TextStyle(color: Colors.white,fontSize: 50,
                        shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 300,
                    child: TextField(
                      onSubmitted: (String input){
                        onSubmit(input);
                      },
                      style: TextStyle(color: Colors.white,fontSize: 20,),
                      decoration: InputDecoration(
                        hintText: 'Search another location..',

                          prefixIcon: Icon(Icons.search,color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white, fontSize: 18)
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
