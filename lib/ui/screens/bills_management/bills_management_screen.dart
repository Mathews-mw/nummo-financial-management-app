import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/components/app_drawer.dart';
import 'package:nummo/components/custom_app_bar.dart';
import 'package:nummo/ui/screens/bills_management/add_bills.dart';

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
      appBar: CustomAppBar(
        onOpenDrawer: _handleOpenDrawer,
        showAvatar: false,
        title: 'Gestão de contas',
        subtitle: 'Crie lembretes para pagamento de contas',
        actions: [AddBills()],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
          child: Consumer(
            builder: (ctx, provider, child) {
              return ListView.builder(
                itemCount: 50,
                itemBuilder: (ctx, index) {
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        'Conta de energia',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Vencimento em 10/08'),
                      leading: Icon(Icons.request_quote, size: 32),
                      trailing: MenuAnchor(
                        style: MenuStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                        ),
                        menuChildren: <Widget>[
                          MenuItemButton(
                            onPressed: () {},
                            child: const Text(
                              'Editar',
                              style: TextStyle(color: AppColors.gray700),
                            ),
                          ),
                          MenuItemButton(
                            onPressed: () {},
                            child: const Text(
                              'Excluir',
                              style: TextStyle(color: AppColors.gray700),
                            ),
                          ),
                        ],
                        builder: (_, MenuController controller, Widget? child) {
                          return IconButton(
                            onPressed: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            icon: const Icon(Icons.more_vert),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
