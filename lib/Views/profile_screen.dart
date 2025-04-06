import 'package:flutter/material.dart';
import 'package:flutter/material.dart.';
import 'package:flutter/services.dart';
import 'package:garage_app/Views/widgets/custom_elevated_button.dart';
import 'package:garage_app/Views/widgets/custom_textform_field.dart';
import 'package:sizer/sizer.dart';

import '../app/constants/color_manager.dart';
import '../app/constants/fonts_manager.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController gymNameController = TextEditingController();

  bool isLoading = false;
  bool isVisible = false;
  bool readOnly = true;
  bool update = true;
  bool edit = false;

  final GlobalKey<FormState> _updateGymKey = GlobalKey<FormState>();
  // XFile? _gymLogo;
  // DateTime selectedDate = DateTime.now();
  //
  // Future<void> _pickImage(ImageSource source) async {
  //   final pickedImage =
  //   await ImagePicker().pickImage(imageQuality: 15, source: source);
  //   if (pickedImage != null) {
  //     setState(() {
  //       _gymLogo = pickedImage;
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    // MemberData.initializeGymId();
    // MemberData.initializeUserId();
    super.initState();
  }

  // void showLoading() {
  //   LoadingDialog.showLoadingDialog(context); // Pass the context of this screen
  //   // Perform your loading tasks here
  // }

  void _showLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 40.h,
            child: AlertDialog(
              title: const Text("Logout 🤔"),
              content: Text(
                'Ready to power down??\nConfirm your exit!',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 12.sp),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MaterialStateColor.resolveWith(
                            (states) => ColorsManager.whiteColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: 'AppFonts',
                        color: ColorsManager.primaryColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MaterialStateColor.resolveWith(
                            (states) => ColorsManager.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    // SignUpApi.signOut(context);
                    // final preference = await SharedPreferences.getInstance();
                    // FirebaseAuth.instance.signOut();
                    // preference.setBool('isAuthenticated', false);
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, Routes.loginRoute, (route) => false);
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                        fontFamily: 'AppFonts',
                        color: ColorsManager.whiteColor),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.dark,
    ));

    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'AppFonts',
          color: Colors.white,
          fontSize: 18.sp,
        ),
        backgroundColor: ColorsManager.blackColor.withOpacity(0.92),
      ),
      backgroundColor: ColorsManager.offWhiteColor,
      body: Form(
          key: _updateGymKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      width: 100.w,
                      height: update ? 65.h : 78.h,
                    ),

                    /// OWNER DETAILS
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5.w),
                            bottomRight: Radius.circular(5.w)),
                        child: SizedBox(
                          width: 100.w,
                          height: 41.h,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/images/img.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              ColoredBox(
                                color: ColorsManager.transparentColor,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.h, horizontal: 5.w),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Stack(
                                            children: [
                                              // InkWell(
                                              //   onTap: () {
                                              //     update
                                              //         ? ''
                                              //         : _pickImage(
                                              //         ImageSource
                                              //             .gallery);
                                              //   },
                                              //   child: ClipOval(
                                              //     child: Container(
                                              //       width: 40.w,
                                              //       height: 40.w,
                                              //       decoration:
                                              //       const BoxDecoration(
                                              //         shape: BoxShape
                                              //             .circle,
                                              //       ),
                                              //       child: _gymLogo !=
                                              //           null
                                              //           ? CustomProfileImg(
                                              //           profileImage:
                                              //           _gymLogo)
                                              //           : CachedNetworkImage(
                                              //         imageUrl: snapshot
                                              //             .data!
                                              //             .gymLogo ??
                                              //             '',
                                              //         fit: BoxFit
                                              //             .cover,
                                              //         placeholder: (context,
                                              //             url) =>
                                              //             ShimmerEffectCard(
                                              //                 height:
                                              //                 40.w,
                                              //                 width: 40.w),
                                              //       ),
                                              //     ),
                                              //   ),
                                              //   // child: CustomLogoNetwork(
                                              //   //   imageUrl: snapshot
                                              //   //           .data!.gymLogo ??
                                              //   //       '',
                                              //   // ),
                                              // ),
                                              Visibility(
                                                visible: !update,
                                                child: Positioned(
                                                  bottom: 0,
                                                  right: 3.w,
                                                  child: Container(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(4),
                                                    decoration:
                                                    const BoxDecoration(
                                                      shape: BoxShape
                                                          .circle,
                                                      color: ColorsManager
                                                          .whiteColor,
                                                    ),
                                                    child: const Icon(
                                                      Icons.edit,
                                                      size: 24,
                                                      color: ColorsManager
                                                          .blackColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                             " snapshot.data!.ownerName",
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                color: ColorsManager
                                                    .whiteColor,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                                fontFamily: 'AppFonts',
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
                                              children: [
                                                const Icon(
                                                  Icons.email_outlined,
                                                  color: ColorsManager
                                                      .whiteColor,
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                SizedBox(
                                                  width: 75.w,
                                                  height: 3.h,
                                                  child:
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                    Axis.horizontal,
                                                    child:
                                                    SingleChildScrollView(
                                                      child: Text(
                                                       " snapshot.data!.ownerEmail",
                                                        style:
                                                        TextStyle(
                                                          fontSize:
                                                          13.sp,
                                                          fontFamily:
                                                          'AppFonts',
                                                          color: ColorsManager
                                                              .whiteColor,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                        textAlign:
                                                        TextAlign
                                                            .left,
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Positioned(
                      top: 37.h,
                      child: Card(
                        elevation: 5,
                        surfaceTintColor: ColorsManager.offWhiteColor,
                        color: ColorsManager.whiteColor,
                        child: SizedBox(
                          width: update ? 80.w : 85.w,
                          height: update ? 25.h : 42.h,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.h),
                                      child: Text(
                                        'Gym Details',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: ColorsManager.blackColor,
                                          fontFamily: 'AppFonts',
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 5.w),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Name :",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily: 'AppFonts',
                                            fontWeight:
                                            FontWeightManager
                                                .semiBold),
                                      ),
                                      update
                                          ? SizedBox(
                                        height: 3.h,
                                        width: 40.w,
                                        child: Text(
                                          "snapshot.data!.gymName",
                                          maxLines: 1,
                                          textAlign:
                                          TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily:
                                            'AppFonts',
                                            fontWeight:
                                            FontWeightManager
                                                .semiBold,
                                            color: ColorsManager
                                                .greyColor,
                                            overflow: TextOverflow
                                                .ellipsis,
                                          ),
                                        ),
                                      )
                                          : SizedBox(
                                          height: 8.h,
                                          width: 50.w,
                                          child:
                                          CustomTextFormField(
                                            controller:
                                            gymNameController,
                                            readOnly: readOnly,
                                            enable: true,
                                            autoFocus: false,
                                            obscureText: false,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Enter Gym's Name";
                                              }
                                              return null;
                                            },
                                            fontSize: 14.sp,
                                          ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 5.w),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Phone :",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily: 'AppFonts',
                                            fontWeight:
                                            FontWeightManager
                                                .semiBold),
                                      ),
                                      update
                                          ? SizedBox(
                                        height: 3.h,
                                        width: 40.w,
                                        child: Text(
                                          "snapshot.data!.gymPhone",
                                          textAlign:
                                          TextAlign.left,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily:
                                            'AppFonts',
                                            color: ColorsManager
                                                .greyColor,
                                            fontWeight:
                                            FontWeightManager
                                                .semiBold,
                                            overflow: TextOverflow
                                                .ellipsis,
                                          ),
                                        ),
                                      )
                                          : SizedBox(
                                          height: 8.h,
                                          width: 50.w,
                                          child:
                                          CustomTextFormField(
                                            controller:
                                            phoneController,
                                            enable: true,
                                            readOnly: readOnly,
                                            fontSize: 14.sp,
                                            autoFocus: edit,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Enter Gym's Contact";
                                              } else if (phoneController
                                                  .text
                                                  .length !=
                                                  10) {
                                                return "Enter a valid Phone Number!";
                                              }
                                              return null;
                                            },
                                            obscureText: false,
                                            keyboardType:
                                            TextInputType.phone,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 5.w),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Address : ",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily: 'AppFonts',
                                            fontWeight:
                                            FontWeightManager
                                                .semiBold),
                                      ),
                                      update
                                          ? SizedBox(
                                        height: 3.h,
                                        width: 40.w,
                                        child:
                                        SingleChildScrollView(
                                          scrollDirection:
                                          Axis.horizontal,
                                          child: Text(
                                            "snapshot.data!.gymAddress",
                                            maxLines: 1,
                                            textAlign:
                                            TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily:
                                              'AppFonts',
                                              color: ColorsManager
                                                  .greyColor,
                                              fontWeight:
                                              FontWeightManager
                                                  .semiBold,
                                              overflow:
                                              TextOverflow
                                                  .ellipsis,
                                            ),
                                          ),
                                        ),
                                      )
                                          : SizedBox(
                                        height: 8.h,
                                        width: 50.w,
                                        child:
                                        CustomTextFormField(
                                          controller:
                                          addressController,
                                          enable: true,
                                          readOnly: readOnly,
                                          autoFocus: false,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Enter Gym's address";
                                            }
                                            return null;
                                          },
                                          fontSize: 14.sp,
                                          obscureText: false,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '*Gym Details will be printed on your receipt.*',
                  style: TextStyle(
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                isLoading
                    ? const Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.primaryColor,
                    ))
                    : update
                    ? CustomElevatedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  text: 'Logout',
                  bPadding: EdgeInsets.symmetric(
                      horizontal: 25.w, vertical: 1.w),
                )
                    : CustomElevatedButton(
                  onPressed: () {
                    if (_updateGymKey.currentState!
                        .validate() &&
                        phoneController.text.length == 10) {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        isLoading = true;
                        edit = false;
                        // showLoading();
                      });

                      // MemberData.updateGymDetails(
                      //   updatedGymName:
                      //   gymNameController.text,
                      //   updatedGymPh: phoneController.text,
                      //   updatedGymAdd: addressController.text,
                      //   userId: snapshot.data!.userId,
                      //   updatedGymLogo: _gymLogo?.path,
                      // ).then((value) {
                      //   if (value) {
                      //     setState(() {
                      //       isLoading = false;
                      //       Navigator.pop(context);
                      //     });
                      //     CustomSnackBar(
                      //         context,
                      //         'Gym details updates successfully!',
                      //         true);
                      //     Navigator.pop(context);
                      //   }
                      // });
                    }
                  },
                  text: 'Update',
                  bPadding: EdgeInsets.symmetric(
                      horizontal: 25.w, vertical: 1.w),
                ),
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          )),
    );
    // return WillPopScope(
    //   onWillPop: () async {
    //     final shouldExit = await showDialog(
    //       context: context,
    //       builder: (context) => const HomeScreen(),
    //     );
    //     return shouldExit ?? false; // Handle null case
    //   },
    //   child: StreamBuilder<UserModel>(
    //       stream: MemberData.getUserStream(),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return const Center(
    //               child: CircularProgressIndicator(
    //                 color: ColorsManager.primaryColor,
    //               )); // Show loading indicator while data is loading
    //         } else if (snapshot.hasError) {
    //           return Text('Error: ${snapshot.error}');
    //         } else if (snapshot.data == null) {
    //           return const Text(
    //               'User data is null'); // Handle case where user data is null
    //         } else {
    //           gymNameController.text = snapshot.data!.gymName;
    //           phoneController.text = snapshot.data!.gymPhone;
    //           addressController.text = snapshot.data!.gymAddress;
    //           return Scaffold(
    //             appBar: AppBar(
    //               automaticallyImplyLeading: false,
    //               title: const Text('Profile'),
    //               titleTextStyle: TextStyle(
    //                 fontWeight: FontWeight.bold,
    //                 fontFamily: 'AppFonts',
    //                 color: Colors.white,
    //                 fontSize: 18.sp,
    //               ),
    //               backgroundColor: ColorsManager.blackColor.withOpacity(0.92),
    //             ),
    //             backgroundColor: ColorsManager.offWhiteColor,
    //             body: Form(
    //                 key: _updateGymKey,
    //                 child: SingleChildScrollView(
    //                   child: Column(
    //                     children: <Widget>[
    //                       Stack(
    //                         alignment: Alignment.topCenter,
    //                         children: [
    //                           SizedBox(
    //                             width: 100.w,
    //                             height: update ? 65.h : 78.h,
    //                           ),
    //
    //                           /// OWNER DETAILS
    //                           ClipRRect(
    //                               borderRadius: BorderRadius.only(
    //                                   bottomLeft: Radius.circular(5.w),
    //                                   bottomRight: Radius.circular(5.w)),
    //                               child: SizedBox(
    //                                 width: 100.w,
    //                                 height: 41.h,
    //                                 child: Stack(
    //                                   children: [
    //                                     Positioned.fill(
    //                                       child: Image.asset(
    //                                         'assets/images/img.png',
    //                                         fit: BoxFit.fill,
    //                                       ),
    //                                     ),
    //                                     ColoredBox(
    //                                       color: ColorsManager.transparentColor,
    //                                       child: Padding(
    //                                         padding: EdgeInsets.symmetric(
    //                                             vertical: 4.h, horizontal: 5.w),
    //                                         child: Column(
    //                                           crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                           children: [
    //                                             Row(
    //                                               mainAxisAlignment:
    //                                               MainAxisAlignment
    //                                                   .spaceBetween,
    //                                               children: [
    //                                                 Stack(
    //                                                   children: [
    //                                                     InkWell(
    //                                                       onTap: () {
    //                                                         update
    //                                                             ? ''
    //                                                             : _pickImage(
    //                                                             ImageSource
    //                                                                 .gallery);
    //                                                       },
    //                                                       child: ClipOval(
    //                                                         child: Container(
    //                                                           width: 40.w,
    //                                                           height: 40.w,
    //                                                           decoration:
    //                                                           const BoxDecoration(
    //                                                             shape: BoxShape
    //                                                                 .circle,
    //                                                           ),
    //                                                           child: _gymLogo !=
    //                                                               null
    //                                                               ? CustomProfileImg(
    //                                                               profileImage:
    //                                                               _gymLogo)
    //                                                               : CachedNetworkImage(
    //                                                             imageUrl: snapshot
    //                                                                 .data!
    //                                                                 .gymLogo ??
    //                                                                 '',
    //                                                             fit: BoxFit
    //                                                                 .cover,
    //                                                             placeholder: (context,
    //                                                                 url) =>
    //                                                                 ShimmerEffectCard(
    //                                                                     height:
    //                                                                     40.w,
    //                                                                     width: 40.w),
    //                                                           ),
    //                                                         ),
    //                                                       ),
    //                                                       // child: CustomLogoNetwork(
    //                                                       //   imageUrl: snapshot
    //                                                       //           .data!.gymLogo ??
    //                                                       //       '',
    //                                                       // ),
    //                                                     ),
    //                                                     Visibility(
    //                                                       visible: !update,
    //                                                       child: Positioned(
    //                                                         bottom: 0,
    //                                                         right: 3.w,
    //                                                         child: Container(
    //                                                           padding:
    //                                                           const EdgeInsets
    //                                                               .all(4),
    //                                                           decoration:
    //                                                           const BoxDecoration(
    //                                                             shape: BoxShape
    //                                                                 .circle,
    //                                                             color: ColorsManager
    //                                                                 .whiteColor,
    //                                                           ),
    //                                                           child: const Icon(
    //                                                             Icons.edit,
    //                                                             size: 24,
    //                                                             color: ColorsManager
    //                                                                 .blackColor,
    //                                                           ),
    //                                                         ),
    //                                                       ),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                                 SliderButton(
    //                                                   action: () async {
    //                                                     setState(() {
    //                                                       isVisible = !isVisible;
    //                                                       readOnly = !readOnly;
    //                                                       update = !update;
    //                                                       edit = !edit;
    //                                                     });
    //                                                     return null;
    //                                                   },
    //                                                   buttonSize: 4.h,
    //                                                   vibrationFlag: true,
    //
    //                                                   ///Put label over here
    //                                                   label: Text(
    //                                                     edit
    //                                                         ? 'Slide to Cancel'
    //                                                         : 'Slide to Edit',
    //                                                     style: TextStyle(
    //                                                         fontWeight:
    //                                                         FontWeightManager
    //                                                             .semiBold,
    //                                                         fontFamily:
    //                                                         'AppFonts',
    //                                                         fontSize: edit
    //                                                             ? 11.sp
    //                                                             : 12.sp),
    //                                                   ),
    //                                                   icon: const Center(
    //                                                     child: Icon(Icons.edit),
    //                                                   ),
    //
    //                                                   ///Change All the color and size from here.
    //                                                   width: 45.w,
    //                                                   height: 6.h,
    //                                                   radius: 10,
    //                                                   buttonColor: ColorsManager
    //                                                       .whiteColor,
    //                                                   backgroundColor:
    //                                                   ColorsManager.greyColor,
    //                                                   highlightedColor:
    //                                                   ColorsManager
    //                                                       .primaryColor,
    //                                                   baseColor: ColorsManager
    //                                                       .yellowColor,
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                             SizedBox(
    //                                               height: 2.h,
    //                                             ),
    //                                             SingleChildScrollView(
    //                                               child: Column(
    //                                                 crossAxisAlignment:
    //                                                 CrossAxisAlignment.start,
    //                                                 children: [
    //                                                   Text(
    //                                                     snapshot.data!.ownerName,
    //                                                     style: TextStyle(
    //                                                       fontSize: 20.sp,
    //                                                       color: ColorsManager
    //                                                           .whiteColor,
    //                                                       overflow: TextOverflow
    //                                                           .ellipsis,
    //                                                       fontFamily: 'AppFonts',
    //                                                       fontWeight:
    //                                                       FontWeight.bold,
    //                                                     ),
    //                                                     maxLines: 1,
    //                                                     overflow:
    //                                                     TextOverflow.ellipsis,
    //                                                   ),
    //                                                   SizedBox(
    //                                                     height: 2.h,
    //                                                   ),
    //                                                   Row(
    //                                                     crossAxisAlignment:
    //                                                     CrossAxisAlignment
    //                                                         .center,
    //                                                     mainAxisAlignment:
    //                                                     MainAxisAlignment
    //                                                         .start,
    //                                                     children: [
    //                                                       const Icon(
    //                                                         Icons.email_outlined,
    //                                                         color: ColorsManager
    //                                                             .whiteColor,
    //                                                       ),
    //                                                       SizedBox(
    //                                                         width: 3.w,
    //                                                       ),
    //                                                       SizedBox(
    //                                                         width: 75.w,
    //                                                         height: 3.h,
    //                                                         child:
    //                                                         SingleChildScrollView(
    //                                                           scrollDirection:
    //                                                           Axis.horizontal,
    //                                                           child:
    //                                                           SingleChildScrollView(
    //                                                             child: Text(
    //                                                               snapshot.data!
    //                                                                   .ownerEmail,
    //                                                               style:
    //                                                               TextStyle(
    //                                                                 fontSize:
    //                                                                 13.sp,
    //                                                                 fontFamily:
    //                                                                 'AppFonts',
    //                                                                 color: ColorsManager
    //                                                                     .whiteColor,
    //                                                                 overflow:
    //                                                                 TextOverflow
    //                                                                     .ellipsis,
    //                                                                 fontWeight:
    //                                                                 FontWeight
    //                                                                     .bold,
    //                                                               ),
    //                                                               textAlign:
    //                                                               TextAlign
    //                                                                   .left,
    //                                                               maxLines: 1,
    //                                                               overflow:
    //                                                               TextOverflow
    //                                                                   .ellipsis,
    //                                                             ),
    //                                                           ),
    //                                                         ),
    //                                                       ),
    //                                                     ],
    //                                                   ),
    //                                                 ],
    //                                               ),
    //                                             )
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               )),
    //                           Positioned(
    //                             top: 37.h,
    //                             child: Card(
    //                               elevation: 5,
    //                               surfaceTintColor: ColorsManager.offWhiteColor,
    //                               color: ColorsManager.whiteColor,
    //                               child: SizedBox(
    //                                 width: update ? 80.w : 85.w,
    //                                 height: update ? 25.h : 42.h,
    //                                 child: SingleChildScrollView(
    //                                   child: Column(
    //                                     children: [
    //                                       Center(
    //                                           child: Padding(
    //                                             padding: EdgeInsets.symmetric(
    //                                                 vertical: 2.h),
    //                                             child: Text(
    //                                               'Gym Details',
    //                                               style: TextStyle(
    //                                                 fontSize: 20.sp,
    //                                                 color: ColorsManager.blackColor,
    //                                                 fontFamily: 'AppFonts',
    //                                                 overflow: TextOverflow.ellipsis,
    //                                                 fontWeight: FontWeight.bold,
    //                                               ),
    //                                             ),
    //                                           )),
    //                                       Padding(
    //                                         padding: EdgeInsets.symmetric(
    //                                             vertical: 1.h, horizontal: 5.w),
    //                                         child: Row(
    //                                           mainAxisAlignment:
    //                                           MainAxisAlignment.spaceBetween,
    //                                           children: [
    //                                             Text(
    //                                               "Name :",
    //                                               style: TextStyle(
    //                                                   fontSize: 14.sp,
    //                                                   fontFamily: 'AppFonts',
    //                                                   fontWeight:
    //                                                   FontWeightManager
    //                                                       .semiBold),
    //                                             ),
    //                                             update
    //                                                 ? SizedBox(
    //                                               height: 3.h,
    //                                               width: 40.w,
    //                                               child: Text(
    //                                                 snapshot.data!.gymName,
    //                                                 maxLines: 1,
    //                                                 textAlign:
    //                                                 TextAlign.left,
    //                                                 style: TextStyle(
    //                                                   fontSize: 14.sp,
    //                                                   fontFamily:
    //                                                   'AppFonts',
    //                                                   fontWeight:
    //                                                   FontWeightManager
    //                                                       .semiBold,
    //                                                   color: ColorsManager
    //                                                       .greyColor,
    //                                                   overflow: TextOverflow
    //                                                       .ellipsis,
    //                                                 ),
    //                                               ),
    //                                             )
    //                                                 : SizedBox(
    //                                                 height: 8.h,
    //                                                 width: 50.w,
    //                                                 child:
    //                                                 CustomTextFormField(
    //                                                   controller:
    //                                                   gymNameController,
    //                                                   readOnly: readOnly,
    //                                                   enable: true,
    //                                                   autoFocus: false,
    //                                                   obscureText: false,
    //                                                   validator: (value) {
    //                                                     if (value == null ||
    //                                                         value.isEmpty) {
    //                                                       return "Enter Gym's Name";
    //                                                     }
    //                                                     return null;
    //                                                   },
    //                                                   fontSize: 14.sp,
    //                                                 ))
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       Padding(
    //                                         padding: EdgeInsets.symmetric(
    //                                             vertical: 1.h, horizontal: 5.w),
    //                                         child: Row(
    //                                           mainAxisAlignment:
    //                                           MainAxisAlignment.spaceBetween,
    //                                           children: [
    //                                             Text(
    //                                               "Phone :",
    //                                               style: TextStyle(
    //                                                   fontSize: 14.sp,
    //                                                   fontFamily: 'AppFonts',
    //                                                   fontWeight:
    //                                                   FontWeightManager
    //                                                       .semiBold),
    //                                             ),
    //                                             update
    //                                                 ? SizedBox(
    //                                               height: 3.h,
    //                                               width: 40.w,
    //                                               child: Text(
    //                                                 snapshot.data!.gymPhone,
    //                                                 textAlign:
    //                                                 TextAlign.left,
    //                                                 maxLines: 1,
    //                                                 style: TextStyle(
    //                                                   fontSize: 14.sp,
    //                                                   fontFamily:
    //                                                   'AppFonts',
    //                                                   color: ColorsManager
    //                                                       .greyColor,
    //                                                   fontWeight:
    //                                                   FontWeightManager
    //                                                       .semiBold,
    //                                                   overflow: TextOverflow
    //                                                       .ellipsis,
    //                                                 ),
    //                                               ),
    //                                             )
    //                                                 : SizedBox(
    //                                                 height: 8.h,
    //                                                 width: 50.w,
    //                                                 child:
    //                                                 CustomTextFormField(
    //                                                   controller:
    //                                                   phoneController,
    //                                                   enable: true,
    //                                                   readOnly: readOnly,
    //                                                   fontSize: 14.sp,
    //                                                   autoFocus: edit,
    //                                                   validator: (value) {
    //                                                     if (value == null ||
    //                                                         value.isEmpty) {
    //                                                       return "Enter Gym's Contact";
    //                                                     } else if (phoneController
    //                                                         .text
    //                                                         .length !=
    //                                                         10) {
    //                                                       return "Enter a valid Phone Number!";
    //                                                     }
    //                                                     return null;
    //                                                   },
    //                                                   obscureText: false,
    //                                                   keyboardType:
    //                                                   TextInputType.phone,
    //                                                   inputFormatters: [
    //                                                     LengthLimitingTextInputFormatter(
    //                                                         10),
    //                                                     FilteringTextInputFormatter
    //                                                         .digitsOnly,
    //                                                   ],
    //                                                 ))
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       Padding(
    //                                         padding: EdgeInsets.symmetric(
    //                                             vertical: 1.h, horizontal: 5.w),
    //                                         child: Row(
    //                                           mainAxisAlignment:
    //                                           MainAxisAlignment.spaceBetween,
    //                                           children: [
    //                                             Text(
    //                                               "Address : ",
    //                                               style: TextStyle(
    //                                                   fontSize: 14.sp,
    //                                                   fontFamily: 'AppFonts',
    //                                                   fontWeight:
    //                                                   FontWeightManager
    //                                                       .semiBold),
    //                                             ),
    //                                             update
    //                                                 ? SizedBox(
    //                                               height: 3.h,
    //                                               width: 40.w,
    //                                               child:
    //                                               SingleChildScrollView(
    //                                                 scrollDirection:
    //                                                 Axis.horizontal,
    //                                                 child: Text(
    //                                                   snapshot
    //                                                       .data!.gymAddress,
    //                                                   maxLines: 1,
    //                                                   textAlign:
    //                                                   TextAlign.left,
    //                                                   style: TextStyle(
    //                                                     fontSize: 14.sp,
    //                                                     fontFamily:
    //                                                     'AppFonts',
    //                                                     color: ColorsManager
    //                                                         .greyColor,
    //                                                     fontWeight:
    //                                                     FontWeightManager
    //                                                         .semiBold,
    //                                                     overflow:
    //                                                     TextOverflow
    //                                                         .ellipsis,
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             )
    //                                                 : SizedBox(
    //                                               height: 8.h,
    //                                               width: 50.w,
    //                                               child:
    //                                               CustomTextFormField(
    //                                                 controller:
    //                                                 addressController,
    //                                                 enable: true,
    //                                                 readOnly: readOnly,
    //                                                 autoFocus: false,
    //                                                 validator: (value) {
    //                                                   if (value == null ||
    //                                                       value.isEmpty) {
    //                                                     return "Enter Gym's address";
    //                                                   }
    //                                                   return null;
    //                                                 },
    //                                                 fontSize: 14.sp,
    //                                                 obscureText: false,
    //                                               ),
    //                                             )
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       Text(
    //                         '*Gym Details will be printed on your receipt.*',
    //                         style: TextStyle(
    //                           fontSize: 10.sp,
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 8.h,
    //                       ),
    //                       isLoading
    //                           ? const Center(
    //                           child: CircularProgressIndicator(
    //                             color: ColorsManager.primaryColor,
    //                           ))
    //                           : update
    //                           ? CustomElevatedButton(
    //                         onPressed: () {
    //                           _showLogoutDialog(context);
    //                         },
    //                         text: 'Logout',
    //                         bPadding: EdgeInsets.symmetric(
    //                             horizontal: 25.w, vertical: 1.w),
    //                       )
    //                           : CustomElevatedButton(
    //                         onPressed: () {
    //                           if (_updateGymKey.currentState!
    //                               .validate() &&
    //                               phoneController.text.length == 10) {
    //                             setState(() {
    //                               FocusScope.of(context).unfocus();
    //                               isLoading = true;
    //                               edit = false;
    //                               showLoading();
    //                             });
    //
    //                             MemberData.updateGymDetails(
    //                               updatedGymName:
    //                               gymNameController.text,
    //                               updatedGymPh: phoneController.text,
    //                               updatedGymAdd: addressController.text,
    //                               userId: snapshot.data!.userId,
    //                               updatedGymLogo: _gymLogo?.path,
    //                             ).then((value) {
    //                               if (value) {
    //                                 setState(() {
    //                                   isLoading = false;
    //                                   Navigator.pop(context);
    //                                 });
    //                                 CustomSnackBar(
    //                                     context,
    //                                     'Gym details updates successfully!',
    //                                     true);
    //                                 Navigator.pop(context);
    //                               }
    //                             });
    //                           }
    //                         },
    //                         text: 'Update',
    //                         bPadding: EdgeInsets.symmetric(
    //                             horizontal: 25.w, vertical: 1.w),
    //                       ),
    //                       SizedBox(
    //                         height: 1.h,
    //                       ),
    //                     ],
    //                   ),
    //                 )),
    //           );
    //         }
    //       }),
    // );
  }
}
