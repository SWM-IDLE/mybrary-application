import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/sliver_app_bar_delegate.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/ui/search/search_detail/search_detail_screen.dart';
import 'package:mybrary/ui/search/search_isbn_scan/components/isbn_scan_box.dart';
import 'package:mybrary/ui/search/search_isbn_scan/components/isbn_scan_description.dart';

class SearchIsbnScanScreen extends StatefulWidget {
  final CameraDescription camera;
  const SearchIsbnScanScreen({
    required this.camera,
    super.key,
  });

  @override
  State<SearchIsbnScanScreen> createState() => _SearchIsbnScanScreenState();
}

class _SearchIsbnScanScreenState extends State<SearchIsbnScanScreen>
    with TickerProviderStateMixin {
  late final List<String> _scanTabs = ['바코드 스캔', '마이북 스캔'];
  late final TabController _scanTabController = TabController(
    length: _scanTabs.length,
    vsync: this,
  );
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  MobileScannerController isbnCameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: myBookScanBackgroundColor,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: myBookScanBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
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
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            SizedBox(
              height: height,
              child: Stack(
                children: [
                  SizedBox(
                    width: width,
                    child: MobileScanner(
                      controller: isbnCameraController,
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
                          isbnCameraController.dispose();
                        }
                      },
                    ),
                  ),
                  IsbnScanDescription(
                    width: width,
                    height: height,
                    topText: '도서 뒷면의 바코드를 인식시켜',
                    bottomText: '책을 검색할 수 있어요',
                    icon: CupertinoIcons.xmark,
                    onPressedScanButton: () => Navigator.of(context).pop(),
                  ),
                  IsbnScanBox(
                    width: width,
                    height: height,
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
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // 미리보기
                          return CameraPreview(_controller);
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  IsbnScanDescription(
                    width: width,
                    height: height,
                    topText: '책장 또는 다량의 도서를 촬영해',
                    bottomText: '책을 마이북에 등록할 수 있어요',
                    icon: CupertinoIcons.camera_fill,
                    onPressedScanButton: () => Navigator.of(context).pop(),
                  ),
                  IsbnScanBox(
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
          toolbarHeight: 60.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: myBookScanBackgroundColor,
            ),
          ),
          title: const Text('검색'),
          titleTextStyle: commonSubTitleStyle.copyWith(
            color: commonWhiteColor,
          ),
          centerTitle: true,
          pinned: true,
          forceElevated: innerBoxIsScrolled,
        ),
      ),
      SliverPersistentHeader(
        delegate: SliverAppBarDelegate(
          tabBar: scanTabBar(
            tabController,
            scanTabs,
          ),
          color: myBookScanBackgroundColor,
        ),
        pinned: true,
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
