import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Ava/constants/style.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  const LoadingIndicator({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        color: color ?? const Color(mainColor),
        size: 50.0,
      ),
    );
  }
}
