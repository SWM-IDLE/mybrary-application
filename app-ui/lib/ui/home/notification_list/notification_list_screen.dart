import 'package:flutter/material.dart';
import 'package:mybrary/data/model/home/notification_model.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/data/repository/home_repository.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/components/single_data_error.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/utils/logics/common_utils.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final _homeRepository = HomeRepository();
  final _userId = UserState.userId;

  late Future<NotificationModel> _notificationListResponseData;

  @override
  void initState() {
    super.initState();

    _notificationListResponseData = _homeRepository.getNotificationList(
      context: context,
      userId: _userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubPageLayout(
      appBarTitle: '알림',
      child: FutureBuilder(
        future: _notificationListResponseData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SingleDataError(
              errorMessage: '알림 목록을 불러오는데 실패했습니다.',
            );
          }

          if (snapshot.hasData) {
            final notificationList = snapshot.data!.messages;

            if (notificationList.isEmpty) {
              return const SingleDataError(
                icon: Icons.notifications_active_sharp,
                iconColor: primaryColor,
                errorMessage: '알림이 없습니다.',
              );
            }

            return SizedBox(
              width: mediaQueryWidth(context),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: notificationList.length,
                itemBuilder: (context, index) {
                  final notification = notificationList[index];

                  return Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 10.0 : 20.0,
                          right: 24.0,
                          bottom: 16.0,
                          left: 24.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🔔  ${notification.message} 😊',
                              style: commonSubMediumStyle.copyWith(
                                fontSize: 15.0,
                                letterSpacing: -1,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 8.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                notification.publishedAt
                                    .substring(0, 10)
                                    .replaceAll('-', '.'),
                                style: commonSubMediumStyle.copyWith(
                                  fontSize: 12.0,
                                  color: grey777777,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                      commonDivider(
                        dividerThickness: 2,
                      ),
                    ],
                  );
                },
              ),
            );
          }
          return const CircularLoading();
        },
      ),
    );
  }
}
