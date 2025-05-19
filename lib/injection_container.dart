import 'package:ajoufinder/data/services/repository_impls/board_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/comment_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/location_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/notification_repository_impl.dart';
import 'package:ajoufinder/data/services/repository_impls/user_repository_impl.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';
import 'package:ajoufinder/domain/repository/comment_repository.dart';
import 'package:ajoufinder/domain/repository/location_repository.dart';
import 'package:ajoufinder/domain/repository/notification_repository.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerLazySingleton<BoardRepository>(() => BoardRepositoryImpl());
  getIt.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl());
  getIt.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl());
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  getIt.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl());
}