import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';

class IsbnScanDescription extends StatelessWidget {
  final double width;
  final double height;
  final String topText;
  final String bottomText;
  final IconData icon;
  final void Function()? onPressedScanButton;
  final bool isMyBookScan;

  const IsbnScanDescription({
    required this.width,
    required this.height,
    required this.topText,
    required this.bottomText,
    required this.icon,
    required this.onPressedScanButton,
    this.isMyBookScan = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const barcodeDescriptionTextStyle = TextStyle(
      color: commonWhiteColor,
      fontSize: 15.0,
    );

    return Positioned(
      bottom: 0,
      child: Container(
        width: width,
        height: height * 0.35,
        decoration: BoxDecoration(
          color: isMyBookScan
              ? myBookScanBackgroundColor
              : myBookScanBackgroundColor.withOpacity(0.7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  topText,
                  style: barcodeDescriptionTextStyle,
                ),
                const SizedBox(height: 10.0),
                Text(
                  bottomText,
                  style: barcodeDescriptionTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: onPressedScanButton,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(70.0, 70.0),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: commonWhiteColor,
                  size: 38.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
