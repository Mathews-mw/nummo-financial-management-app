import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotificationRecurrenceType { once, monthly }

class LocalNotificationsService {
  static final LocalNotificationsService _instance =
      LocalNotificationsService._internal();

  factory LocalNotificationsService() => _instance;

  LocalNotificationsService._internal();

  static LocalNotificationsService get instance => _instance;

  final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initNotifications() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // Android init Settings
    const initAndroidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS init Settings
    const initIOsSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIOsSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  getPermissions() {
    if (!_isInitialized) {
      print("Erro: Serviço de notificação não foi inicializado!");
      return;
    }

    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'nummo_channel_id',
        'Remind notifications',
        channelDescription: 'Payment notifications channel',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    if (!_isInitialized) {
      print("Erro: Serviço de notificação não foi inicializado!");
      return;
    }

    return _notificationsPlugin.show(id, title, body, notificationDetails());
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    required NotificationRecurrenceType recurrenceType,
  }) async {
    // Get the current date/time in device's timezone
    final now = tz.TZDateTime.now(tz.local);

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

    if (recurrenceType == NotificationRecurrenceType.once) {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: null, // Send notification only once,
      );
    } else if (recurrenceType == NotificationRecurrenceType.monthly) {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate.isBefore(now)
            ? _nextMonthSameDay(scheduledDate)
            : scheduledDate,
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      );
    }

    print('Notification scheduled!');
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Calcula a próxima data no mesmo dia do próximo mês
  tz.TZDateTime _nextMonthSameDay(tz.TZDateTime date) {
    final nextMonth = date.month == 12 ? 1 : date.month + 1;
    final nextYear = date.month == 12 ? date.year + 1 : date.year;
    return tz.TZDateTime(
      tz.local,
      nextYear,
      nextMonth,
      date.day,
      date.hour,
      date.minute,
    );
  }
}
