import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  openMapsSheetWithMarker() async {
    try {
      final coords = Coords(37.759392, 117.5107336);
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: availableMaps.map<Widget>((map) {
                  return ListTile(
                    onTap: () {
                      map.showMarker(
                          coords: coords,
                          title: "mark标题",
                          description: "我给你标记的位置"
                      );
                    },
                    title: Text(map.mapName),
                    leading: SvgPicture.asset(
                      map.icon,
                      height: 30.0,
                      width: 30.0,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  openOnGaode() async {
    final coords = Coords(37.759392, 117.5107336);
    if (await MapLauncher.isMapAvailable(MapType.amap) != null) {
      await MapLauncher.showMarker(
        mapType: MapType.amap,
        coords: coords,
        title: "高德marker标题",
        description: "我给你标记的位置",
      );
    }else {
      showDialog(
          context: context,
          builder: (context) {
            return const Text("不能打开");
          },
      );
    }
  }

  openMapsSheetWithNavigaiton() async {
    try {
      final coords = Coords(37.759392, 117.5107336);
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: availableMaps.map<Widget>((map) {
                  return ListTile(
                    onTap: () {
                      map.showDirections(
                        // origin: coords,//当前位置 //不填写就是当前位置
                        destination: coords, //目的位置
                        // originTitle: '其实位置标题信息(根据这个搜索)',
                        // destinationTitle: "目的标题信息",
                        directionsMode: DirectionsMode.walking, //默认为.driving可以点进去选择
                      );
                    },
                    title: Text(map.mapName),
                    leading: SvgPicture.asset(
                      map.icon,
                      height: 30.0,
                      width: 30.0,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  openOnGaodeWithNavigaiton() async {
    final coords = Coords(37.759392, 117.5107336);
    if (await MapLauncher.isMapAvailable(MapType.amap) != null) {
      MapLauncher.showDirections(
        mapType: MapType.amap, //选择类型
        // origin: coords,//当前位置 //不填写就是当前位置
        destination: coords, //目的位置
        // originTitle: '其实位置标题信息(根据这个搜索)',
        // destinationTitle: "目的标题信息",
        directionsMode: DirectionsMode.walking, //默认为.driving可以点进去选择
      );
    }else {
      showDialog(
        context: context,
        builder: (context) {
          return const Text("不能打开");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('map_launch demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                openMapsSheetWithMarker();
              },
              child: const Text("跳转多平台指定位置"),
            ),
            TextButton(
              onPressed: () {
                openOnGaode();
              },
              child: const Text("单独跳转高德指定位置"),
            ),
            TextButton(
              onPressed: () {
                openMapsSheetWithNavigaiton();
              },
              child: const Text("跳转多平台导航指定位置"),
            ),
            TextButton(
              onPressed: () {
                openOnGaodeWithNavigaiton();
              },
              child: const Text("单独跳转高德导航指定位置"),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
