class QuickTypes {
  static const String ID_PRIMARYKEY = "ID INTEGER PRIMARY KEY AUTOINCREMENT";

  static const String TEXTNOTNULL = "TEXT NOT NULL";
  static const String TEXT = "TEXT NULL";
  static const String INTEGER = "INTEGER";
  static const String REAL = "REAL";
  static const String IMAGE = "BLOB";

  static const String dbFileName = 'AmsPDA.db';
}

class StatusCheck {
  static const String status_uncheck = 'Uncheck';
  static const String status_checked = 'Checked';
  static const String status_open = 'Open';
  static const String status_close = 'Close';
  static const String status_count = 'Counting';
}

enum TypeAlert { success, warning, error }
