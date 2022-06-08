// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:projectx/constants/style.dart';
// import 'package:projectx/pages/auth/login.dart';
// import 'package:projectx/widgets/popup_textfield.dart';

// import '../../controllers/auth_controller.dart';
// import '../../controllers/input_validators.dart';

// class Signup extends StatefulWidget {
//   const Signup({Key? key}) : super(key: key);

//   @override
//   State<Signup> createState() => _SignupState();
// }

// class _SignupState extends State<Signup> {
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final cnfPassController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           signupBox(context),
//           Expanded(
//               child: Container(
//             color: const Color(mainColor),
//           ))
//         ],
//       ),
//     );
//   }

//   Expanded signupBox(BuildContext context) {
//     return Expanded(
//             child: Stack(
//           children: [
//             Positioned.fill(
//               child: Center(
//                 child: SizedBox(
//                   height: screenHeight(context) * 0.8,
//                   width: screenWidth(context) * 0.2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       txt(
//                           txt: 'Welcome to Ava',
//                           fontSize: 30,
//                           fontColor: const Color(secondaryColor)),
//                       SizedBox(
//                         height: screenHeight(context) * 0.05,
//                       ),
//                       txt(
//                           txt: 'Sign up to continue',
//                           fontSize: 14,
//                           fontColor: const Color(secondaryColor)),
//                       SizedBox(
//                         height: screenHeight(context) * 0.02,
//                       ),
//                       popUpTextField(context,
//                           controller: nameController, hint: 'Name'),
//                       SizedBox(
//                         height: screenHeight(context) * 0.01,
//                       ),
//                       popUpTextField(context,
//                           controller: emailController, hint: 'Email'),
//                       SizedBox(
//                         height: screenHeight(context) * 0.01,
//                       ),
//                       popUpTextField(context,
//                           controller: passwordController, hint: 'Password'),
//                       SizedBox(
//                         height: screenHeight(context) * 0.01,
//                       ),
//                       popUpTextField(context,
//                           controller: cnfPassController,
//                           hint: 'Confirm password'),
//                       SizedBox(
//                         height: screenHeight(context) * 0.05,
//                       ),
//                       Row(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               if (InputValidator.validateField(
//                                       "Name", nameController.text.trim()) &&
//                                   InputValidator.validateField(
//                                       "Email", emailController.text.trim())) {
//                                 if (InputValidator.validatePassword(
//                                     passwordController.text,
//                                     cnfPassController.text)) {
//                                   AuthController.instance.registerUser(
//                                       email: emailController.text.trim(),
//                                       name: nameController.text,
//                                       password:
//                                           passwordController.text.trim());
//                                 }
//                               }
//                             },
//                             child: Container(
//                               width: screenWidth(context) * 0.07,
//                               height: screenHeight(context) * 0.05,
//                               color: const Color(secondaryColor),
//                               child: Center(
//                                 child: txt(
//                                     txt: 'Signup',
//                                     fontSize: 14,
//                                     fontColor: Colors.white),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           InkWell(
//                             onTap: () {
//                               Get.to(const Login());
//                             },
//                             child: Container(
//                               width: screenWidth(context) * 0.07,
//                               height: screenHeight(context) * 0.05,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: 1.0,
//                                   color: const Color(secondaryColor),
//                                 ),
//                               ),
//                               child: Center(
//                                 child: txt(
//                                   txt: 'Login',
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Spacer(
//                             flex: 2,
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: screenHeight(context) * 0.03,
//                       ),
//                       Row(
//                         children: [
//                           txt(txt: 'OR', fontSize: 12),
//                           SizedBox(
//                             width: screenWidth(context) * 0.005,
//                           ),
//                           const Expanded(child: Divider())
//                         ],
//                       ),
//                       SizedBox(
//                         height: screenHeight(context) * 0.03,
//                       ),
//                       Container(
//                         width: screenWidth(context) * 0.13,
//                         height: screenHeight(context) * 0.06,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(2.0),
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.24),
//                               offset: const Offset(0, 1.0),
//                               blurRadius: 2.0,
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SvgPicture.asset('assets/svgs/google-icon.svg'),
//                               SizedBox(
//                                 width: screenWidth(context) * 0.01,
//                               ),
//                               txt(txt: 'Sign up with Google', fontSize: 22)
//                             ]),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // Positioned.fill(
//             //     child: RotatedBox(
//             //   quarterTurns: 2,
//             //   child:
//             //       Opacity(opacity: 0.1, child: txt(txt: "A", fontSize: 1500)),
//             // ))
//           ],
//         ));
//   }
// }
