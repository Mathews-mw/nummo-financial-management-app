import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:nummo/app_routes.dart';
import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/providers/user_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final void Function()? onOpenDrawer;
  final bool showAvatar;

  const CustomAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.actions,
    this.onOpenDrawer,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return AppBar(
      backgroundColor: Colors.white,
      title: title != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray700,
                  ),
                ),
                Text(
                  subtitle ?? '',
                  style: TextStyle(
                    fontSize: subtitle != null ? 14 : 0,
                    color: AppColors.gray500,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, ${user?.name.split(' ')[0]}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Vamos organizar suas finanças?',
                  style: TextStyle(fontSize: 14, color: AppColors.gray500),
                ),
              ],
            ),
      leading: showAvatar
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: Stack(
                  children: [
                    Skeletonizer(
                      enabled: user == null,
                      ignoreContainers: true,
                      child: CircleAvatar(
                        backgroundImage: user?.avatarUrl != null
                            ? CachedNetworkImageProvider(user!.avatarUrl!)
                            : null,
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
                    Material(
                      shape: const CircleBorder(),
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.black.withAlpha(50),
                        onTap: onOpenDrawer,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      actions:
          actions ??
          [
            IconButton(
              icon: const Icon(PhosphorIconsRegular.signOut),
              tooltip: 'Show Snackbar',
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text('Deseja sair do App?'),
                    content: const Text(
                      'Você tem certeza que deseja sair da aplicação?',
                    ),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.gray700,
                        ),
                        onPressed: () {
                          Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).logout();

                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.login,
                            (route) => false,
                          );
                        },
                        child: const Text('Sair'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.gray600,
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
