class NotificationFilterModel {
  final int id;
  final String title;

  NotificationFilterModel({
    required this.id,
    required this.title,
  });
}

List<NotificationFilterModel> notificationFilterList = [
  NotificationFilterModel(
    id: 1,
    title: 'This week',
  ),
  NotificationFilterModel(
    id: 2,
    title: 'All',
  ),
];
