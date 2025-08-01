import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:nummo/app_routes.dart';
import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/providers/user_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.only(top: 64, bottom: 16, left: 16, right: 8),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Skeletonizer(
                enabled: user == null,
                ignoreContainers: true,
                child: CircleAvatar(
                  backgroundImage: user?.avatarUrl != null
                      ? CachedNetworkImageProvider(user!.avatarUrl!)
                      : null,
                  radius: 26,
                  child: user?.avatarUrl == null && user != null
                      ? Text(
                          user.name.substring(0, 2).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Skeletonizer(
                    enabled: user == null,
                    child: Text(
                      user!.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray700,
                      ),
                    ),
                  ),
                  Skeletonizer(
                    enabled: user == null,
                    child: Text(
                      user.email,
                      style: TextStyle(color: AppColors.gray500),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          DrawerTile(
            title: 'Home',
            icon: PhosphorIcons.house(),
            routeName: AppRoutes.home,
          ),
          DrawerTile(
            title: 'Orçamento mensal',
            icon: PhosphorIcons.handCoins(),
            routeName: AppRoutes.monthlyBudget,
          ),
          DrawerTile(
            icon: PhosphorIcons.receipt(),
            title: 'Gestão de contas',
            routeName: AppRoutes.billsManagement,
          ),
          DrawerTile(
            icon: PhosphorIcons.bell(),
            title: 'Notificações',
            routeName: AppRoutes.notifications,
          ),
          DrawerTile(
            icon: PhosphorIcons.user(),
            title: 'Perfil',
            routeName: AppRoutes.perfil,
          ),
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String routeName;

  const DrawerTile({
    super.key,
    required this.title,
    required this.icon,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    final isActive = currentRoute == routeName;

    return ListTile(
      leading: Icon(icon, color: isActive ? AppColors.primary : null),
      tileColor: isActive ? Color.fromRGBO(218, 75, 220, 0.1) : null,
      shape: isActive
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? AppColors.primary : null,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();

        if (!isActive) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(routeName, (route) => false);
        }
      },
    );
  }
}
