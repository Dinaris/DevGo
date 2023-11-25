import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../theme/constants.dart';

class DefaultProgressIndicator extends StatelessWidget {
  const DefaultProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SpinKitFadingCircle(
              size: 100,
              color: kAccentColor,
            ),
          )
      );
  }
}
