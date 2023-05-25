// ignore_for_file: avoid_print, duplicate_ignore

import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../controllers/handle_auth_controller.dart';
import '../controllers/handle_profile_api_provider.dart';
import '../controllers/handle_target_controller.dart';
import '../screens/otp_screen.dart';
import '../services/auth_service.dart';
import '../services/http_service.dart';
import '../utils/next_screen.dart';
import '../widgets/appbar_with_back_button.dart';
import '../widgets/rounded_button.dart';
import '../widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../config/metadata.dart';
import '../controllers/handle_bottom_navigation_bar.dart';
import '../main.dart';
import '../widgets/bottom_navigation_bar.dart';

import '../models/response_models/target_response.dart';
import '../services/target_service.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TargetInfoScreen extends StatefulWidget {
  const TargetInfoScreen({Key? key}) : super(key: key);

  @override
  State<TargetInfoScreen> createState() => _TargetInfoScreenState();
}

class _TargetInfoScreenState extends State<TargetInfoScreen> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  // DateTime selectedDate = DateTime.now();

  ProfileApiProvider? provider;

  /*void handleFetchTargetDetail({String? id}) async {
    token = prefs.getString("token")!;
    RequestResult? response = await TargetService.getTarget(
      token: token,
      targetType: 'QUARTERLY',
    );
  }*/

  String achieve = "";
  // var _achieved = ['Monthly', 'Quarterly', 'Yearly'];
  // var _currentItemSelected = 'Monthly';

  TextEditingController target =
      TextEditingController(text: sp!.getString('target'));
  TextEditingController type =
      TextEditingController(text: sp!.getString('type'));
  TextEditingController acheived =
      TextEditingController(text: sp!.getString('acheived'));
  TextEditingController date = TextEditingController();
  // handleFetchCategories() async {
  //   provider = Provider.of<CategoryControllerProvider>(context, listen: false);
  //   categories =
  //       await provider!.getAllCategories(mytoken: sp!.getString("token"));
  //   print("Category is");
  //   print(categories);
  //   //setState(() {});
  // }

  @override
  void initState() {
    // dateinput.text = ""; //set the initial value of text field
    super.initState();
    provider = Provider.of<ProfileApiProvider>(context, listen: false);
    handlegetTarget();
  }

  handlegetTarget() async {
    String? token = sp!.getString("token");
    RequestResult response =
        await TargetService.getTarget(token: token, targetType: "QUARTERLY");
    var targetResponse = TargetResponse.fromJson(response.data);
    // ignore: avoid_print
    print(token);
    print(response);
    print(targetResponse.toJson());

    target.text = 'Hello world 334';
    /*TargetControllerProvider targetprovider =
        Provider.of<TargetControllerProvider>(context, listen: false);
    await targetprovider.getTarget(targetType: "QUARTERLY");
    setState(() {});*/
  }

  @override
  void dispose() {
    super.dispose();
    target.dispose();
    type.dispose();
    acheived.dispose();
    // date.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // To set the text programmatically:
    target.text = 'Hello world';
    return LoaderOverlay(
      child: Scaffold(
        appBar: const AppBarWithBackButton(title: "Target Information"),
        bottomNavigationBar: MindsClikBottomNavigationBar(
          selectedIndex: 3,
          onTap: (p) => {
            Provider.of<BottomNavigationBarProvider>(context, listen: false)
                .changeIndex(index: p, context: context, currentPage: 1100),
          },
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: width,
            child: Form(
              key: globalFormKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: height * 0.05,
                      left: width * 0.08,
                      bottom: height * 0.02,
                    ),
                    width: width,
                    child: const Text(
                      "Target Info",
                      style: TextStyle(
                        fontSize: Constants.body1,
                        fontWeight: Constants.boldFont,
                      ),
                    ),
                  ),
                  MindCliksTextFormField(
                    label: "Target",
                    required: true,
                    controller: target,
                  ),
                  MindCliksTextFormField(
                    label: "Type",
                    required: true,
                    controller: type,
                  ),
                  MindCliksTextFormField(
                    label: "Achieved",
                    required: true,
                    controller: acheived,
                  ),
                  MindCliksTextFormField(
                      controller: date,
                      label: "Select Date",
                      type: "date",
                      keyBoardType: TextInputType.datetime),
                  const SizedBox(
                    height: 16,
                  ),
                  MindCliksRoundedButton(
                    label: "Submit",
                    onPressed: () => {handleSaveTargetRequest()},
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  handleSaveTargetRequest() {
    /* TargetResponse targetInfo = TargetResponse(
      userId: AppMetaData.customerId,
      userType: type.text,
      achieved: null,
      target: null,
      targetType: type.text,
    );
    */
    TargetService.setTarget(
        userId: AppMetaData.customerId,
        userType: type.text,
        achieved: 3,
        target: 6,
        targetType: "QUARTERLY");

    // ignore: avoid_print
    /*print(AppMetaData.customerId);
    print(target.text);
    print(type.text);
    print(acheived.text);
    print(date.text);*/
  }

  // void _onDropDownItemSelected(String newValueSelected) {
  //   setState(() {
  //     this._currentItemSelected = newValueSelected;
  //   });
  // }
}
