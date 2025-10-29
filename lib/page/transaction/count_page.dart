import 'package:ams_express/component/custom_alertdialog.dart';
import 'package:ams_express/component/custom_botToast.dart';
import 'package:ams_express/component/custom_camera.dart';
import 'package:ams_express/component/textformfield/custom_input.dart';
import 'package:ams_express/main.dart';
import 'package:ams_express/model/count/countModelEvent.dart';
import 'package:ams_express/model/count/responseCountModel.dart';
import 'package:ams_express/model/department/departmentModel.dart';
import 'package:ams_express/model/location/locationModel.dart';
import 'package:ams_express/services/database/count_db.dart';
import 'package:ams_express/services/database/department_db.dart';
import 'package:ams_express/services/database/gallery_db.dart';
import 'package:ams_express/services/database/location_db.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CountPage extends StatefulWidget {
  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
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

  List<LocationModel> location = [];
  List<DepartmentModel> department = [];
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
  FocusNode _checkFocus = FocusNode();
  FocusNode _scanDateFocus = FocusNode();

  // Modern Blue Color Palette
  final Color primaryColor = Color(0xFF2196F3);
  final Color secondaryColor = Color(0xFF64B5F6);
  final Color accentColor = Color(0xFF00BCD4);
  final Color cardColor = Colors.white;
  final Color greenColor = Color(0xFF4CAF50);
  final Color redColor = Color(0xFFEF5350);

  @override
  void initState() {
    LocationDB().getLocation().then((value) {
      location = value;
      setState(() {});
    });
    DepartmenDB().getDepartment().then((value) {
      department = value;
      setState(() {});
    });

    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments as String?;
      if (args != null) {
        setState(() {
          plan = args;
        });
      }
    });
    _barcodeFocus.requestFocus();
    super.initState();
  }

  Future onChangeValue(bool isTakeBarcode) async {
    ResponseCountModel item = ResponseCountModel();
    selectedStatus = 'ปกติ';
    if (isTakeBarcode) {
      item = await CountDB().readQrCodeAndBarcode(
        context,
        CountModelEvent(
          plan: plan,
          location: _selectedLocation,
          department: _selectedDepartment,
          statusAsset: selectedStatus,
          qty: qtyController.text,
          // remark: remarkController.text,
        ),
      );
    } else {
      item = await CountDB().scanCount(
          CountModelEvent(
            barcode: barcodeController.text.toUpperCase(),
            plan: plan,
            location: _selectedLocation,
            department: _selectedDepartment,
            statusAsset: selectedStatus,
            qty: qtyController.text,
            // remark: remarkController.text,
          ),
          context);
    }

    assetNoController.text = item.asset ?? "";
    nameController.text = item.name ?? "";
    costCenterController.text = item.costCenter ?? "";
    departmentController.text = item.department ?? "";
    qtyController.text =
        (item.qty == null || item.qty == "null" || item.qty == "")
            ? ""
            : item.qty!;
    capDateController.text = (item.cap_date == null ||
            item.cap_date == "null" ||
            item.cap_date == "")
        ? ""
        : item.cap_date!;
    remarkController.text =
        (item.remark == null || item.remark == "null" || item.remark == "")
            ? ""
            : item.remark!;
    checkController.text = item.check ?? "";
    scanDateController.text = item.scanDate ?? "";
    setState(() {});
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
                Icons.assignment_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Count Plan : ${plan ?? ""}',
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
                    Custominput(
                      labelText: "Barcode",
                      controller: barcodeController,
                      focusNode: _barcodeFocus,
                      onEditingComplete: () async {
                        if (formKeyList[1].currentState!.validate()) {
                          if ((_selectedDepartment != null &&
                                  _selectedDepartment!.isNotEmpty) ||
                              (_selectedLocation != null &&
                                  _selectedLocation!.isNotEmpty)) {
                            await onChangeValue(false);
                          } else {
                            CustomAlertDialog(
                              title:
                                  appLocalization.localizations.warning_title,
                              message:
                                  appLocalization.localizations.warning_content,
                              isWarning: true,
                            ).show(context);
                          }
                        }

                        barcodeController.clear();
                      },
                      suffix: IconButton(
                          onPressed: () async {
                            if (formKeyList[1].currentState!.validate()) {
                              if ((_selectedDepartment != null &&
                                      _selectedDepartment!.isNotEmpty) ||
                                  (_selectedLocation != null &&
                                      _selectedLocation!.isNotEmpty)) {
                                await onChangeValue(true);
                              } else {
                                CustomAlertDialog(
                                  title: appLocalization
                                      .localizations.warning_title,
                                  message: appLocalization
                                      .localizations.warning_content,
                                  isWarning: true,
                                ).show(context);
                              }
                            }
                          },
                          icon: Icon(Icons.qr_code_scanner)),
                    ),
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
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
                        labelText: "Remark", controller: remarkController),
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
              if (assetNoController.text.isEmpty) {
                CustomBotToast.showWarning(
                    appLocalization.localizations.warning_uncheck_save);
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
              if (assetNoController.text.isEmpty) {
                CustomBotToast.showWarning(
                    appLocalization.localizations.warning_uncheck_photo);
                return;
              }
              var result = await CustomCamera().pickFileFromCamera();

              if (result != null) {
                var isSuccess = await GalleryDB()
                    .insertImage(result.path, plan!, assetNoController.text);
                if (isSuccess) {
                  CustomBotToast.showSuccess(
                      appLocalization.localizations.upload_image_success);
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
            Icon(Icons.location_on_rounded, color: primaryColor, size: 20),
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: location
            .map((LocationModel item) => DropdownMenuItem<String>(
                  value: item.location,
                  child: Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          color: primaryColor, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Location : ${item.location!}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
        value: _selectedLocation,
        onChanged: (value) async {
          _selectedLocation = value.toString();
          _barcodeFocus.requestFocus();
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
            Icon(Icons.business_rounded, color: primaryColor, size: 20),
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: department
            .map((DepartmentModel item) => DropdownMenuItem<String>(
                  value: item.department,
                  child: Row(
                    children: [
                      Icon(Icons.business_rounded,
                          color: primaryColor, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Department : ${item.department!}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
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
        ],
      ),
    );
  }
}
