import 'dart:convert';

import 'package:ams_express/component/custombutton.dart';
import 'package:ams_express/model/report/viewReportEditModel.dart';
import 'package:ams_express/services/database/quickType.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../component/custom_alertdialog.dart';
import '../../component/custom_botToast.dart';
import '../../component/custom_camera.dart';
import '../../component/textformfield/custom_input.dart';
import '../../extension/color_extension.dart';
import '../../main.dart';
import '../../model/count/countModelEvent.dart';
import '../../services/database/count_db.dart';
import '../../services/database/gallery_db.dart';

class EditDataCountPage extends StatefulWidget {
  const EditDataCountPage({super.key});

  @override
  State<EditDataCountPage> createState() => _EditDataCountPageState();
}

class _EditDataCountPageState extends State<EditDataCountPage> {
  Map<String, dynamic> dataJson = {"plan": '', "asset": ''};

  TextEditingController barcodeController = TextEditingController();
  TextEditingController assetNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController costCenterController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController capDateController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController checkController = TextEditingController();
  TextEditingController scanDateController = TextEditingController();

  final List<GlobalObjectKey<FormState>> formKeyList =
      List.generate(10, (index) => GlobalObjectKey<FormState>(index));
  String? plan;
  String? _selectedLocation;
  String? _selectedDepartment;
  String? selectedStatus = 'ปกติ';
  FocusNode _barcodeFocus = FocusNode();
  FocusNode _assetNoFocus = FocusNode();
  FocusNode _nameFocus = FocusNode();
  FocusNode _costCenterFocus = FocusNode();
  FocusNode _departmentFocus = FocusNode();
  FocusNode _qtyFocus = FocusNode();
  FocusNode _capDateFocus = FocusNode();
  FocusNode _remarkFocus = FocusNode();
  ViewReportEditModel itemModel = ViewReportEditModel();
  @override
  void initState() {
    setValue();
    // TODO: implement initState
    super.initState();
  }

