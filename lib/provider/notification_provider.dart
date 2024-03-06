import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:harajsedirah/services/notification_service.dart';

import '../model/notification_response.dart' as notification;

class NotificationProvider extends ChangeNotifier {
  List<notification.Notification> _notifications = [];

  List<notification.Notification> get notifications => _notifications;
  final _notificationService = NotificationService();

  void init() async {
    try {
      _notifications = await _notificationService.readNotifications();
    } catch (e) {
      log("Notification Controller somthing went wrong $e");
    }

    notifyListeners();
  }
}
