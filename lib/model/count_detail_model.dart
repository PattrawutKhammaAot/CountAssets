class CountDetailFields {
  // สร้างเป็นลิสรายการสำหรับคอลัมน์ฟิลด์
  static final List<String> values = [
    count_detail_id,
    count_master_id,
    asset_code,
    asset_name,
    cost_center,
    cap_date,
    location_name,
    department_name,
    owner_name,
    udf_1,
    udf_2,
    status,
    remark,
    is_check,
    location_check,
    department_check,
    status_count,
    scan_date,
    is_plan,
  ];

  // กำหนดแต่ละฟิลด์ของตาราง ต้องเป็น String ทั้งหมด
  static final String count_detail_id =
      'count_detail_id'; // ตัวแรกต้องเป็น _id ส่วนอื่นใช้ชื่อะไรก็ได้
  static final String count_master_id =
      'count_master_id'; // ตัวแรกต้องเป็น _id ส่วนอื่นใช้ชื่อะไรก็ได้
  static final String asset_code = 'asset_code';
  static final String asset_name = 'asset_name';
  static final String cost_center = 'cost_center';
  static final String cap_date = 'cap_date';
  static final String location_name = 'location_name';
  static final String department_name = 'department_name';
  static final String owner_name = 'owner_name';
  static final String udf_1 = 'udf_1';
  static final String udf_2 = 'udf_2';
  static final String status = 'status';
  static final String remark = 'remark';
  static final String is_check = 'is_check';
  static final String location_check = 'location_check';
  static final String department_check = 'department_check';
  static final String status_count = 'status_count';
  static final String scan_date = 'scan_date';
  static final String is_plan = 'is_plan';
}

// ส่วนของ Data Model ของหนังสือ
class CountDetail {
  final int? count_detail_id; // จะใช้ค่าจากที่ gen ในฐานข้อมูล
  final int count_master_id;
  final String asset_code;
  final String asset_name;
  final String? cost_center;
  final DateTime? cap_date;
  final String location_name;
  final String department_name;
  final String? owner_name;
  final String? udf_1;
  final String? udf_2;
  final String? status;
  final String? remark;
  final bool is_check;
  final String? location_check;
  final String? department_check;
  final String? status_count;
  final DateTime? scan_date;
  final bool is_plan;

  // constructor
  const CountDetail(
      {this.count_detail_id,
      required this.count_master_id,
      required this.asset_code,
      required this.asset_name,
      this.cost_center,
      this.cap_date,
      required this.location_name,
      required this.department_name,
      this.owner_name,
      this.udf_1,
      this.udf_2,
      this.status,
      this.remark,
      required this.is_check,
      this.location_check,
      this.department_check,
      this.status_count,
      this.scan_date,
      required this.is_plan});

  // สำหรับแปลงข้อมูลจาก Json เป็น Book object
  static CountDetail fromJson(Map<String, Object?> json) => CountDetail(
        count_detail_id: json[CountDetailFields.count_detail_id] as int?,
        count_master_id: json[CountDetailFields.count_master_id] as int,
        asset_code: json[CountDetailFields.asset_code] as String,
        asset_name: json[CountDetailFields.asset_name] as String,
        cost_center: json[CountDetailFields.cost_center] as String?,
        cap_date: ((json[CountDetailFields.cap_date] as String?) == null)
            ? null
            : DateTime.parse(json[CountDetailFields.cap_date] as String),
        location_name: json[CountDetailFields.location_name] as String,
        department_name: json[CountDetailFields.department_name] as String,
        owner_name: json[CountDetailFields.owner_name] as String?,
        udf_1: json[CountDetailFields.udf_1] as String?,
        udf_2: json[CountDetailFields.udf_2] as String?,
        status: json[CountDetailFields.status] as String?,
        is_check: json[CountDetailFields.is_check] as bool,
        location_check: json[CountDetailFields.location_check] as String?,
        department_check: json[CountDetailFields.department_check] as String?,
        status_count: json[CountDetailFields.status_count] as String?,
        scan_date: ((json[CountDetailFields.scan_date] as String?) == null)
            ? null
            : DateTime.parse(json[CountDetailFields.scan_date] as String),
        is_plan: json[CountDetailFields.is_plan] as bool,
      );

  // สำหรับแปลง Book object เป็น Json บันทึกลงฐานข้อมูล
  Map<String, Object?> toJson() => {
        CountDetailFields.count_detail_id: count_detail_id,
        CountDetailFields.count_master_id: count_master_id,
        CountDetailFields.asset_code: asset_code,
        CountDetailFields.asset_name: asset_name,
        CountDetailFields.cost_center: cost_center,
        CountDetailFields.cap_date: cap_date?.toIso8601String(),
        CountDetailFields.location_name: location_name,
        CountDetailFields.department_name: department_name,
        CountDetailFields.owner_name: owner_name,
        CountDetailFields.udf_1: udf_1,
        CountDetailFields.udf_2: udf_2,
        CountDetailFields.status: status,
        CountDetailFields.is_check: is_check,
        CountDetailFields.location_check: location_check,
        CountDetailFields.department_check: department_check,
        CountDetailFields.status_count: status_count,
        CountDetailFields.scan_date: scan_date?.toIso8601String(),
        CountDetailFields.is_plan: is_plan,
      };
}
