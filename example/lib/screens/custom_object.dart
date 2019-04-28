import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class CustomObject extends StatefulWidget {
  @override
  _CustomObjectState createState() => _CustomObjectState();
}

class _CustomObjectState extends State<CustomObject> {
  ArCoreController arCoreController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Object on plane detected'),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _addSphere(ArCoreHitTestResult plane) {
    final m2 = ArCoreMaterial(color: Colors.grey);
    final s2 = ArCoreSphere(
      materials: [m2],
      radius: 0.03,
    );
    final moon = ArCoreNode(
      name: "moon",
      shape: s2,
      position: vector.Vector3(0.2, 0, 0),
      rotation: vector.Vector4(0, 0, 0, 0),
    );

    final material = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244), texture: "earth.jpg");
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final earth = ArCoreNode(
        name: "earht",
        shape: sphere,
        children: [moon],
        position: plane.pose.translation + vector.Vector3(0.0, 1.0, 0.0),
        rotation: plane.pose.rotation);

    arCoreController.addArCoreNodeWithAnchor(earth);
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addSphere(hit);
  }

  void onTapHandler(String name) {
    print("Flutter: onNodeTap");
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(content: Text('onNodeTap on $name')),
    );
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
