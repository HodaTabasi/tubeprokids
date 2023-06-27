import 'package:apptubey/get/play_list_getx_controller.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import '../models/fb_response.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AppConstant{
  static const int VIDEO_LIMIT_LENTH = 20;
}

Future<void> displayTextInputDialog(
    BuildContext context, {textFieldController, video}) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text(AppLocalizations.of(context)!.create_new_list),
          content:   TextField(
            controller: textFieldController,
            decoration:  InputDecoration(hintText: AppLocalizations.of(context)!.create_new_list),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(
                AppLocalizations.of(context)!.create,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                if(textFieldController.text.isNotEmpty){
                  FbResponse fbResponse = await PlayListGetxController.to.createPlayList(textFieldController.text,video: video);
                  textFieldController.text = "";
                  if (fbResponse.success) {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.pop(context);
                    });
                  }
                  context.showSnackBar(message: fbResponse.message);
                }else {
                  context.showSnackBar(
                    message: AppLocalizations.of(context)!.enter_the_required_data,
                    error: true,
                  );
                }
                // userGetxController.currentUser.value.name =
                //     _textFieldController.text;
                //

              },
            ),
          ],
        );
      });
}
