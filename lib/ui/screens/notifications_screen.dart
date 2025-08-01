import 'package:flutter/material.dart';
import 'package:nummo/components/app_drawer.dart';
import 'package:nummo/components/custom_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
      body: Center(child: const Text('Notifications screen')),
    );
  }
}
