import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/model/profile_model.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileModel profile;

  const ProfileHeaderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFFF1EEEC)),

        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              // =======================================================
              // PUBLIC ID
              //
              // Expanded permet à cette partie d'utiliser uniquement
              // l'espace restant à gauche du badge.
              // =======================================================
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: profile.publicId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context).profileIdCopied,
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F2F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // =================================================
                        // L'ID peut maintenant se réduire proprement.
                        // =================================================
                        Expanded(
                          child: Text(
                            'ID: ${profile.publicId}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF514843),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.content_copy_rounded,
                          size: 14,
                          color: Color(0xFF77716E),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // =======================================================
              // VERIFICATION
              // =======================================================
              _VerificationBadge(verified: profile.verified),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: const Color(0xFFFFF0E8),
                child: Text(
                  profile.initials,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ),

              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E2927),
                      ),
                    ),

                    const SizedBox(height: 7),
                    _InfoLine(icon: Icons.email_outlined, text: profile.email),
                    if (profile.phone != null &&
                        profile.phone!.trim().isNotEmpty) ...[
                      const SizedBox(height: 5),
                      _InfoLine(
                        icon: Icons.phone_outlined,
                        text: profile.phone!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF8F8986)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Color(0xFF77716E)),
          ),
        ),
      ],
    );
  }
}

class _VerificationBadge extends StatelessWidget {
  final bool verified;

  const _VerificationBadge({required this.verified});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: verified ? const Color(0xFFEAF8EF) : const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            verified ? Icons.verified_rounded : Icons.schedule_rounded,

            size: 15,

            color: verified ? const Color(0xFF27A05A) : const Color(0xFFE58A00),
          ),
          const SizedBox(width: 4),
          Text(
            verified
                ? AppLocalizations.of(context).verified
                : AppLocalizations.of(context).notVerified,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: verified
                  ? const Color(0xFF218A4B)
                  : const Color(0xFFC77600),
            ),
          ),
        ],
      ),
    );
  }
}
