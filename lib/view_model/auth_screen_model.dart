import 'package:beacon/enums/view_state.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/view_model/base_view_model.dart';

class AuthViewModel extends BaseModel {
  final formKeySignup = GlobalKey<FormState>();
  final formKeyLogin = GlobalKey<FormState>();

  AutovalidateMode validate = AutovalidateMode.disabled;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode emailLogin = FocusNode();
  final FocusNode passwordLogin = FocusNode();

  final FocusNode password = FocusNode();
  final FocusNode email = FocusNode();
  final FocusNode name = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool obscureTextLogin = true;
  bool obscureTextSignup = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();

  PageController pageController = PageController();

  Color left = Colors.white;
  Color right = Colors.black;

  Color leftBg = kLightBlue;
  Color rightBg = kBlue;

  next_signup() async {
    FocusScope.of(navigationService.navigatorKey.currentContext).unfocus();
    validate = AutovalidateMode.always;
    if (formKeySignup.currentState.validate()) {
      setState(ViewState.busy);
      validate = AutovalidateMode.disabled;
      databaseFunctions.init();
      final bool signUpSuccess = await databaseFunctions.signup(
          name: signupNameController.text ?? "Anonymous",
          email: signupEmailController.text,
          password: signupPasswordController.text);
      if (signUpSuccess) {
        userConfig.currentUser.print();
        navigationService.removeAllAndPush('/main', '/');
      } else {
        navigationService.removeAllAndPush('/auth', '/');
        navigationService.showSnackBar('Something went wrong');
      }
      setState(ViewState.idle);
    } else {
      navigationService.showSnackBar('Enter valid entries');
    }
  }

  loginAsGuest() async {
    setState(ViewState.busy);
    await databaseFunctions.init();
    final bool signUpSuccess =
        await databaseFunctions.signup(name: "Anonymous");
    if (signUpSuccess) {
      userConfig.currentUser.print();

      navigationService.removeAllAndPush('/main', '/');
    } else {
      navigationService.removeAllAndPush('/auth', '/');
      navigationService.showSnackBar('Something went wrong');
    }
    setState(ViewState.idle);
  }

  next_login() async {
    FocusScope.of(navigationService.navigatorKey.currentContext).unfocus();
    validate = AutovalidateMode.always;
    if (formKeyLogin.currentState.validate()) {
      setState(ViewState.busy);
      validate = AutovalidateMode.disabled;
      await databaseFunctions.init();
      final bool loginSuccess = await databaseFunctions.login(
          email: loginEmailController.text,
          password: loginPasswordController.text);
      if (loginSuccess) {
        userConfig.currentUser.print();
        navigationService.removeAllAndPush('/main', '/');
      } else {
        navigationService.removeAllAndPush('/auth', '/');
        navigationService.showSnackBar('Something went wrong');
      }
      setState(ViewState.idle);
    } else {
      navigationService.showSnackBar('Enter valid entries');
    }
  }

  void onSignInButtonPress() {
    pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void onSignUpButtonPress() {
    pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  displayPasswordLogin() {
    setState(ViewState.busy);
    obscureTextLogin = !obscureTextLogin;
    setState(ViewState.idle);
  }

  displayPasswordSignup() {
    setState(ViewState.busy);
    obscureTextSignup = !obscureTextSignup;
    setState(ViewState.idle);
  }
}
