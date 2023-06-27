// import 'package:flutter/material.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// class Paywall extends StatefulWidget {
//   final Offering offering;
//
//   const Paywall({required this.offering}) ;
//
//   @override
//   _PaywallState createState() => _PaywallState();
// }
//
// class _PaywallState extends State<Paywall> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: SafeArea(
//         child: Wrap(
//           children: <Widget>[
//             Container(
//               height: 70.0,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                   color: Colors.black,
//                   borderRadius:
//                   BorderRadius.vertical(top: Radius.circular(25.0))),
//               child: const Center(
//                   child:
//                   Text('✨ Magic Weather Premium', style: kTitleTextStyle)),
//             ),
//             const Padding(
//               padding:
//               EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
//               child: SizedBox(
//                 child: Text(
//                   'MAGIC WEATHER PREMIUM',
//                   style: kDescriptionTextStyle,
//                 ),
//                 width: double.infinity,
//               ),
//             ),
//             ListView.builder(
//               itemCount: widget.offering.availablePackages.length,
//               itemBuilder: (BuildContext context, int index) {
//                 var myProductList = widget.offering.availablePackages;
//                 return Card(
//                   color: Colors.black,
//                   child: ListTile(
//                       onTap: () async {
//                         try {
//                           CustomerInfo customerInfo =
//                           await Purchases.purchasePackage(
//                               myProductList[index]);
//                           appData.entitlementIsActive = customerInfo
//                               .entitlements.all[entitlementID].isActive;
//                         } catch (e) {
//                           print(e);
//                         }
//
//                         setState(() {});
//                         Navigator.pop(context);
//                       },
//                       title: Text(
//                         myProductList[index].storeProduct.title,
//                         style: kTitleTextStyle,
//                       ),
//                       subtitle: Text(
//                         myProductList[index].storeProduct.description,
//                         style: kDescriptionTextStyle.copyWith(
//                             fontSize: kFontSizeSuperSmall),
//                       ),
//                       trailing: Text(
//                           myProductList[index].storeProduct.priceString,
//                           style: kTitleTextStyle)),
//                 );
//               },
//               shrinkWrap: true,
//               physics: const ClampingScrollPhysics(),
//             ),
//             const Padding(
//               padding:
//               EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
//               child: SizedBox(
//                 child: Text(
//                   footerText,
//                   style: kDescriptionTextStyle,
//                 ),
//                 width: double.infinity,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }