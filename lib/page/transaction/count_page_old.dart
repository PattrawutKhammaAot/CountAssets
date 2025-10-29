// import 'package:ams_express/component/custom_alertdialog.dart';
// import 'package:ams_express/component/custom_botToast.dart';
// import 'package:ams_express/component/custom_camera.dart';
// import 'package:ams_express/component/custombutton.dart';
// import 'package:ams_express/component/textformfield/custom_input.dart';
// import 'package:ams_express/extension/color_extension.dart';
// import 'package:ams_express/main.dart';
// import 'package:ams_express/model/count/countModelEvent.dart';
// import 'package:ams_express/model/count/responseCountModel.dart';
// import 'package:ams_express/model/department/departmentModel.dart';
// import 'package:ams_express/model/location/locationModel.dart';
// import 'package:ams_express/services/database/count_db.dart';
// import 'package:ams_express/services/database/department_db.dart';
// import 'package:ams_express/services/database/gallery_db.dart';
// import 'package:ams_express/services/database/location_db.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

// class CountPage extends StatefulWidget {
//   @override
//   State<CountPage> createState() => _CountPageState();
// }

// class _CountPageState extends State<CountPage> {
//   TextEditingController barcodeController = TextEditingController();
//   TextEditingController assetNoController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController costCenterController = TextEditingController();
//   TextEditingController departmentController = TextEditingController();
//   TextEditingController qtyController = TextEditingController();
//   TextEditingController capDateController = TextEditingController();
//   TextEditingController remarkController = TextEditingController();
//   TextEditingController checkController = TextEditingController();
//   TextEditingController scanDateController = TextEditingController();

//   List<LocationModel> location = [];
//   List<DepartmentModel> department = [];
//   final List<GlobalObjectKey<FormState>> formKeyList =
//       List.generate(10, (index) => GlobalObjectKey<FormState>(index));
//   String? plan;
//   String? _selectedLocation;
//   String? _selectedDepartment;
//   String? selectedStatus = 'ปกติ';
//   FocusNode _barcodeFocus = FocusNode();
//   FocusNode _assetNoFocus = FocusNode();
//   FocusNode _nameFocus = FocusNode();
//   FocusNode _costCenterFocus = FocusNode();
//   FocusNode _departmentFocus = FocusNode();
//   FocusNode _qtyFocus = FocusNode();
//   FocusNode _capDateFocus = FocusNode();
//   FocusNode _remarkFocus = FocusNode();
//   FocusNode _checkFocus = FocusNode();
//   FocusNode _scanDateFocus = FocusNode();

//   @override
//   void initState() {
//     LocationDB().getLocation().then((value) {
//       location = value;
//       setState(() {});
//     });
//     DepartmenDB().getDepartment().then((value) {
//       department = value;
//       setState(() {});
//     });

//     Future.microtask(() {
//       final args = ModalRoute.of(context)?.settings.arguments as String?;
//       if (args != null) {
//         setState(() {
//           plan = args;
//         });
//       }
//     });
//     _barcodeFocus.requestFocus();
//     super.initState();
//   }

//   Future onChangeValue(bool isTakeBarcode) async {
//     ResponseCountModel item = ResponseCountModel();
//     selectedStatus = 'ปกติ';
//     if (isTakeBarcode) {
//       item = await CountDB().readQrCodeAndBarcode(
//         context,
//         CountModelEvent(
//           plan: plan,
//           location: _selectedLocation,
//           department: _selectedDepartment,
//           statusAsset: selectedStatus,
//           qty: qtyController.text,
//           // remark: remarkController.text,
//         ),
//       );
//     } else {
//       item = await CountDB().scanCount(
//           CountModelEvent(
//             barcode: barcodeController.text.toUpperCase(),
//             plan: plan,
//             location: _selectedLocation,
//             department: _selectedDepartment,
//             statusAsset: selectedStatus,
//             qty: qtyController.text,
//             // remark: remarkController.text,
//           ),
//           context);
//     }

//     assetNoController.text = item.asset ?? "";
//     nameController.text = item.name ?? "";
//     costCenterController.text = item.costCenter ?? "";
//     departmentController.text = item.department ?? "";
//     qtyController.text =
//         (item.qty == null || item.qty == "null" || item.qty == "")
//             ? ""
//             : item.qty!;
//     capDateController.text = (item.cap_date == null ||
//             item.cap_date == "null" ||
//             item.cap_date == "")
//         ? ""
//         : item.cap_date!;
//     remarkController.text =
//         (item.remark == null || item.remark == "null" || item.remark == "")
//             ? ""
//             : item.remark!;
//     checkController.text = item.check ?? "";
//     scanDateController.text = item.scanDate ?? "";
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 21, 101, 192),
//         iconTheme: IconThemeData(
//           color: Colors.white, // Change this to your desired color
//         ),
//         title: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Count Plan : ${plan}',
//               style: TextStyle(color: Colors.white),
//             )),
//       ),
//       body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             Form(
//               key: formKeyList[1],
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 21, 101, 192),
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(50),
//                     bottomLeft: Radius.circular(50),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     children: [
//                       dropdownLocation(validator: (value) {
//                         return null;
//                       }),
//                       SizedBox(height: 10),
//                       dropdownDepartment(validator: (value) {
//                         return null;
//                       }),
//                       SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Card(
//               shadowColor: Colors.black,
//               elevation: 10,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Custominput(
//                       labelText: "Barcode",
//                       controller: barcodeController,
//                       focusNode: _barcodeFocus,
//                       onEditingComplete: () async {
//                         if (formKeyList[1].currentState!.validate()) {
//                           if ((_selectedDepartment != null &&
//                                   _selectedDepartment!.isNotEmpty) ||
//                               (_selectedLocation != null &&
//                                   _selectedLocation!.isNotEmpty)) {
//                             await onChangeValue(false);
//                           } else {
//                             CustomAlertDialog(
//                               title:
//                                   appLocalization.localizations.warning_title,
//                               message:
//                                   appLocalization.localizations.warning_content,
//                               isWarning: true,
//                             ).show(context);
//                           }
//                         }

//                         barcodeController.clear();
//                       },
//                       suffix: IconButton(
//                           onPressed: () async {
//                             if (formKeyList[1].currentState!.validate()) {
//                               if ((_selectedDepartment != null &&
//                                       _selectedDepartment!.isNotEmpty) ||
//                                   (_selectedLocation != null &&
//                                       _selectedLocation!.isNotEmpty)) {
//                                 await onChangeValue(true);
//                               } else {
//                                 CustomAlertDialog(
//                                   title: appLocalization
//                                       .localizations.warning_title,
//                                   message: appLocalization
//                                       .localizations.warning_content,
//                                   isWarning: true,
//                                 ).show(context);
//                               }
//                             }
//                           },
//                           icon: Icon(Icons.qr_code_scanner)),
//                     ),
//                     const SizedBox(height: 10),
//                     Custominput(
//                       focusNode: _assetNoFocus,
//                       labelText: "Asset No",
//                       readOnly: true,
//                       controller: assetNoController,
//                     ),
//                     const SizedBox(height: 10),
//                     Custominput(
//                       focusNode: _nameFocus,
//                       labelText: "Name",
//                       readOnly: true,
//                       controller: nameController,
//                     ),
//                     const SizedBox(height: 10),
//                     Custominput(
//                       focusNode: _costCenterFocus,
//                       labelText: "Cost Center",
//                       readOnly: true,
//                       controller: costCenterController,
//                     ),
//                     const SizedBox(height: 10),
//                     Custominput(
//                         focusNode: _departmentFocus,
//                         labelText: "Department",
//                         readOnly: true,
//                         controller: departmentController),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                             child: Custominput(
//                           focusNode: _qtyFocus,
//                           labelText: "Qty",
//                           controller: qtyController,
//                           readOnly: true,
//                         )),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                             child: Custominput(
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 0),
//                                 focusNode: _capDateFocus,
//                                 labelText: "Cap Date",
//                                 controller: capDateController,
//                                 readOnly: true)),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     dropdownStatus(),
//                     SizedBox(height: 10),
//                     Custominput(
//                         labelText: "Remark", controller: remarkController),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                             child: Custominput(
//                           labelText: "Check",
//                           controller: checkController,
//                           readOnly: true,
//                         )),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                             child: Custominput(
//                                 labelText: "Scan Date",
//                                 readOnly: true,
//                                 controller: scanDateController)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             _buttonWidget(onSave: () async {
//               if (assetNoController.text.isEmpty) {
//                 CustomBotToast.showWarning(
//                     appLocalization.localizations.warning_uncheck_save);
//                 return;
//               }
//               var result = await CountDB().btnSave(
//                 CountModelEvent(
//                   barcode: assetNoController.text,
//                   plan: plan,
//                   statusAsset: selectedStatus,
//                   remark: remarkController.text,
//                 ),
//               );
//               if (result) {
//                 CustomBotToast.showSuccess(
//                     appLocalization.localizations.update_success);
//               }
//               _barcodeFocus.requestFocus();
//             }, onCamera: () async {
//               if (assetNoController.text.isEmpty) {
//                 CustomBotToast.showWarning(
//                     appLocalization.localizations.warning_uncheck_photo);
//                 return;
//               }
//               var result = await CustomCamera().pickFileFromCamera();

//               if (result != null) {
//                 var isSuccess = await GalleryDB()
//                     .insertImage(result.path, plan!, assetNoController.text);
//                 if (isSuccess) {
//                   CustomBotToast.showSuccess(
//                       appLocalization.localizations.upload_image_success);
//                 } else {
//                   CustomBotToast.showError("Failed to Upload");
//                 }
//               }
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget dropdownLocation(
//       {String? Function(String?)? validator, FocusNode? focus}) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15), color: Colors.white),
//       child: DropdownButtonFormField2(
//         validator: validator,
//         focusNode: focus,
//         autofocus: true,
//         isExpanded: true,
//         hint: Text(
//           "Select Location",
//           textAlign: TextAlign.center,
//         ),
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(vertical: 16),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         items: location
//             .map((LocationModel item) => DropdownMenuItem<String>(
//                   value: item.location,
//                   child: Text(
//                     "Location : ${item.location!}",
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ))
//             .toList(),
//         value: _selectedLocation,
//         onChanged: (value) async {
//           _selectedLocation = value.toString();
//           _barcodeFocus.requestFocus();
//           setState(() {});
//         },
//         onSaved: (value) {
//           _selectedLocation = value.toString();
//           setState(() {});
//         },
//         buttonStyleData: const ButtonStyleData(
//           padding: EdgeInsets.only(right: 8),
//         ),
//         iconStyleData: const IconStyleData(
//           icon: Icon(
//             Icons.arrow_drop_down,
//             color: Colors.black45,
//           ),
//           iconSize: 24,
//         ),
//         dropdownStyleData: DropdownStyleData(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         menuItemStyleData: const MenuItemStyleData(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//         ),
//       ),
//     );
//   }

//   Widget dropdownDepartment(
//       {String? Function(String?)? validator, FocusNode? focus}) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15), color: Colors.white),
//       child: DropdownButtonFormField2(
//         focusNode: focus,
//         validator: validator,
//         autofocus: true,
//         isExpanded: true,
//         hint: Text(
//           "Select Department",
//           textAlign: TextAlign.center,
//         ),
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(vertical: 16),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         items: department
//             .map((DepartmentModel item) => DropdownMenuItem<String>(
//                   value: item.department,
//                   child: Text(
//                     "Department : ${item.department!}",
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ))
//             .toList(),
//         value: _selectedDepartment,
//         onChanged: (value) {
//           if (value != null) {
//             _selectedDepartment = value.toString();
//             _barcodeFocus.requestFocus();
//           }
//           setState(() {});
//         },
//         onSaved: (value) {
//           if (value != null) {}
//           setState(() {});
//         },
//         buttonStyleData: const ButtonStyleData(
//           padding: EdgeInsets.only(right: 8),
//         ),
//         iconStyleData: const IconStyleData(
//           icon: Icon(
//             Icons.arrow_drop_down,
//             color: Colors.black45,
//           ),
//           iconSize: 24,
//         ),
//         dropdownStyleData: DropdownStyleData(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         menuItemStyleData: const MenuItemStyleData(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//         ),
//       ),
//     );
//   }

//   Widget dropdownStatus({FocusNode? focus}) {
//     List<String> itemStatus = [
//       'ปกติ',
//       'ทรัพย์สินชำรุด',
//       'ส่งซ่อม',
//       'รอตัดทรัพย์สิน/ขาย',
//       'ใช้งานไม่ได้',
//       'อื่นๆ',
//       'ทรัพย์สินสุญหาย'
//     ];

//     return DropdownButtonFormField2(
//       focusNode: focus,
//       isExpanded: true,
//       decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(vertical: 16),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           label: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text("Select Status"),
//           )),
//       items: itemStatus
//           .map((String item) => DropdownMenuItem<String>(
//                 value: item,
//                 child: Text(
//                   " ${item}",
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.black,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ))
//           .toList(),
//       value: selectedStatus,
//       onChanged: (value) {
//         selectedStatus = value.toString();
//       },
//       onSaved: (value) {
//         selectedStatus = value.toString();
//       },
//       buttonStyleData: const ButtonStyleData(
//         padding: EdgeInsets.only(right: 8),
//       ),
//       iconStyleData: const IconStyleData(
//         icon: Icon(
//           Icons.arrow_drop_down,
//           color: Colors.black45,
//         ),
//         iconSize: 24,
//       ),
//       dropdownStyleData: DropdownStyleData(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//       menuItemStyleData: const MenuItemStyleData(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//       ),
//     );
//   }

//   Widget _buttonWidget({
//     dynamic Function()? onSave,
//     dynamic Function()? onCamera,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Expanded(
//             child: CustomButton(
//               icon: Icons.save,
//               text: appLocalization.localizations.btn_save,
//               onPressed: onSave,
//               color: AppColors.contentColorBlue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
