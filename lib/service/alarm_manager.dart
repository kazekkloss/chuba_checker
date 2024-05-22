import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:huba_checker/models/ad_model.dart';
import 'package:huba_checker/models/website_model.dart';
import 'package:huba_checker/service/repository.dart';

import '../database/repository.dart';

class AlarmManagerController {
  static const int alarmId = 1;
  static const int maxNotificationId = 100;
  static int currentNotificationId = 0;
  final AdRepository _adRepository = AdRepository();
  final DatabaseRepository _databaseRepository = DatabaseRepository();

  static void initialize() async {
    // Inicjalizacja Android Alarm Manager Plus
    await AndroidAlarmManager.initialize();

    // Inicjalizacja Awesome Notifications
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelGroupKey: "basic_channel_group",
        channelKey: "basic_channel",
        channelName: "Basic Notification",
        channelDescription: "Basic notification channel",
        playSound: true,
        enableVibration: true,
      ),
    ], channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: "basic",
        channelGroupName: "Basic Group",
      )
    ]);
    bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowedToSendNotification) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  @pragma('vm:entry-point')
  static Future<void> setupPeriodicAlarm() async {
    await AndroidAlarmManager.periodic(
      const Duration(minutes: 5),
      alarmId,
      AlarmManagerController.runLogic,
      wakeup: true,
    );
  }

  static void runLogic() async {
     List<Ad> ads = await AlarmManagerController().newAds();
    
     for (int i = 0; i < ads.length; i++) {
      AlarmManagerController.sendNotification(
        //Ad(websiteUrl: 'sdfs', title: 'rest', url: 'url', location: 'location', year: 'year', mileage: 'mileage', price: 'price', sellerType: 'sellerType', imageUrl: 'imageUrl')
        ads[i]
        );
    }
  }

  static void sendNotification(Ad ad) {
    String message = "${ad.location}, ${ad.price}, ${ad.mileage}, ${ad.year}";

    AwesomeNotifications().createNotification(
      content: NotificationContent(id: currentNotificationId, channelKey: "basic_channel", title: ad.title, body: message, payload: {'url': ad.url}),
    );

    currentNotificationId = (currentNotificationId + 1) % maxNotificationId;
  }

  Future<List<Ad>> newAds() async {
    List<Ad> newAds = [];
    List<Website> websites = await _databaseRepository.getAllWebsites();

    if (websites.isEmpty) {
      await AndroidAlarmManager.cancel(alarmId);
      await AwesomeNotifications().cancelAll();
      print('wyłączono');
    } else {
      print("włączono");
    }

    for (int i = 0; i < websites.length; i++) {
      List<Ad> ads = await _adRepository.fetchData(url: websites[i].url);


      for (int i = 0; i < ads.length; i++) {
        newAds.add(ads[i]);
      }
    }
    return newAds;
  }
}
