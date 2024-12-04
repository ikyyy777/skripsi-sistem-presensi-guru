import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';

class GuruTombolPresensiWidget extends StatefulWidget {
  GuruTombolPresensiWidget({super.key});

  @override
  _GuruTombolPresensiWidgetState createState() =>
      _GuruTombolPresensiWidgetState();
}

class _GuruTombolPresensiWidgetState extends State<GuruTombolPresensiWidget>
    with SingleTickerProviderStateMixin {
  final guruController = Get.put(GuruController());
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation

    // Create a scale animation for the container
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated Container behind the button
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 180, // Larger size than the button
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstant.blue.withOpacity(0.5),
                ),
              ),
            );
          },
        ),
        // The actual ElevatedButton in the center
        ElevatedButton(
          onPressed: () {
            guruController.kirimPresensi();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstant.blue,
            shape: CircleBorder(),
            padding: EdgeInsets.all(0),
            minimumSize: Size(150, 150), // Set the size of the button
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Image.asset(
                  "assets/images/touch.png",
                ),
              ),
              Text(
                "Masuk",
                style: TextstyleConstant.nunitoSansBold.copyWith(
                  fontSize: 20,
                  color: ColorConstant.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
