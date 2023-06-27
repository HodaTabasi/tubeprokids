import 'package:apptubey/utils/context_extenssion.dart';
import 'package:apptubey/firebase/fb_auth_controller.dart';
import 'package:apptubey/general/btn_layout.dart';
import 'package:apptubey/models/fb_response.dart';
import 'package:apptubey/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chang_pass_text_feild_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePass extends StatefulWidget {
  static String routeName = "/change_password";

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  late TextEditingController _emailTextController;

  @override
  void initState() {
    super.initState();

    _emailTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffF2F2F2),
        title: Text(
          AppLocalizations.of(context)!.change_password,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'avater'),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0.r),
              child: Text(AppLocalizations.of(context)!.email,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontFamily: 'avater',
                    fontWeight: FontWeight.w500,
                  )),
            ),
            CahngePassTextFeildWidget(
                Icons.password, AppLocalizations.of(context)!.email, _emailTextController),
            SizedBox(
              height: 50.h,
            ),
            BtnLayout(AppLocalizations.of(context)!.send, () => _performReset()),
          ],
        ),
      ),
    );
  }

  Future<void> _performReset() async {
    if (_checkData()) {
      await _reset();
    }
  }

  bool _checkData() {
    if (_emailTextController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> _reset() async {
    FbResponse fbResponse =
        await FbAuthController().forgetPassword(_emailTextController.text);
    if (fbResponse.success) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
    // ignore: use_build_context_synchronously
    context.showSnackBar(
        message: fbResponse.message, error: !fbResponse.success);
  }
}
