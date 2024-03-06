import 'package:harajsedirah/api/api.dart';
import 'package:harajsedirah/api/api_config.dart';
import 'package:harajsedirah/model/notification_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final _api = Api();

  Future<List<Notification>> readNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("/////////////////////////////////////////$prefs");
    print(prefs.get('id'));
    final id = prefs.get('id');
    final response = await _api.getData(
        "${ApiConfig.getUserNotificationsPath}?${ApiConfig.userIdQueryParmKey}=$id");
    final notificationResponse = NotificationResponse.fromJson(response.body);
    return notificationResponse.notifications;
  }
}