  Future setValue() async {
    Future.microtask(() async {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        dataJson = jsonDecode(jsonEncode(args));
        plan = dataJson['plan'];
        assetNoController.text = dataJson['asset'];
        itemModel = await CountDB()
            .getAssetEdit(plan: plan!, asset: assetNoController.text);

        nameController.text = itemModel.description ?? "";
        costCenterController.text = itemModel.costCenter ?? "";
        departmentController.text = itemModel.departmen ?? "";
        qtyController.text = (itemModel.qty == null ||
                itemModel.qty == "null" ||
                itemModel.qty == "")
            ? ""
            : itemModel.qty!;
        capDateController.text = (itemModel.cap == null ||
                itemModel.cap == "null" ||
                itemModel.cap == "")
            ? ""
            : itemModel.cap!;
        remarkController.text = (itemModel.remark == null ||
                itemModel.remark == "null" ||
                itemModel.remark == "")
            ? ""
            : itemModel.remark!;
        checkController.text = itemModel.statusCheck ?? "";
        scanDateController.text = itemModel.scanDate ?? "";

        selectedStatus = itemModel.statusAsset ?? "ปกติ";

        _selectedDepartment = itemModel.countDepartment;
        _selectedLocation = itemModel.countLocation;

        _remarkFocus.requestFocus();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 21, 101, 192),
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Count Plan : ${plan}',
              style: TextStyle(color: Colors.white),
            )),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Form(
              key: formKeyList[1],
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 21, 101, 192),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      dropdownLocation(validator: (value) {
                        return null;
                      }),
                      SizedBox(height: 10),
                      dropdownDepartment(validator: (value) {
                        return null;
                      }),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              shadowColor: Colors.black,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Custominput(
                      focusNode: _assetNoFocus,
                      labelText: "Asset No",
                      readOnly: true,
                      controller: assetNoController,
                    ),
                    const SizedBox(height: 10),
                    Custominput(
                      focusNode: _nameFocus,
                      labelText: "Name",
                      readOnly: true,
                      controller: nameController,
                    ),
                    const SizedBox(height: 10),
                    Custominput(
                      focusNode: _costCenterFocus,
                      labelText: "Cost Center",
                      readOnly: true,
                      controller: costCenterController,
                    ),
                    const SizedBox(height: 10),
                    Custominput(
                        focusNode: _departmentFocus,
                        labelText: "Department",
                        readOnly: true,
                        controller: departmentController),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Custominput(
                          focusNode: _qtyFocus,
                          labelText: "Qty",
                          controller: qtyController,
                          readOnly: true,
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Custominput(
                                focusNode: _capDateFocus,
                                labelText: "Cap Date",
                                controller: capDateController,
                                readOnly: true)),
                      ],
                    ),
                    SizedBox(height: 10),
                    dropdownStatus(),
                    SizedBox(height: 10),
                    Custominput(
                      labelText: "Remark",
                      controller: remarkController,
                      focusNode: _remarkFocus,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Custominput(
                          labelText: "Check",
                          controller: checkController,
                          readOnly: true,
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Custominput(
                                labelText: "Scan Date",
                                readOnly: true,
                                controller: scanDateController)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buttonWidget(onSave: () async {
              if (checkController.text == StatusCheck.status_uncheck) {
                CustomAlertDialog(
                  title: appLocalization.localizations.warning_title,
                  message: appLocalization.localizations.warning_uncheck_save,
                  isWarning: true,
                ).show(context);
                return;
              }
              var result = await CountDB().btnSave(
                CountModelEvent(
                  barcode: assetNoController.text,
                  plan: plan,
                  statusAsset: selectedStatus,
                  remark: remarkController.text,
                ),
              );
              if (result) {
                CustomBotToast.showSuccess(
                    appLocalization.localizations.update_success);
              }
              _barcodeFocus.requestFocus();
            }, onCamera: () async {
              if (checkController.text == StatusCheck.status_uncheck) {
                CustomAlertDialog(
                  title: appLocalization.localizations.warning_title,
                  message: appLocalization.localizations.warning_uncheck_photo,
                  isWarning: true,
                ).show(context);

                return;
              }
              var result = await CustomCamera().pickFileFromCamera();

              if (result != null) {
                var isSuccess = await GalleryDB()
                    .insertImage(result.path, plan!, assetNoController.text);
                if (isSuccess) {
                  CustomBotToast.showSuccess(
                      appLocalization.localizations.update_image_success);
                } else {
                  CustomBotToast.showError("Failed to Upload");
                }
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget dropdownLocation(
      {String? Function(String?)? validator, FocusNode? focus}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: DropdownButtonFormField2(
        validator: validator,
        focusNode: focus,
        autofocus: true,
        isExpanded: true,
        hint: Text(
          "Select Location",
          textAlign: TextAlign.center,
        ),
        decoration: InputDecoration(
          enabled: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        items: [
          DropdownMenuItem<String>(
            value: _selectedLocation,
            child: Text(_selectedLocation ?? "--- No data ---"),
          ),
        ],
        value: _selectedLocation,
        onChanged: (value) async {
          if (value != null) {
            _selectedLocation = value.toString();
            _departmentFocus.requestFocus();
          }

          setState(() {});
        },
        onSaved: (value) {
          _selectedLocation = value.toString();
          setState(() {});
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black45,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget dropdownDepartment(
      {String? Function(String?)? validator, FocusNode? focus}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: DropdownButtonFormField2(
        focusNode: focus,
        validator: validator,
        autofocus: true,
        isExpanded: true,
        hint: Text(
          "Select Department",
          textAlign: TextAlign.center,
        ),
        decoration: InputDecoration(
          enabled: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        items: [
          DropdownMenuItem<String>(
            value: _selectedDepartment,
            child: Text(_selectedDepartment ?? "--- No data ---"),
          ),
        ],
        value: _selectedDepartment,
        onChanged: (value) {
          if (value != null) {
            _selectedDepartment = value.toString();
            _barcodeFocus.requestFocus();
          }
          setState(() {});
        },
        onSaved: (value) {
          if (value != null) {}
          setState(() {});
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black45,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget dropdownStatus({FocusNode? focus}) {
    List<String> itemStatus = [
      'ปกติ',
      'ทรัพย์สินชำรุด',
      'ส่งซ่อม',
      'รอตัดทรัพย์สิน/ขาย',
      'ใช้งานไม่ได้',
      'อื่นๆ',
      'ทรัพย์สินสุญหาย'
    ];

    return DropdownButtonFormField2(
      focusNode: focus,
      isExpanded: true,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Select Status"),
          )),
      items: itemStatus
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  " ${item}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      value: selectedStatus,
      onChanged: (value) {
        selectedStatus = value.toString();
      },
      onSaved: (value) {
        selectedStatus = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buttonWidget({
    dynamic Function()? onSave,
    dynamic Function()? onCamera,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              icon: Icons.save,
              text: appLocalization.localizations.btn_save,
              onPressed: onSave,
              color: AppColors.contentColorBlue,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          // Expanded(
          //   child: CustomButton(
          //     icon: Icons.camera_enhance,
          //     text: appLocalization.localizations.btn_camera,
          //     onPressed: onCamera,
          //     color: AppColors.contentColorOrange,
          //   ),
          // ),
        ],
      ),
    );
  }
}
