import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shorts_video_record_button/shorts_video_record_button.dart';

void main() {
  runApp(const ShortsRecordButton());
}

class ShortsRecordButton extends StatelessWidget {
  const ShortsRecordButton({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: RecordButton(
            showLabel: true,
            labelColor: Colors.black12,
            trackColor: Colors.grey.shade300,
            fillColor: Colors.deepOrange,
            buttonColor: Colors.transparent,
            gradients: const [
              Color(0xff405de6),
              Color(0xff5851db),
              Color(0xff833ab4),
              Color(0xffc13584),
              Color(0xffe1306c),
              Color(0xfffd1d1d),
            ],
            onPlay: () {
              // Do whatever you want after play
              log("ON PLAY PRESSED=====");
            },
            onStop: (int value) {
              // Do whatever you want after stop
              log("ON STOP PRESSED=====");
            },
            onComplete: (int value) {
              // Do whatever you want after complete
              log("ON COMPLETED===== $value");
            },
            seconds: 3,
          ),
        ),
      ),
    );
  }
}

const backgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFF1D4F5),
    Color(0xFFF9F4FA),
  ],
);

class ShortsRecordSample extends StatelessWidget {
  const ShortsRecordSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(gradient: backgroundGradient),
            child: Stack(
              children: [
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.05,
                  child: SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.camera,
                                color: Colors.black,
                                weight: 30,
                                size: 30,
                              ),
                              onPressed: () {
                                // Handle the button press
                                // toggleCameraDirection();
                              },
                            ),
                            RecordButton(
                                height: 70,
                                width: 70,
                                seconds: 10,
                                showLabel: true,
                                labelColor: Colors.yellow,
                                trackColor: Colors.grey.shade300,
                                // fillColor: Colors.deepOrange,
                                gradients: const [Colors.deepPurple, Colors.pink, Colors.red],
                                onPlay: () {
                                },
                                onStop: (value) {
                                },
                                onComplete: (value) {
                                }),
                            IconButton(
                              icon: const Icon(
                                Icons.cameraswitch,
                                color: Colors.black,
                                weight: 30,
                                size: 30,
                              ),
                              onPressed: () {
                                // toggleCameraDirection();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
