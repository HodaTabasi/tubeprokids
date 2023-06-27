import 'package:apptubey/get/user_getx_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MyCouponScreen extends StatefulWidget {
  static String routeName = "/mycoupon";

  const MyCouponScreen({super.key});

  @override
  State<MyCouponScreen> createState() => _MyCouponScreenState();
}

class _MyCouponScreenState extends State<MyCouponScreen> {
  UserGetxController userGetxController = UserGetxController.to;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userGetxController.currentUser.value.couponId != null) {
        userGetxController.getUserCoupons(
            coupon: userGetxController.currentUser.value.couponId ?? "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final couponNumber = UserGetxController.to.currentUser.value.couponId;
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
              trailing: Obx(() {
                return userGetxController.isLoading.value
                    ? CircularProgressIndicator.adaptive()
                    :  Text(userGetxController.subScribitionUsers.value.length.toString() +
                        " " +
                        AppLocalizations.of(context)!.users,
                        style:  const TextStyle(
                                        fontFamily: 'avater',
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),);
              }),
              largeTitle: Text(
                  AppLocalizations.of(context)!.my_coupon +
                      " : " +
                      (couponNumber ?? ""),
                  style: const TextStyle(
                      fontFamily: 'avater',
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18))),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Obx(() {
                  return userGetxController.isLoading.value
                      ? Center(
                          child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 3),
                          child: CircularProgressIndicator.adaptive(),
                        ))
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12),
                          child: Container(
                            // decoration: BoxDecoration(color: Colors.red),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      userGetxController.subScribitionUsers
                                          .value[index].image),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                    userGetxController
                                        .subScribitionUsers.value[index].name,
                                    style: const TextStyle(
                                        fontFamily: 'avater',
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14))
                              ],
                            ),
                          ));
                });
              },
              childCount: userGetxController.subScribitionUsers.value.length,
              // 1000 list items
            ),
          ),
        ],
      ),
    );
  }
}
