// ignore_for_file: unused_local_variable

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();


  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> initAwesomeNotification() async {
    AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelKey: 'main_channel',
          channelName: 'Main Channel',
          channelDescription: 'Main channel notifications',
          enableLights: true,
          importance: NotificationImportance.High,
           channelShowBadge: true,
           locked: true,
           defaultRingtoneType: DefaultRingtoneType.Alarm

        )
      ],

    );
  }

  Future<void> requestPermission() async {
    AwesomeNotifications().isNotificationAllowed().then((allowed) {
      if (!allowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  // Future<void> removeNotifications() async
  // {
  //   await AwesomeNotifications().removeChannel('main_channel');
  // }


  Future<void> showScheduledNotification(int id, String channelKey,
      String title, String body, DateTime interval) async {
    String localTZ = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: title,
        body: body,
        locked: true,
        criticalAlert: true,
        category: NotificationCategory.Alarm,

      ),
      schedule: NotificationCalendar.fromDate(date: interval),
      actionButtons: <NotificationActionButton>[
        NotificationActionButton(key: 'remove', label: 'Stop', buttonType: ActionButtonType.DisabledAction),
        // NotificationActionButton(key: 'snooze', label: 'Snooze',buttonType: ActionButtonType.Default),
      ],
    );
  }


  Future<void> showQuickNotification(int id, String channelKey, String title,
      String body) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: channelKey,
          title: title + Emojis.smile_winking_face_with_tongue,
          body: body,
        ),
        actionButtons: <NotificationActionButton>[
          NotificationActionButton(key: 'remove', label: 'Remove', buttonType: ActionButtonType.DisabledAction),
        ]
    );
  }
}
