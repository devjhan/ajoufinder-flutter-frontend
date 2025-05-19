import 'package:ajoufinder/domain/entities/notifications.dart';
import 'package:ajoufinder/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository{

  @override
  Future<List<Notification>> findAllNotificationsByUserId(int userId) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addNewNotification(Notification notification) async {
    throw UnimplementedError();
  }
}