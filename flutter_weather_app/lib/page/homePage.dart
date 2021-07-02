import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_weather_app/widgets/appDrawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  var pageNum = 0;
  var _chosenValue;

  var _cities = [
    "Dhaka",
    "Toronto",
    "Rome",
    "Milan",
    "New York",
    "Delhi",
    "Beijing",
  ];
  String city = "dhaka";
  var temp;
  var tempMin;
  var tempMax;
  var feelsLike;
  var description;
  var weatherMain;
  var humidity;
  var icon;
  var windSpeed;
  Future getWeather() async {
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&units=imperial&appid=32900ed097d2bd08f9e5868a1735884b");

    http.Response response = await http.get(url);
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.tempMin = results['main']['temp_min'];
      this.tempMax = results['main']['temp_max'];
      this.feelsLike = results['main']['feels_like'];
      this.description = results['weather'][0]['description'];
      this.weatherMain = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.icon = results['weather'][0]['icon'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                temp != null
                    ? Container(
                        child: Text(
                          "$city".toUpperCase(),
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      )
                    :
                    // Container(
                    //   child: Text(
                    //     "Loading".toUpperCase(),
                    //     style: TextStyle(fontSize: 16, color: Colors.black),
                    //   ),
                    // )
                    Container(
                        alignment: Alignment.center,
                        width: 20,
                        height: 20,
                        //color: Colors.lightGreen,
                        child: new CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      )
              ],
            ),
          ],
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
                textTheme: TextTheme().apply(bodyColor: Colors.red),
                dividerColor: Colors.red,
                iconTheme: IconThemeData(color: Colors.black)),
            child: PopupMenuButton<int>(
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "Refresh",
                      style:
                          GoogleFonts.rubik(color: Colors.black, fontSize: 16),
                    )),
                PopupMenuItem<int>(
                    value: 1,
                    child: Text(
                      "Share",
                      style:
                          GoogleFonts.rubik(color: Colors.black, fontSize: 16),
                    )),
                PopupMenuItem<int>(
                    value: 2,
                    child: Text(
                      "Privacy Policy page",
                      style:
                          GoogleFonts.rubik(color: Colors.black, fontSize: 16),
                    )),
              ],
              onSelected: (item) => SelectedItem(context, item),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.black,
        color: Colors.white,
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: ListView(
          children: [
            Container(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    //color: Color(0xff222831),
                    color: Colors.white,
                    //height: size.height,
                    child: temp != null
                        ? Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    width: size.width * 0.4,
                                    color: Colors.white,
                                    height: 25,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Please select a city :",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Container(
                                    height: 65,
                                    width: size.width * 0.5,
                                    alignment: Alignment.topLeft,
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FormField<String>(
                                          builder:
                                              (FormFieldState<String> state) {
                                            return InputDecorator(
                                              decoration: InputDecoration(
                                                  // labelText: "Please select a city",
                                                  // labelStyle: TextStyle(color: Colors.black,fontSize: 22.0),
                                                  errorStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                  // hintText: 'Please select a city',
                                                  // hintStyle: TextStyle(color: Colors.black),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0))),
                                              isEmpty: _chosenValue == '',
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: _chosenValue,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  isDense: true,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _chosenValue = newValue;
                                                      city = _chosenValue;
                                                      getWeather();
                                                      state.didChange(newValue);
                                                    });
                                                  },
                                                  items: _cities
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: size.height * 0.4,
                                width: size.width,
                                color: Colors.white,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: size.height * 0.25,
                                      width: size.width * 0.9,
                                      decoration: BoxDecoration(
                                        color: Colors.indigo[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 20, 0, 0),
                                                // height: 200,
                                                width: 80,
                                                // color: Colors.redAccent,
                                                child: Column(
                                                  children: [
                                                    icon != null
                                                        ? Image(
                                                            image: NetworkImage(
                                                                "https://openweathermap.org/img/wn/$icon@2x.png",
                                                                scale: 0.5))
                                                        : CircularProgressIndicator()
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 30, 0, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .arrowDown,
                                                          size: 14,
                                                          color: Colors.white54,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: tempMin != null
                                                          ? Text(
                                                              ((tempMin - 32) *
                                                                          5 /
                                                                          9)
                                                                      .toStringAsFixed(
                                                                          0) +
                                                                  "\u00B0" +
                                                                  " C",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white54),
                                                            )
                                                          : FaIcon(
                                                              FontAwesomeIcons
                                                                  .spinner),
                                                    ),
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: FaIcon(
                                                            FontAwesomeIcons
                                                                .arrowUp,
                                                            size: 14,
                                                            color:
                                                                Colors.white54),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: tempMax != null
                                                          ? Text(
                                                              ((tempMax - 32) *
                                                                          5 /
                                                                          9)
                                                                      .toStringAsFixed(
                                                                          0) +
                                                                  "\u00B0" +
                                                                  " C",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white54),
                                                            )
                                                          : FaIcon(
                                                              FontAwesomeIcons
                                                                  .spinner),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 20, 20, 0),
                                                // color: Colors.yellowAccent,
                                                alignment: Alignment.bottomLeft,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      text: TextSpan(
                                                        style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontSize: 80,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        children: [
                                                          temp != null
                                                              ? TextSpan(
                                                                  text: ((temp -
                                                                              32) *
                                                                          5 /
                                                                          9)
                                                                      .toStringAsFixed(
                                                                          0),
                                                                )
                                                              : TextSpan(
                                                                  style: GoogleFonts.rubik(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10),
                                                                  children: [
                                                                      TextSpan(
                                                                        text:
                                                                            "Loading",
                                                                      )
                                                                    ]),
                                                          WidgetSpan(
                                                            child: Transform
                                                                .translate(
                                                              offset:
                                                                  const Offset(
                                                                      0.0,
                                                                      -55.0),
                                                              child: Text(
                                                                "\u00B0" + " C",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      "Feels Like: " +
                                                          ((feelsLike - 32) *
                                                                  5 /
                                                                  9)
                                                              .toStringAsFixed(
                                                                  0) +
                                                          "\u00B0" +
                                                          " C",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.white54),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //------------------------2nd Column--------------------------------

                              Container(
                                height: size.height * 0.3,
                                width: size.width * 0.95,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xff222831),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      size.width * 0.016,
                                      size.width * 0.02,
                                      size.width * 0.02,
                                      0),
                                  child: ListView(
                                    children: [
                                      ListTile(
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.thermostat_outlined,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                        title: Text(
                                          "Temperature",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white),
                                        ),
                                        // subtitle: Text(
                                        //   temp != null ? temp.toString() + "\u00B0" : "Loading",
                                        //   style: TextStyle(
                                        //       fontSize: 18.0, fontWeight: FontWeight.w300),
                                        // ),
                                        trailing: temp != null
                                            ? Text(
                                                ((temp - 32) * 5 / 9)
                                                        .toStringAsFixed(0) +
                                                    "\u00B0" +
                                                    " C " +
                                                    ' / ' +
                                                    temp.toStringAsFixed(0) +
                                                    "\u00B0" +
                                                    " F",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              )
                                            : FaIcon(FontAwesomeIcons.spinner),
                                      ),
                                      ListTile(
                                        leading: Container(
                                          // color: Colors.red,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              icon != null
                                                  ? Image(
                                                      image: NetworkImage(
                                                          "https://openweathermap.org/img/wn/$icon@2x.png",
                                                          scale: 3))
                                                  : FaIcon(
                                                      FontAwesomeIcons.spinner)
                                            ],
                                          ),
                                        ),
                                        title: Text(
                                          "Weather",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white),
                                        ),
                                        trailing: description != null
                                            ? Text(
                                                description
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              )
                                            : FaIcon(FontAwesomeIcons.spinner),
                                      ),
                                      ListTile(
                                        leading: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.wb_sunny,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                        title: Text(
                                          "Humidity",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white),
                                        ),
                                        trailing: humidity != null
                                            ? Text(
                                                humidity
                                                        .toString()
                                                        .toUpperCase() +
                                                    " %",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              )
                                            : FaIcon(FontAwesomeIcons.spinner),
                                      ),
                                      ListTile(
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.waves_outlined,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                        title: Text(
                                          "WindSpeed",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white),
                                        ),
                                        trailing: windSpeed != null
                                            ? Text(
                                                windSpeed
                                                        .toString()
                                                        .toUpperCase() +
                                                    " MPH",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              )
                                            : FaIcon(FontAwesomeIcons.spinner),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  width: size.width,
                                  height: size.height * 0.8,
                                  child: Text(
                                    "Please Wait",
                                    style: GoogleFonts.lato(fontSize: 20),
                                  )),
                              Container(
                                alignment: Alignment.center,
                                width: size.width,
                                height: size.height,
                                child: new CircularProgressIndicator(
                                  strokeWidth: 1,
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }

  // ignore: non_constant_identifier_names
  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        print("Refresh Clicked");
        getWeather();
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => SettingPage()));
        break;
      case 1:
        print("Share Clicked");
        break;
      case 2:
        print("Privacy Clicked");
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => LoginPage()),
        //     (route) => false);
        break;
    }
  }

  Future<void> _refresh() {
    return getWeather();
  }
}
