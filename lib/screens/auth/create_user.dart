import 'dart:convert';
import 'dart:math';

import 'package:apptubey/api/api_service.dart';
import 'package:apptubey/helper/helper.dart';
import 'package:apptubey/models/Country.dart';
import 'package:apptubey/models/users.dart';
import 'package:apptubey/screens/otp/otp_screen.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:country_picker/country_picker.dart' as c;

import '../../firebase/fb_phone_auth_controller.dart';
import '../../general/btn_layout.dart';
import '../../general/register_phone_text_feild_widget.dart';
import '../../general/register_text_feild_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../get/copon_getx_controller.dart';

class CreateUser extends StatefulWidget {
  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> with Helpers {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _countryController;
  late TextEditingController _ensurePasswordController;
  late TextEditingController _phoneController;
  List<Country> data = [];

  String? dropdownValue;

  var isExpand = false;

  Country? value;


  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _countryController = TextEditingController();
    _ensurePasswordController = TextEditingController();
    _phoneController = TextEditingController();
    getData();
  }

  getData() async {
    List my_data = json.decode(await APIService.instance.getJson());
    data = my_data.map((e) => Country.fromJson(e)).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ensurePasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoponGextController>(builder: (controllers) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegisterTextFeildWidget(
                AppLocalizations.of(context)!.full_name,
                Icons.person,
                _nameController,
                textFieldType: TextFieldType.fullName,
              ),
              SizedBox(
                height: 4.h,
              ),
              RegisterTextFeildWidget(
                AppLocalizations.of(context)!.email,
                Icons.email,
                _emailController,
                textFieldType: TextFieldType.email,
              ),
              SizedBox(
                height: 4.h,
              ),
             
              SizedBox(
                height: 4.h,
              ),
                        Text(AppLocalizations.of(context)!.phone_number ,textAlign: TextAlign.center,style: const TextStyle(
                      color: Colors.black,
                      // fontSize: 20,
                      fontFamily: 'avater',
                      fontWeight: FontWeight.w500,
                    ),),
 SizedBox(
                height: 4.h,
              ),
              RegisterPhoneTextFeildWidget(AppLocalizations.of(context)!.phone,
                  Icons.phone_android, _phoneController, controllers,onTap: () {
                    c.showCountryPicker(
                      context: context,
                      countryListTheme: c.CountryListThemeData(
                        flagSize: 25,
                        backgroundColor: Colors.white,
                        textStyle:
                            const TextStyle(fontSize: 16, color: Colors.blueGrey),
                        bottomSheetHeight:
                            500, // Optional. Country list modal height
                        //Optional. Sets the border radius for the bottomsheet.
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        //Optional. Styles the search field.
                        inputDecoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.search,
                          hintText: AppLocalizations.of(context)!
                              .start_typing_to_search,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF8C98A8).withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      onSelect: (c.Country country) {
                        setState(() {
                          _countryController.text = country.name;
                          print(country.phoneCode);
                          controllers.changePhone(country.phoneCode);
                        });
                        dropdownValue = country.name;
                      },
                    );
                  },),
                  
              SizedBox(
                height: 14.h,
              ),
              RegisterTextFeildWidget(
                AppLocalizations.of(context)!.password,
                Icons.password,
                _passwordController,
                isScure: true,
                textFieldType: TextFieldType.password,
              ),
              SizedBox(
                height: 4.h,
              ),
              RegisterTextFeildWidget(
                AppLocalizations.of(context)!.re_password,
                Icons.password,
                _ensurePasswordController,
                textFieldType: TextFieldType.rePassword,
                isScure: true,
              ),
              SizedBox(
                height: 4.h,
              ),
              BtnLayout(AppLocalizations.of(context)!.register, () {
                _performRegister();
              }),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _performRegister() async {
    if (_checkData()) {
      await _register();
    } else {
      context.showSnackBar(
          message: AppLocalizations.of(context)!.ensure_that_correct,
          error: true);
    }
  }

  bool _checkData() {

      if (_formKey.currentState!.validate()) {
           _formKey.currentState!.save();
           return true;
        }else{
          return false;
        }

    // if (_emailController.text.isNotEmpty &&
    //     _passwordController.text.isNotEmpty &&
    //     _nameController.text.isNotEmpty &&
    //     RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //         .hasMatch(_emailController.text) &&
    //     _ensurePasswordController.text.isNotEmpty &&
    //     _phoneController.text.isNotEmpty) {
    //   if (dropdownValue == null) return false;
    //   if (_passwordController.text != _ensurePasswordController.text)
    //     return false;
    //   return true;
    // }


    // return false;
  }

  Future<void> _register() async {
    CoponGextController.to.user = user;
    // showLoaderDialog(context);
    await FireBaseAuthPhoneController().afterPhoneVerification(context);

    // FireBaseAuthPhoneController().verifyPhoneNumber1(
    //     context: context, userPhone: _phoneController.text);

    // FbResponse fbResponse = await FbAuthController().createAccount(user);
    // // if (fbResponse.success) {
    //   Navigator.pushReplacementNamed(context, OTPScreen.routeName);
    // // }
    //
    // context.showSnackBar(
    //     message: fbResponse.message, error: !fbResponse.success);
  }
  
  Users get user {
    Users user = Users();
    Random random = Random();
    int randomNumber = random.nextInt(1000000);
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    user.id = randomNumber.toString();
    user.name = _nameController.text;
    user.email = _emailController.text;
    user.accountTypeEN = 'free account';
    user.accountTypeAR = 'حساب مجاني';
    user.country = dropdownValue ?? "+972";
    user.date = formattedDate;
    user.phoneNumber = _phoneController.text;
    user.isVisible = true;
    user.videosNumber = 0.toString();
    user.image =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png';
    user.password = _passwordController.text;
    user.subscraption = false;
    user.subscraption_duration = null;
    return user;
  }
}
