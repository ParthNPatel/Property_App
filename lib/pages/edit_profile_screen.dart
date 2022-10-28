import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:luxepass/constants/common_method.dart';
import '../../constants/constant_colors.dart';
import '../../models/CountryModel.dart';
import '../constants/common_widget.dart';
import '../constants/const_variables.dart';
import '../get_storage_services/get_storage_service.dart';
import '../providers/navbar_provider.dart';
import '../services/locator_service.dart';
import '../utils/navigator.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController? nameController;
  late CountryModel selectedCountry;
  String? liveImageURL;
  bool isSignIn = false;
  bool google = false;
  File? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController =
        TextEditingController(text: GetStorageServices.getNameValue());
    liveImageURL = GetStorageServices.getProfileImageValue();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          Scaffold(backgroundColor: ConstColors.backgroundColor, body: _body()),
    );
  }

  Widget _body() {
    var width = MediaQuery.of(context).size.width;
    var safearea = MediaQuery.of(context).padding.top;

    return ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ConstVar.backgroundImg), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
                title: Text(
                  "Edit Profile",
                  style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0,
                      color: Colors.black),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              //   child: Row(
              //     children: [
              //       IconButton(
              //         onPressed: () {
              //           Get.back();
              //         },
              //         icon: Icon(Icons.arrow_back_ios),
              //       ),
              //       Spacer(),
              //       Text(
              //         "Edit Profile",
              //         style: GoogleFonts.urbanist(
              //             fontWeight: FontWeight.w700,
              //             fontSize: 20.0,
              //             color: Colors.black),
              //       ),
              //       Spacer(),
              //     ],
              //   ),
              // ),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.5)),
                    child: image == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Image.network(
                                GetStorageServices.getProfileImageValue(),
                                fit: BoxFit.cover))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Image.file(image!, fit: BoxFit.cover)),
                  ),
                  Positioned(
                    bottom: 20,
                    right: -5,
                    child: CircleAvatar(
                        backgroundColor: ConstColors.darkColor,
                        child: IconButton(
                            onPressed: () {
                              showDialogWidget();
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ))),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      hintText: 'User Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                              color: ConstColors.widgetDividerColor,
                              width: 1.0))),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  print('enter thg escree ');

                  if (image != null || nameController!.text.isNotEmpty) {
                    try {
                      print('enter thg escree ');
                      progress!.show();
                      if (image != null) {
                        var snapshot = await FirebaseStorage.instance
                            .ref()
                            .child(
                                'AllUserImage/${DateTime.now().microsecondsSinceEpoch}')
                            .putFile(image!);
                        liveImageURL = await snapshot.ref.getDownloadURL();
                      }
                      await FirebaseFirestore.instance
                          .collection('All_User_Details')
                          .doc(GetStorageServices.getToken())
                          .update({
                        'profile_image': liveImageURL,
                        'user_name': nameController!.text.toString(),
                        'is_Profile_check': true
                      });
                      CommonMethode.setProfileAllDetails(
                          imageUrl: liveImageURL!,
                          name: nameController!.text.toString());

                      locator<NavBarIndex>().setTabCount(4);
                      MyNavigator.goToHome(context);

                      progress.dismiss();
                    } catch (e) {
                      progress!.dismiss();

                      return CommonWidget.getSnackBar(
                          message: 'went-wrong',
                          title: 'Failed',
                          duration: 2,
                          color: Colors.red);
                    }
                  } else {
                    CommonWidget.getSnackBar(
                        message: 'Photo & Name are required',
                        title: 'required',
                        duration: 2,
                        color: Colors.red);
                  }
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: ConstColors.darkColor,
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    ));
  }

  imageUpload() async {
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('AllUserImage/${DateTime.now().microsecondsSinceEpoch}')
        .putFile(image!);
    liveImageURL = await snapshot.ref.getDownloadURL();
  }

  showDialogWidget() {
    return showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        await imageFromGallery();
                      },
                      child: Container(
                        height: 40,
                        width: 160,
                        decoration: BoxDecoration(
                            color: ConstColors.darkColor,
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            'Gallery',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        await imageFromCamera();
                      },
                      child: Container(
                        height: 40,
                        width: 160,
                        decoration: BoxDecoration(
                            color: ConstColors.darkColor,
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            'Camera',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ));
  }

  imageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickImage =
        await _picker.pickImage(source: ImageSource.gallery);
    image = File(pickImage!.path);
    setState(() {});
  }

  imageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickImage =
        await _picker.pickImage(source: ImageSource.camera);
    image = File(pickImage!.path);
    setState(() {});
  }
}