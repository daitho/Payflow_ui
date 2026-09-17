import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/model/home_user_model.dart';

class HomeHeader extends StatelessWidget {
  final HomeUserModel user;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationsTap;

  const HomeHeader({
    super.key,
    required this.user,
    this.onProfileTap,
    this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
    AppLocalizations.of(context);

    final String? firstName =
    user.firstName?.trim();

    final String greetingName =
    firstName != null && firstName.isNotEmpty
        ? firstName
        : user.lastName;

    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onProfileTap,
            customBorder: const CircleBorder(),
            child: CircleAvatar(
              radius: 23,
              backgroundColor:
              const Color(0xFFFFE8D7),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFFFF970F),
                size: 27,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeWelcome,
                style: const TextStyle(
                  color: Color(0xFF89817D),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                greetingName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF272321),
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onNotificationsTap,
            borderRadius: BorderRadius.circular(24),
            child: const SizedBox(
              width: 46,
              height: 46,
              child: Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 27,
                  color: Color(0xFF3C3734),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}