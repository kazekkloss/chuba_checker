import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/ad_model.dart';

class AdCard extends StatelessWidget {
  final Ad ad;

  const AdCard({
    Key? key,
    required this.ad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(ad.url);
        if (!await launchUrl(url)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nie można otworzyć URL: ${ad.url}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: ad.imageUrl.endsWith('.svg')
                  ? Container(
                      width: double.infinity,
                      height: 20.h,
                      color: Colors.grey, // Możesz ustawić tło kontenera
                      child: const Center(
                        child: Text('Obraz w formacie .sag nie jest wspierany'),
                      ),
                    )
                  : Image.network(
                      ad.imageUrl,
                      width: double.infinity,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(ad.location, style: TextStyle(fontSize: 13.sp, color: Colors.grey[600])),
                  SizedBox(height: 0.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${ad.year} year',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                      Text(
                        '${ad.mileage} km',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${ad.price} kr',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(ad.sellerType, style: TextStyle(fontSize: 13.sp, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
