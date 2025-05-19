import 'package:ajoufinder/domain/entities/notifications.dart';

abstract class NotificationRepository {
  Future<List<Notification>> findAllNotificationsByUserId(int userId);
  Future<void> addNewNotification(Notification notification);
}