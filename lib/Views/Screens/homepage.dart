import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_progress_bar/curved_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_pr/Components/Helpers/apihelper.dart';
import 'package:weather_app_pr/Model/api_model.dart';

import '../../Provider/platformprovider.dart';
import '../../Provider/theamprovider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();
  String searchData = "";
  Connectivity connectivity = Connectivity();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Api_Helper.api.fetchWeather(search: searchData);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder(
        stream: connectivity.onConnectivityChanged,
        builder: (
          BuildContext context,
          AsyncSnapshot<ConnectivityResult> snapshot,
        ) {
          return (snapshot.data == ConnectivityResult.mobile ||
                  snapshot.data == ConnectivityResult.wifi)
              ? Column(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: Api_Helper.api.fetchWeather(search: searchData),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else if (snapshot.hasData) {
                            Weather_Model? apimodel = snapshot.data;
                            return Stack(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "lib/Components/Assets/blue-sky-clouds-aesthetic-background.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Container(
                                        height: h * .1,
                                        padding: const EdgeInsets.all(10),
                                        child: TextFormField(
                                          onEditingComplete: () {
                                            setState(() {
                                              searchData = search.text;
                                            });
                                            search.clear();
                                          },
                                          controller: search,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  Colors.white.withOpacity(.5),
                                              suffix: IconButton(
                                                icon: const Icon(
                                                  Icons.search,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    searchData = search.text;
                                                  });
                                                  search.clear();
                                                },
                                              ),
                                              hintText: "Search Hear........"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 70,
                                      ),
                                      SizedBox(
                                        height: h * .16,
                                        width: w * .9,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${apimodel?.location['name']}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 40,
                                                  ),
                                                ),
                                                Text(
                                                  "${apimodel?.location['region']},${apimodel?.location['country']}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  "${apimodel?.location['localtime']}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Provider.of<Themeprovider>(
                                                        context,
                                                        listen: false)
                                                    .changetheme();
                                              },
                                              icon: Icon(
                                                (Provider.of<Themeprovider>(
                                                                context,
                                                                listen: false)
                                                            .theme
                                                            .isdark ==
                                                        false)
                                                    ? Icons.sunny
                                                    : Icons.sunny_snowing,
                                              ),
                                            ),
                                            Switch(
                                              value:
                                                  Provider.of<PlatformProvider>(
                                                          context,
                                                          listen: true)
                                                      .changePlatform
                                                      .isios,
                                              onChanged: (val) {
                                                Provider.of<PlatformProvider>(
                                                        context,
                                                        listen: false)
                                                    .ConvertPlatform();
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 70,
                                      ),
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          height: h * .14,
                                          width: w * .9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff3383cc)
                                                .withOpacity(.4),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "${apimodel?.current['temp_c']}°",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 50,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      const Text(
                                                        "",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 25),
                                                      ),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        child: Text(
                                                          "${apimodel?.current['condition']['text']} ",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 19),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Container(
                                          height: h * .25,
                                          width: w * .9,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: ListView.builder(
                                            itemCount: 24,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) =>
                                                Container(
                                              height: h * .25,
                                              width: w * .3,
                                              margin: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff3383cc)
                                                    .withOpacity(.4),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "$index:00",
                                                    style: const TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  Container(
                                                    height: 100,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            "http:${apimodel?.forecast['forecastday'][0]['hour'][index]['condition']['icon']}"),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${apimodel?.forecast['forecastday'][0]['hour'][index]['temp_c']}°",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            height: h * .17,
                                            width: w * .4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: const Color(0xff3383cc)
                                                  .withOpacity(.4),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.thermostat,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                const Text(
                                                  "Feels like",
                                                  style: TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  "${apimodel?.current['temp_c']}°",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            height: h * .17,
                                            width: w * .4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: const Color(0xff3383cc)
                                                  .withOpacity(.4),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.air,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                const Text(
                                                  "NNW wind",
                                                  style: TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${apimodel?.current['wind_kph']}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Text(
                                                      "  Km/h",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            height: h * .17,
                                            width: w * .4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: const Color(0xff3383cc)
                                                  .withOpacity(.4),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.water_drop_outlined,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                const Text(
                                                  "Humidity",
                                                  style: TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${apimodel?.current['humidity']}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Text(
                                                      "  % ",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            height: h * .17,
                                            width: w * .4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: const Color(0xff3383cc)
                                                  .withOpacity(.4),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.sunny,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                const Text(
                                                  "UV",
                                                  style: TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${apimodel?.current['uv']}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Text(
                                                      "  Strong ",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            height: h * .17,
                                            width: w * .4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: const Color(0xff3383cc)
                                                  .withOpacity(.4),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.visibility,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                const Text(
                                                  "Visibility",
                                                  style: TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${apimodel?.current['vis_km']}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Text(
                                                      "  Km ",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            height: h * .17,
                                            width: w * .4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: const Color(0xff3383cc)
                                                  .withOpacity(.4),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.compress_sharp,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                const Text(
                                                  "Air pressure",
                                                  style: TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${apimodel?.current['pressure_mb']}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Text(
                                                      "  hPa ",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          height: h * .25,
                                          width: w * .9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff3383cc)
                                                .withOpacity(.4),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Icon(
                                                    Icons.sunny,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  Icon(
                                                    Icons.sunny_snowing,
                                                    color: Colors.white,
                                                    size: 30,
                                                  )
                                                ],
                                              ),
                                              const CurvedLinearProgressIndicator(
                                                value: 0.4,
                                                strokeWidth: 8,
                                                backgroundColor: Colors.white,
                                                color: Colors.blueAccent,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      const Text(
                                                        "Sunrise",
                                                        style: TextStyle(
                                                          color: Colors.white54,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${apimodel?.forecast['forecastday'][0]['astro']['sunrise']}",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      const Text(
                                                        "Sunset",
                                                        style: TextStyle(
                                                          color: Colors.white54,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${apimodel?.forecast['forecastday'][0]['astro']['sunset']}",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Container(
                    height: 450,
                    width: 500,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage("lib/Components/Assets/1.gif"),
                            fit: BoxFit.cover)),
                  ),
                );
        },
      ),
    );
  }
}
