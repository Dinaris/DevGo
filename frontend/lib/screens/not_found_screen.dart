import 'package:flutter/material.dart';
import '../utils/size_config.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(getProportionateScreenHeight(50)),
        child: AppBar(
          automaticallyImplyLeading: false, // Hide the back button
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          // title: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         SvgPicture.asset(
          //           "assets/images/plato_logo.svg",
          //           height: getProportionateScreenHeight(35),
          //           width: getProportionateScreenWidth(35),
          //           fit: BoxFit.fitHeight,
          //         ),
          //         const SizedBox(width: 10),
          //         SvgPicture.asset(
          //           "assets/images/plato_black.svg",
          //           height: getProportionateScreenHeight(20),
          //           width: getProportionateScreenWidth(20),
          //           fit: BoxFit.fitHeight,
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Oops! Page not found.",
              style: TextStyle(fontSize: 24),
            ),
            // const SizedBox(height: 20),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: DefaultButton(
            //     text: "Go to Home",
            //     press: () {
            //       Navigator.of(context).pushNamedAndRemoveUntil(
            //           MainScreen.routeName, (route) => false);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
