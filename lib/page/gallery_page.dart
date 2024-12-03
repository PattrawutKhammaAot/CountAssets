import 'dart:io';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:ams_express/component/label.dart';
import 'package:ams_express/extension/color_extension.dart';
import 'package:ams_express/main.dart';
import 'package:ams_express/model/galleryModel/galleryModel.dart';
import 'package:ams_express/services/database/gallery_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photo_view/photo_view.dart';

class GalleryPage extends StatefulWidget {
  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<ViewGalleryModel> _imageList = [];
  List<ViewGalleryModel> _tempimageList = [];
  int _limit = 10;
  int _offset = 0;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadMoreImages();
  }

  Future<void> _loadMoreImages() async {
    if (!_hasMoreData) return;

    GalleryDB().getImage(limit: _limit, offset: _offset).then((value) {
      if (value.isEmpty) {
        _hasMoreData = false;
      } else {
        _imageList.addAll(value);
        _tempimageList.addAll(value);
        _offset += _limit;
      }
      setState(() {});
    });
  }

  void _serachItemModel(String value) {
    List<ViewGalleryModel> searchResults = _tempimageList
        .where((element) =>
            element.asset != null && element.asset!.contains(value))
        .toList();
    if (searchResults.isNotEmpty) {
      _imageList = searchResults;
    } else {
      _imageList = _tempimageList;
      if (searchResults.isEmpty) {
        EasyLoading.showError("Data Invalid");
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.contentColorBlue,
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        title: Label(
          appLocalization.localizations.menu_gallery,
          color: Colors.white,
          fontSize: 20,
        ),
        actions: [
          AnimSearchBar(
              width: MediaQuery.of(context).size.width,
              textController: TextEditingController(),
              onSuffixTap: () {},
              onSubmitted: (value) {
                _serachItemModel(value);
              })
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadMoreImages();
          }
          return true;
        },
        child: _imageList.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: _imageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          elevation: 10,
                          child: Column(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  shape: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: PhotoView(
                                                          imageProvider:
                                                              FileImage(File(
                                                                  "${_imageList[index].imageFile}")),
                                                        ),
                                                      ),
                                                      Label(
                                                        "${_imageList[index].plan} : ${_imageList[index].asset} ",
                                                        color: Colors.black,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          ElevatedButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          AppColors
                                                                              .contentColorBlue)),
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child:
                                                                  Label("OK"))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Image.file(File(
                                            "${_imageList[index].imageFile}")),
                                      )),
                                ),
                              )),
                              Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Label(
                                          "${_imageList[index].asset}",
                                          fontSize: 14,
                                          color: AppColors.contentColorBlue,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          )),
                    ),
                  );
                })
            : Container(),
      ),
    );
  }
}
