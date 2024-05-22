import 'package:flutter/material.dart';
import 'package:huba_checker/models/ad_model.dart';
import 'package:sizer/sizer.dart';

import '../models/website_model.dart';
import '../service/repository.dart';
import '../widgets/ad_card.dart';

class AdScreen extends StatefulWidget {
  final Website website;
  const AdScreen({super.key, required this.website});

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  final AdRepository _repository = AdRepository();
  late Future<List<Ad>> _adsFuture;

  @override
  void initState() {
    super.initState();
    _adsFuture = _repository.fetchAllData(url: widget.website.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.website.name),
      ),
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<List<Ad>>(
              future: _adsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if ((snapshot.hasData && snapshot.data!.isNotEmpty)) {
                  final ads = snapshot.data!;
                  return ListView.builder(
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AdCard(
                          ad: ads[index],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Nie ma źadnego ogłoszenia tutaj'));
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  // Function to extract text content from article HTML (implementation needed)
  String extractArticleText(String articleHtml) {
    return "Replace with logic to extract text from $articleHtml";
  }
}
