import 'package:ams_express/extension/color_extension.dart';
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

  @override
  void initState() {
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        backgroundColor: Colors.green.shade500,
        title: Text('Plan : $plan',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: itemList.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == itemList.length) {
                  return Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: AppColors.mainTextColor1,
                    shadowColor: Colors.black,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Asset : ${itemList[index].asset}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Description : ${itemList[index].description}'),
                            Text('Cost Center : ${itemList[index].costCenter}'),
                            Text(
                                'Capitalized On : ${itemList[index].capitalizedOn}'),
                            Text('Location : ${itemList[index].location}'),
                            Text('Department : ${itemList[index].department}'),
                            Text('Asset Owner : ${itemList[index].assetOwner}'),
                            Text(
                                'Created Date : ${itemList[index].createdDate}'),
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
    );
  }
}
