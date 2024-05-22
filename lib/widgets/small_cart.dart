import 'package:flutter/material.dart';
import 'package:huba_checker/screens/ad_screen.dart';

import '../models/website_model.dart';
import 'package:sizer/sizer.dart';

class SmallCart extends StatelessWidget {
  final VoidCallback delte;
  final Website website;
  const SmallCart({super.key, required this.website, required this.delte});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10.h,
      width: 80.w,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdScreen(website: website)));
        },
        child: Card(
          color: const Color.fromARGB(255, 94, 250, 255),
          child: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      website.name,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    Text(
                      website.url,
                      style: const TextStyle(fontSize: 7),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: delte,
                    icon: Icon(
                      Icons.dangerous_outlined,
                      size: 5.h,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
