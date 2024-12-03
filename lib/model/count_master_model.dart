// กำหนดฟิลด์ข้อมูลของตาราง
class CountMasterFields {
  // สร้างเป็นลิสรายการสำหรับคอลัมน์ฟิลด์
  static final List<String> values = [
    count_master_id,
    count_code,
    count_name,
    file_name,
    create_date
  ];

  // กำหนดแต่ละฟิลด์ของตาราง ต้องเป็น String ทั้งหมด
  static final String count_master_id =
      'count_master_id'; // ตัวแรกต้องเป็น _id ส่วนอื่นใช้ชื่อะไรก็ได้
  static final String count_code = 'count_code';
  static final String count_name = 'count_name';
  static final String file_name = 'file_name';
  static final String create_date = 'create_date';
}

// ส่วนของ Data Model ของหนังสือ
class CountMaster {
  final int? count_master_id; // จะใช้ค่าจากที่ gen ในฐานข้อมูล
  final String count_code;
  final String count_name;
  final String file_name;
  final DateTime create_date;

  // constructor
  const CountMaster({
    this.count_master_id,
    required this.count_code,
    required this.count_name,
    required this.file_name,
    required this.create_date,
  });

  // ฟังก์ชั่นสำหรับ สร้างข้อมูลใหม่ โดยรองรับแก้ไขเฉพาะฟิลด์ที่ต้องการ
  CountMaster copy({
    int? count_master_id,
    String? count_code,
    String? count_name,
    String? file_name,
    DateTime? create_date,
  }) =>
      CountMaster(
        count_master_id: count_master_id ?? this.count_master_id,
        count_code: count_code ?? this.count_code,
        count_name: count_name ?? this.count_name,
        file_name: file_name ?? this.file_name,
        create_date: create_date ?? this.create_date,
      );

  // สำหรับแปลงข้อมูลจาก Json เป็น Book object
  static CountMaster fromJson(Map<String, Object?> json) => CountMaster(
        count_master_id: json[CountMasterFields.count_master_id] as int?,
        count_code: json[CountMasterFields.count_code] as String,
        count_name: json[CountMasterFields.count_name] as String,
        file_name: json[CountMasterFields.file_name] as String,
        create_date:
            DateTime.parse(json[CountMasterFields.create_date] as String),
      );

  // สำหรับแปลง Book object เป็น Json บันทึกลงฐานข้อมูล
  Map<String, Object?> toJson() => {
        CountMasterFields.count_master_id: count_master_id,
        CountMasterFields.count_code: count_code,
        CountMasterFields.count_name: count_name,
        CountMasterFields.file_name: file_name,
        CountMasterFields.create_date: create_date.toIso8601String(),
      };
}
