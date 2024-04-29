import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsy_github_app_flutter/common/config/config.dart';
import 'package:gsy_github_app_flutter/common/local/local_storage.dart';
import 'package:gsy_github_app_flutter/common/localization/default_localizations.dart';
import 'package:gsy_github_app_flutter/common/net/address.dart';
import 'package:gsy_github_app_flutter/common/utils/navigator_utils.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';
import 'package:gsy_github_app_flutter/redux/login_redux.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/common/utils/common_utils.dart';
import 'package:gsy_github_app_flutter/widget/animated_background.dart';
import 'package:gsy_github_app_flutter/widget/gsy_flex_button.dart';
import 'package:gsy_github_app_flutter/widget/gsy_input_widget.dart';
import 'package:gsy_github_app_flutter/widget/particle/particle_widget.dart';

/**
 * 登录页
 * Created by guoshuyu
 * Date: 2018-07-16
 */
class LoginPage extends StatefulWidget {
  static final String sName = "login";

  @override
  State createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with LoginBLoC {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            // 动态背景
            // Positioned.fill(
            //   child: AnimatedBackground(),
            // ),
            // Positioned.fill(
            //   child: ParticlesWidget(30), // 例子效果，暂时不要了
            // ),
            // 背景图
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                GSYICons.DEFAULT_USER_ICON, // 替换为你的背景图路径
                fit: BoxFit.fill, // 让背景图填充整个宽度
              ),
            ),
            // 登录框
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.zero, // 移除边距
                width: double.infinity,
                color: Colors.transparent, // 使背景图透过来
                child: SingleChildScrollView(
                  child: Card(
                    // elevation: 5.0,
                    margin: EdgeInsets.zero, // 移除边距
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0), // 左上角圆角
                        topRight: Radius.circular(30.0), // 右上角圆角
                      ),
                    ),
                    color: GSYColors.cardWhite,
                    child: SizedBox(
                      width: double.infinity, // 设置登录框的宽度
                      height: 800, // 设置登录框的高度
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              GSYLocalizations.i18n(context)!
                                  .login_text,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                                color: GSYColors.titleTextColor,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10.0)),
                            GSYInputWidget(
                              hintText: GSYLocalizations.i18n(context)!
                                  .login_username_hint_text,
                              iconData: GSYICons.LOGIN_USER,
                              onChanged: (String value) {
                                _userName = value;
                              },
                              controller: userController,
                            ),
                            Padding(padding: EdgeInsets.all(10.0)),
                            GSYInputWidget(
                              hintText: GSYLocalizations.i18n(context)!
                                  .login_password_hint_text,
                              iconData: GSYICons.LOGIN_PW,
                              obscureText: true,
                              onChanged: (String value) {
                                _password = value;
                              },
                              controller: pwController,
                            ),
                            Padding(padding: EdgeInsets.all(10.0)),
                            Container(
                              height: 50,
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    child: GSYFlexButton(
                                      text: GSYLocalizations.i18n(context)!
                                          .login_text,
                                      color: Theme.of(context).primaryColor,
                                      textColor: GSYColors.textWhite,
                                      fontSize: 16,
                                      onPress: loginIn,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: GSYFlexButton(
                                      text: GSYLocalizations.i18n(context)!
                                          .oauth_text,
                                      color: Theme.of(context).primaryColor,
                                      textColor: GSYColors.textWhite,
                                      fontSize: 16,
                                      onPress: oauthLogin,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(15.0)),
                            InkWell(
                              onTap: () {
                                CommonUtils.showLanguageDialog(context);
                              },
                              child: Text(
                                GSYLocalizations.i18n(context)!
                                    .switch_language,
                                style: TextStyle(
                                  color: GSYColors.subTextColor,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(15.0)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



mixin LoginBLoC on State<LoginPage> {
  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();

  String? _userName = "";
  String? _password = "";

  @override
  void initState() {
    super.initState();
    initParams();
  }

  @override
  void dispose() {
    super.dispose();
    userController.removeListener(_usernameChange);
    pwController.removeListener(_passwordChange);
  }

  _usernameChange() {
    _userName = userController.text;
  }

  _passwordChange() {
    _password = pwController.text;
  }

  initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY);
    _password = await LocalStorage.get(Config.PW_KEY);
    userController.value = new TextEditingValue(text: _userName ?? "");
    pwController.value = new TextEditingValue(text: _password ?? "");
  }

  loginIn() async {
    // Fluttertoast.showToast(
    //     msg: GSYLocalizations.i18n(context)!.Login_deprecated,
    //     gravity: ToastGravity.CENTER,
    //     toastLength: Toast.LENGTH_LONG);
    // return;

    if (_userName?.isEmpty ?? true) {
      return;
    }

    if (_password?.isEmpty ?? true) {
      return;
    }

    ///通过 redux 去执行登陆流程
    StoreProvider.of<GSYState>(context)
        .dispatch(LoginAction(context, _userName, _password));
  }

  oauthLogin() async {
    String? code = await NavigatorUtils.goLoginWebView(context,
        Address.getOAuthUrl(), "${GSYLocalizations.i18n(context)!.oauth_text}");

    if (code != null && code.length > 0) {
      ///通过 redux 去执行登陆流程
      StoreProvider.of<GSYState>(context)
          .dispatch(OAuthAction(context, code));
    }
  }
}
