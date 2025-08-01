import 'package:flutter/material.dart';
import 'package:nummo/components/app_drawer.dart';
import 'package:nummo/components/custom_app_bar.dart';

class BillsManagement extends StatefulWidget {
  const BillsManagement({super.key});

  @override
  State<BillsManagement> createState() => _BillsManagementState();
}

class _BillsManagementState extends State<BillsManagement> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleOpenDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(onOpenDrawer: _handleOpenDrawer),
      drawer: const AppDrawer(),
      body: Center(child: const Text('Bills management screen')),
    );
  }
}
