import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rabe3/view/Screens/Homescreen/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../contact us/Contact.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String _verificationId = '';
  var NumberController = TextEditingController();
  var passwordController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool sec = true;

  var visible = const Icon(Icons.visibility, color: Color(0xff4c5166));
  var visibleoff = const Icon(Icons.visibility_off, color: Color(0xff4c5166));

  String NumberText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: constraints.maxWidth >= 600 ? 350 : 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Image.asset(
                          'assets/signup.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: HomeScreen(),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      },
                      child: Text("الرجوع للصفحة الرئيسية"),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'الدخول لادمن فقط',
                      style: GoogleFonts.reemKufiInk(
                        textStyle: TextStyle(
                          color: Color(0xff9b0d0c),
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    buildemail(),
                    const SizedBox(height: 15),
                    buildPassword(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// ... (remaining methods)
  Widget buildemail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "رقم الهاتف",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xffebefff),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: TextFormField(
            onChanged: (value) {
              if (value == "01140114357") {
                setState(() {
                  NumberText = value;
                });
              } else {
                setState(() {
                  NumberText = "";
                });
              }
            },
            controller: NumberController,
            validator: (value) {
              if (value!.isEmpty) {
                return "* مطلوب";
              } else if (value.length < 11) {
                return "أدخل رقم الهاتف صالحًا";
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 10, top: 16),
              prefixIcon: Icon(
                Icons.phone,
                color: Color(0xff4c5166),
              ),
              hintText: "رقم الهاتف",
              helperStyle: TextStyle(color: Colors.black38),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "كلمة المرور",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),  
        Container(
          alignment: Alignment.centerLeft,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xffebefff),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: TextFormField(
            controller: passwordController,
            onChanged: (value) async {
              if (NumberText == "01140114357" && value == "01140544820aser") {
                final SharedPreferences prefs =
                await SharedPreferences.getInstance();
                prefs.setBool("isUserLoggedIn", true);
                prefs.setBool("isAdmin", true);
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: HomeScreen(),
                    type: PageTransitionType.bottomToTop,
                  ),
                );
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "* مطلوب";
              } else if (value.length < 6) {
                return "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل";
              } else if (value.length > 15) {
                return "يجب ألا تزيد كلمة المرور عن 15 حرفًا";
              } else {
                return null;
              }
            },
            obscureText: sec,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                left: 10,
              ),
              prefixIcon: const Icon(
                Icons.password,
                color: Color(0xff4c5166),
              ),
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    sec = !sec;
                  });
                },
                icon: sec ? visible : visibleoff,
              ),
              hintText: "كلمة المرور",
              helperStyle: const TextStyle(color: Colors.black38),
            ),
          ),
        ),
      ],
    );
  }
}


