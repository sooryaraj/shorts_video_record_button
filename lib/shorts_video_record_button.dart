import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({
    Key? key,
    this.seconds = 20,
    this.width = 200,
    this.height = 200,
    this.showLabel = false,
    this.labelColor = Colors.blue,
    required this.onPlay,
    required this.onStop,
    required this.onComplete,
    this.fillColor = Colors.green,
    this.trackColor = Colors.black12,
    this.gradients = const [],
    this.strokeCap = StrokeCap.butt,
    this.enable = true,
    this.buttonColor = Colors.red,
  }) : super(key: key);

  final int seconds;
  final double width;
  final double height;
  final bool showLabel;
  final bool enable;
  final Color labelColor;
  final Color buttonColor;
  final Color fillColor;
  final Color trackColor;
  final StrokeCap strokeCap;
  final List<Color> gradients;
  final VoidCallback onPlay;
  final Function(int value) onStop;
  final Function(int value) onComplete;

  @override
  Widget build(BuildContext context) {
    final RecordController recordController = RecordController(seconds: seconds, onComplete: onComplete, onPlay: onPlay, onStop: onStop);

    return IgnorePointer(
      ignoring: !enable,
      child: Center(
        child: GestureDetector(
          onTap: () {
            recordController.isActive ? recordController.stop(manualStop: true) : recordController.play();
          },
          child: SizedBox(
            width: width,
            height: height,
            child: ListenableBuilder(
                listenable: recordController,
                builder: (context, child) {
                  return CustomPaint(
                      painter: MyPainter(
                    value: recordController.value.toInt(),
                    seconds: seconds,
                    fillColor: fillColor,
                    trackColor: trackColor,
                    showLabel: showLabel,
                    labelColor: labelColor,
                    gradients: gradients,
                    strokeCap: strokeCap,
                    enable: enable,
                    buttonColor: buttonColor,
                  ));
                }),
          ),
        ),
      ),
    );
  }
}

class RecordController with ChangeNotifier {
  final int seconds;
  VoidCallback onPlay;
  Function(int value) onStop;
  Function(int value) onComplete;

  RecordController({required this.seconds, required this.onComplete, required this.onStop, required this.onPlay});

  Timer? _timer;
  int _value = 0;
  bool _isActive = false;

  bool get isActive => _isActive;

  int get value => _value;

/*
  void restart() {
    _timer?.cancel();
    _play();
  }*/

  void play() {
    if (_timer != null) return;
    _value = 0;
    onPlay();
    _play();
  }

  void _play() {
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      int milliseconds = seconds * 1000;
      if (milliseconds < _value) {
        stop();
      }
      _value = timer.tick;
      notifyListeners();
    });
    _isActive = _timer!.isActive;
    notifyListeners();
  }

  void stop({bool manualStop = false}) {
    _timer?.cancel();
    _timer = null;
    manualStop ? onStop(_value ~/ 1000) : onComplete(_value ~/ 1000);
    _value = 0;
    _isActive = false;
    notifyListeners();
  }
}

class MyPainter extends CustomPainter {
  MyPainter({
    required this.value,
    this.trackColor,
    this.strokeCap = StrokeCap.butt,
    this.fillColor,
    this.seconds = 30,
    this.labelColor = Colors.blue,
    this.buttonColor = Colors.red,
    this.showLabel = false,
    this.enable = true,
    this.gradients = const [],
  });

  final int value; // 0 to 10
  final int seconds;
  final Color? trackColor;
  final Color? fillColor;
  final List<Color> gradients;
  final bool showLabel;
  final bool enable;
  final StrokeCap strokeCap;
  final Color labelColor;
  final Color buttonColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Get the center of the canvas
    var bgColor = trackColor ?? Colors.black12;
    var fgColor = fillColor ?? Colors.green;
    var width = size.width;
    var height = size.height;
    final center = Offset(width / 2, height / 2);
    double strokeWidth = width / 10;

    // Draw the gray background seen on the progress indicator
    // This will act as the background layer.

    var innerCirclePaint = Paint();
    if (enable) {
      innerCirclePaint.color = buttonColor;
    } else {
      innerCirclePaint.color = bgColor;
    }
    canvas.drawCircle(
      center,
      (width / 2) - (strokeWidth),
      innerCirclePaint
        ..style = PaintingStyle.fill
        ..strokeWidth = strokeWidth,
    );

    var outerCirclePaint = Paint();
    if (enable) {
      outerCirclePaint.color = bgColor;
    } else {
      outerCirclePaint.color = buttonColor.withOpacity(0.6);
    }
    canvas.drawCircle(
      center,
      (width / 2) - (strokeWidth / 2),
      outerCirclePaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Create a new layer where we will be painting the
    // actual progress indicator
    canvas.saveLayer(
      Rect.fromCenter(center: center, width: width, height: height),
      Paint(),
    );

    var rect = Rect.fromCircle(
      center: center,
      radius: 360,
    );

    var fillPaint = Paint();

    if (gradients.isNotEmpty) {
      fillPaint.shader = LinearGradient(
        colors: gradients.reversed.toList(),
      ).createShader(rect);
    } else {
      fillPaint.color = fgColor;
    }
    canvas.drawArc(
      Rect.fromCenter(center: center, width: width - strokeWidth, height: height - strokeWidth),
      radians(0),
      radians(value / (seconds * 1000) * 360),
      false,
      fillPaint
        ..style = PaintingStyle.stroke
        ..strokeCap = strokeCap
        ..strokeWidth = strokeWidth,
    );

    TextSpan span = TextSpan(style: TextStyle(color: labelColor, fontSize: width / 2), text: (value ~/ 1000).toString());
    TextPainter tp = TextPainter(textAlign: TextAlign.center, text: span, textDirection: TextDirection.ltr);
    tp.layout();
    if (showLabel) {
      tp.paint(
        canvas,
        Offset(
          (width - tp.width) * 0.5,
          (height - tp.height) * 0.5,
        ),
      );
    }
    canvas.restore();
  }

  double radians(double degree) {
    return degree * (pi / 180);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
