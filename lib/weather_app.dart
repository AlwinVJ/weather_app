import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/consts/colors.dart';
import 'package:weather_app/consts/images.dart';
import 'package:weather_app/consts/strings.dart';
import 'package:weather_app/controllers/main_controller.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/hourly_weather_model.dart';
import 'package:weather_app/services/api_services.dart';
import 'package:weather_app/utils/cust_theme.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    var date = DateFormat("yMMMMd").format(DateTime.now());
    var theme = Theme.of(context);
    var controller = Get.put(MainController());
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0,
              // centerTitle: true,
              title: Text(
                "Your Weather App",
                style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                Obx(
                  () => IconButton(
                      onPressed: () {
                        controller.changeTheme();
                      },
                      icon: Icon(
                          controller.isDark.value
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: theme.iconTheme.color)),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.iconTheme.color,
                    ))
              ]),
          body: Obx(() => controller.isloaded.value == true
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: FutureBuilder(
                      future: controller.currentWeatherData,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          CurrentWeatherData data = snapshot.data;
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                date.text
                                    .color(theme.primaryColor)
                                    .size(20)
                                    .fontFamily("poppins_semibold")
                                    .make(),
                                10.heightBox,
                                "${data.name}"
                                    .text
                                    .color(theme.primaryColor)
                                    .fontFamily("poppins_bold")
                                    .size(32)
                                    .letterSpacing(3)
                                    .make(),
                                10.heightBox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'weather/${data.weather![0].icon}.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "${data.main!.temp}",
                                          style: TextStyle(
                                              color: theme.primaryColor,
                                              fontSize: 64,
                                              fontFamily: 'poppins')),
                                      TextSpan(
                                          text: ' ${data.weather![0].main}',
                                          style: TextStyle(
                                              color: theme.primaryColor,
                                              fontSize: 20,
                                              fontFamily: 'poppins_bold'))
                                    ]))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.expand_less_rounded,
                                        color: theme.iconTheme.color,
                                      ),
                                      label: "${data.main!.tempMax}$degree"
                                          .text
                                          .color(theme.primaryColor)
                                          .size(16)
                                          .make(),
                                    ),
                                    TextButton.icon(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.expand_more_rounded,
                                        color: theme.iconTheme.color,
                                      ),
                                      label: "${data.main!.tempMin}$degree"
                                          .text
                                          .color(theme.primaryColor)
                                          .size(16)
                                          .make(),
                                    ),
                                  ],
                                ),
                                10.heightBox,
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: List.generate(3, (index) {
                                      var iconList = [
                                        clouds,
                                        humidity,
                                        windspeed
                                      ];
                                      var values = [
                                        '${data.clouds!.all}',
                                        '${data.main!.humidity}%',
                                        '${data.wind!.speed} km/h'
                                      ];
                                      return Column(
                                        children: [
                                          Image.asset(
                                            iconList[index],
                                            width: 60,
                                            height: 60,
                                          )
                                              .box
                                              .gray200
                                              .padding(const EdgeInsets.all(8))
                                              .roundedSM
                                              .make(),
                                          10.heightBox,
                                          values[index].text.gray400.make()
                                        ],
                                      );
                                    })),
                                10.heightBox,
                                Divider(
                                  color: theme.dividerColor,
                                  height: 0.1,
                                  thickness: 0.1,
                                ),
                                10.heightBox,
                                FutureBuilder(
                                  future: controller.hourlyWeatherData,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      HourlyWeatherData hourlyData =
                                          snapshot.data;
                                      return SizedBox(
                                          height: 150,
                                          child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  hourlyData.list!.length > 6
                                                      ? 6
                                                      : hourlyData.list!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                var time = DateFormat.jm()
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            hourlyData
                                                                    .list![
                                                                        index]
                                                                    .dt!
                                                                    .toInt() *
                                                                1000));
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  decoration: BoxDecoration(
                                                      color: cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      time.text.gray800.make(),
                                                      Image.asset(
                                                        'weather/${hourlyData.list![index].weather![0].icon}.png',
                                                        width: 80,
                                                      ),
                                                      '${hourlyData.list![index].main!.temp}$degree'
                                                          .text
                                                          .white
                                                          .make(),
                                                    ],
                                                  ),
                                                );
                                              }));
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                                10.heightBox,
                                Divider(
                                  color: theme.dividerColor,
                                  thickness: 0.1,
                                  height: 0.1,
                                ),
                                10.heightBox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    'Next 7 Days'
                                        .text
                                        .color(
                                            theme.primaryColor.withOpacity(0.7))
                                        .semiBold
                                        .size(16)
                                        .make(),
                                    TextButton(
                                        onPressed: () {},
                                        child: 'View All'.text.make())
                                  ],
                                ),
                                FutureBuilder(
                                    future: controller.hourlyWeatherData,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 7,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var day = DateFormat("EEEE").format(
                                                DateTime.now().add(
                                                    Duration(days: index + 1)));
                                            return Card(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: day.text.semiBold
                                                            .color(theme
                                                                .primaryColor)
                                                            .make()),
                                                    Expanded(
                                                      child: TextButton.icon(
                                                          onPressed: null,
                                                          icon: Image.asset(
                                                              "assets/weather/50n.png",
                                                              width: 40),
                                                          label: "26$degree"
                                                              .text
                                                              .size(16)
                                                              .color(theme
                                                                  .primaryColor)
                                                              .make()),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  "37$degree /",
                                                              style: TextStyle(
                                                                color: theme
                                                                    .primaryColor,
                                                                fontFamily:
                                                                    "poppins",
                                                                fontSize: 16,
                                                              )),
                                                          TextSpan(
                                                              text:
                                                                  " 26$degree",
                                                              style: TextStyle(
                                                                color: theme
                                                                    .iconTheme
                                                                    .color,
                                                                fontFamily:
                                                                    "poppins",
                                                                fontSize: 16,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    })
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ))),
    );
  }
}
