import 'dart:convert';

import 'package:ams_express/model/report/viewReportEditModel.dart';
import 'package:ams_express/services/database/quickType.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../component/custom_alertdialog.dart';
import '../../component/custom_botToast.dart';
import '../../component/custom_camera.dart';
import '../../component/textformfield/custom_input.dart';
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

  // Modern Blue Color Palette
  final Color primaryColor = Color(0xFF2196F3);
  final Color secondaryColor = Color(0xFF64B5F6);
  final Color accentColor = Color(0xFF00BCD4);
  final Color cardColor = Colors.white;
  final Color greenColor = Color(0xFF4CAF50);
  final Color redColor = Color(0xFFEF5350);

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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.edit_document,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Edit Count Plan : ${plan ?? ""}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Form(
              key: formKeyList[1],
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      dropdownLocation(validator: (value) {
                        return null;
                      }),
                      SizedBox(height: 15),
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
              margin: EdgeInsets.all(16),
              elevation: 8,
              shadowColor: primaryColor.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField2(
        validator: validator,
        focusNode: focus,
        autofocus: true,
        isExpanded: true,
        hint: Row(
          children: [
            Icon(Icons.location_on_rounded,
                color: Colors.grey.shade400, size: 20),
            SizedBox(width: 8),
            Text(
              "Select Location",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        decoration: InputDecoration(
          enabled: false,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        items: [
          DropdownMenuItem<String>(
            value: _selectedLocation,
            child: Row(
              children: [
                Icon(Icons.location_on_rounded,
                    color: Colors.grey.shade400, size: 18),
                SizedBox(width: 8),
                Text(
                  _selectedLocation ?? "--- No data ---",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.grey.shade400,
          ),
          iconSize: 28,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          elevation: 8,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField2(
        focusNode: focus,
        validator: validator,
        autofocus: true,
        isExpanded: true,
        hint: Row(
          children: [
            Icon(Icons.business_rounded, color: Colors.grey.shade400, size: 20),
            SizedBox(width: 8),
            Text(
              "Select Department",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        decoration: InputDecoration(
          enabled: false,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        items: [
          DropdownMenuItem<String>(
            value: _selectedDepartment,
            child: Row(
              children: [
                Icon(Icons.business_rounded,
                    color: Colors.grey.shade400, size: 18),
                SizedBox(width: 8),
                Text(
                  _selectedDepartment ?? "--- No data ---",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.grey.shade400,
          ),
          iconSize: 28,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          elevation: 8,
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:
              BorderSide(color: primaryColor.withOpacity(0.3), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline_rounded, color: primaryColor, size: 18),
            SizedBox(width: 8),
            Text(
              "Select Status",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      items: itemStatus
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: item == 'ปกติ'
                            ? greenColor
                            : item == 'ทรัพย์สินสุญหาย'
                                ? redColor
                                : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
      iconStyleData: IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          color: primaryColor,
        ),
        iconSize: 28,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        elevation: 8,
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
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSave,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        appLocalization.localizations.btn_save,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          // Camera button commented out as in original
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
