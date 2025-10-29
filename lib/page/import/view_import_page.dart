import 'package:ams_express/model/importModel/view_import_detail_Model.dart';
import 'package:ams_express/services/database/import_db.dart';
import 'package:flutter/material.dart';

class ViewImportPage extends StatefulWidget {
  const ViewImportPage({super.key});

  @override
  State<ViewImportPage> createState() => _ViewImportPageState();
}

class _ViewImportPageState extends State<ViewImportPage> {
  String plan = '';
  List<ViewImportdetailModel> itemList = [];
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int currentPage = 0;
  final int pageSize = 10;

  // Modern Blue Color Palette
  final Color primaryColor = Color(0xFF2196F3);
  final Color secondaryColor = Color(0xFF64B5F6);
  final Color accentColor = Color(0xFF00BCD4);
  final Color cardColor = Colors.white;

  @override
  void initState() {
    // itemList = [
    //   // ตัวอย่างข้อมูลเริ่มต้น
    //   ViewImportdetailModel(
    //     id: 1,
    //     asset: 'Asset001',
    //     description: 'Laptop Dell XPS 13',
    //     costCenter: 'CC1001',
    //     capitalizedOn: '2023-01-15',
    //     location: 'New York Office',
    //     department: 'IT Department',
    //     assetOwner: 'John Doe',
    //     createdDate: '2023-01-10',
    //   ),
    //   ViewImportdetailModel(
    //     id: 2,
    //     asset: 'Asset002',
    //     description: 'iPhone 13 Pro',
    //     costCenter: 'CC1002',
    //     capitalizedOn: '2023-02-20',
    //     location: 'San Francisco Office',
    //     department: 'Marketing Department',
    //     assetOwner: 'Jane Smith',
    //     createdDate: '2023-02-15',
    //   ),
    //   ViewImportdetailModel(
    //     id: 3,
    //     asset: 'Asset003',
    //     description: 'Samsung Galaxy S21',
    //     costCenter: 'CC1003',
    //     capitalizedOn: '2023-03-05',
    //     location: 'Chicago Office',
    //     department: 'Sales Department',
    //     assetOwner: 'Alice Johnson',
    //     createdDate: '2023-03-01',
    //   ),
    // ];
    super.initState();
    _scrollController.addListener(_scrollListener);
    // รับค่า arguments ที่ส่งมา
    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments as String?;
      if (args != null) {
        setState(() {
          plan = args;
        });
        _fetchData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.75 &&
        !isLoading) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    // Fetch data from the database
    List<ViewImportdetailModel> newItems = await ImportDB()
        .viewDetail(plan, limit: pageSize, offset: currentPage * pageSize);

    setState(() {
      itemList.addAll(newItems);
      currentPage++;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Plan : $plan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: itemList.length + (isLoading ? 1 : 0),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == itemList.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        print(itemList[index].id);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.08),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Asset Header
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryColor, secondaryColor],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.qr_code_2_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${itemList[index].asset}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              // Details
                              _buildDetailRow(
                                Icons.description_rounded,
                                'Description',
                                itemList[index].description ?? '-',
                              ),
                              _buildDetailRow(
                                Icons.business_rounded,
                                'Cost Center',
                                itemList[index].costCenter ?? '-',
                              ),
                              _buildDetailRow(
                                Icons.calendar_month_rounded,
                                'Capitalized On',
                                itemList[index].capitalizedOn ?? '-',
                              ),
                              _buildDetailRow(
                                Icons.location_on_rounded,
                                'Location',
                                itemList[index].location ?? '-',
                              ),
                              _buildDetailRow(
                                Icons.apartment_rounded,
                                'Department',
                                itemList[index].department ?? '-',
                              ),
                              _buildDetailRow(
                                Icons.person_rounded,
                                'Asset Owner',
                                itemList[index].assetOwner ?? '-',
                              ),
                              _buildDetailRow(
                                Icons.schedule_rounded,
                                'Created Date',
                                itemList[index].createdDate ?? '-',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: primaryColor,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
