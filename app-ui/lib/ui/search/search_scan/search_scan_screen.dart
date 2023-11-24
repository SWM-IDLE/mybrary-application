import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/ui/search/search_detail/search_detail_screen.dart';
import 'package:mybrary/ui/search/search_scan/components/scan_description.dart';
import 'package:mybrary/ui/search/search_scan/components/scan_layout_box.dart';
import 'package:mybrary/ui/search/search_scan/search_scan_list/search_scan_list_screen.dart';
import 'package:mybrary/utils/logics/future_utils.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class SearchScanScreen extends StatefulWidget {
  final CameraDescription camera;
  const SearchScanScreen({
    required this.camera,
    super.key,
  });

  @override
  State<SearchScanScreen> createState() => _SearchScanScreenState();
}

class _SearchScanScreenState extends State<SearchScanScreen>
    with TickerProviderStateMixin {
  late final List<String> _scanTabs = ['마이북 스캔', '바코드 스캔'];
  late final TabController _scanTabController = TabController(
    length: _scanTabs.length,
    vsync: this,
  );
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  late MobileScannerController _isbnCameraController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: myBookScanBackgroundColor,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: myBookScanBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
    _isbnCameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    _scanTabController.addListener(_startIsbnScan);
  }

  void _startIsbnScan() {
    setState(() {
      if (_scanTabController.index == 0) {
        _isbnCameraController = MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
          torchEnabled: false,
          autoStart: false,
        );
      }
      if (_scanTabController.index == 1) {
        if (_isbnCameraController.autoStart) return;
        _isbnCameraController.start();
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: commonLessGreyColor.withOpacity(0.2),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    _controller.dispose();
    _isbnCameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SubPageLayout(
      resizeToAvoidBottomInset: false,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return scanPageSliverBuilder(
            context,
            innerBoxIsScrolled,
            _scanTabs,
            _scanTabController,
          );
        },
        body: TabBarView(
          controller: _scanTabController,
          children: [
            SizedBox(
              height: height,
              child: Stack(
                children: [
                  SizedBox(
                    width: width,
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Transform.scale(
                            scale: _controller.value.aspectRatio /
                                MediaQuery.of(context).size.aspectRatio *
                                0.4,
                            child: CameraPreview(_controller),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  ScanDescription(
                    width: width,
                    height: height,
                    topText: '책장 또는 다량의 도서를 촬영해',
                    bottomText: '책을 마이북에 등록할 수 있어요',
                    icon: CupertinoIcons.camera_fill,
                    isMyBookScan: true,
                    onPressedScanButton: () async {
                      try {
                        await _initializeControllerFuture;

                        final originImage = await _controller.takePicture();
                        File image =
                            await FlutterExifRotation.rotateAndSaveImage(
                          path: originImage.path,
                        );

                        Size previewSize = _controller.value.previewSize!;

                        final aosImagePath =
                            await resizeAndroidPhoto(image.path, previewSize);
                        final iosImagePath = await convertHeicToJpg(
                            await resizeIosPhoto(image.path, previewSize));

                        if (!mounted) return;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => SearchScanListScreen(
                              multiBookImagePath:
                                  isIOS ? iosImagePath : aosImagePath,
                            ),
                          ),
                        );
                      } catch (e) {
                        log('다중 도서 스캔 에러: $e');
                        rethrow;
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height,
              child: Stack(
                children: [
                  SizedBox(
                    width: width,
                    child: MobileScanner(
                      controller: _isbnCameraController,
                      scanWindow:
                          Rect.fromLTWH(0, 150, width * 0.8, height * 0.35),
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          if (barcode.rawValue != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SearchDetailScreen(
                                  isbn13: barcode.rawValue!,
                                ),
                              ),
                            );
                          }
                          _isbnCameraController.dispose();
                        }
                      },
                    ),
                  ),
                  ScanDescription(
                    width: width,
                    height: height,
                    topText: '도서 뒷면의 바코드를 인식시켜',
                    bottomText: '책을 검색할 수 있어요',
                    icon: CupertinoIcons.xmark,
                    onPressedScanButton: () {
                      Navigator.of(context).pop();
                      _isbnCameraController.dispose();
                    },
                  ),
                  ScanLayoutBox(
                    width: width,
                    height: height,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> scanPageSliverBuilder(
    BuildContext context,
    bool innerBoxIsScrolled,
    List<String> scanTabs,
    TabController tabController,
  ) {
    return <Widget>[
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          elevation: 0,
          toolbarHeight: 100.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: myBookScanBackgroundColor,
            ),
          ),
          title: const Text('스캔'),
          titleTextStyle: commonSubTitleStyle.copyWith(
            color: commonWhiteColor,
          ),
          centerTitle: true,
          pinned: true,
          forceElevated: innerBoxIsScrolled,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: scanTabBar(
              tabController,
              scanTabs,
            ),
          ),
        ),
      ),
    ];
  }

  TabBar scanTabBar(
    TabController tabController,
    List<String> scanTabs,
  ) {
    return TabBar(
      controller: tabController,
      indicatorColor: commonWhiteColor,
      labelColor: commonWhiteColor,
      labelStyle: commonButtonTextStyle,
      physics: const BouncingScrollPhysics(),
      unselectedLabelColor: grey999999,
      unselectedLabelStyle: commonButtonTextStyle.copyWith(
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
      ),
      tabs: scanTabs.map((String name) => Tab(text: name)).toList(),
    );
  }
}
