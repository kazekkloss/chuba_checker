import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:huba_checker/models/website_model.dart';
import 'package:huba_checker/widgets/add_link_baner.dart';
import 'package:huba_checker/widgets/small_cart.dart';
import 'package:sizer/sizer.dart';

import '../database/repository.dart';
import '../service/alarm_manager.dart';
import '../service/notification_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseRepository _repository = DatabaseRepository();
  late Future<List<Website>> _websitesFuture;

  @override
  void initState() {
    super.initState();
    _websitesFuture = _repository.getAllWebsites();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'HUBA CHECKER',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<List<Website>>(
              future: _websitesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if ((snapshot.hasData && snapshot.data!.isNotEmpty)) {
                  AlarmManagerController.setupPeriodicAlarm();
                  final websites = snapshot.data!;
                  return ListView.builder(
                    itemCount: websites.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SmallCart(
                            website: websites[index],
                            delte: () async {
                              var success = await _repository.deleteWebsiteByUrl(websites[index].url);
                              if (success) {
                                setState(() {
                                  _websitesFuture = _repository.getAllWebsites();
                                });
                              }
                            },
                          ));
                    },
                  );
                } else {
                  return const Center(child: Text('Nie masz żadnych stron do śledzenia'));
                }
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddLinkBaner(
                  onSuccess: () {
                    setState(() {
                      _websitesFuture = _repository.getAllWebsites();
                      Navigator.of(context).pop(); 
                    });
                  },
                );
              
            },
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
