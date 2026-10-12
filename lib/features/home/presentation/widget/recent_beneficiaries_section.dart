import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/model/home_beneficiary_model.dart';
import 'home_beneficiary_card.dart';
import '../util/beneficiary_avatar_util.dart';
import '../util/country_flag_util.dart';

class RecentBeneficiariesSection extends StatelessWidget {
  final List<HomeBeneficiaryModel> beneficiaries;

  final HomeBeneficiaryModel? selectedBeneficiary;

  final ValueChanged<HomeBeneficiaryModel>? onBeneficiaryTap;

  final VoidCallback? onSeeAll;

  const RecentBeneficiariesSection({
    super.key,
    required this.beneficiaries,
    required this.selectedBeneficiary,
    this.onBeneficiaryTap,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final List<HomeBeneficiaryModel> displayedBeneficiaries = beneficiaries
        .take(4)
        .toList();
    final textScale = MediaQuery.textScalerOf(context).scale(12) / 12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================
        // TITLE
        // =====================================================

        Text(
          l10n.homeRecentBeneficiaries,
          style: const TextStyle(
            color: Color(0xFF272321),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        // =====================================================
        // SELECTED BENEFICIARY
        // =====================================================
        HomeBeneficiaryCard(
          beneficiary: selectedBeneficiary,
          beneficiaries: displayedBeneficiaries,
        ),

        const SizedBox(height: 18),

        // =====================================================
        // QUICK BENEFICIARIES
        // =====================================================
        if (displayedBeneficiaries.isEmpty)
          _EmptyBeneficiaries(
            message: l10n.homeNoRecentBeneficiaries,
            onSeeAll: onSeeAll,
          )
        else
          SizedBox(
            height: 90 + (textScale > 1 ? (textScale - 1) * 24 : 0),
            child: Row(
              children: [
                for (
                  int index = 0;
                  index < displayedBeneficiaries.length;
                  index++
                )
                  Expanded(
                    child: _BeneficiaryItem(
                      key: ValueKey(
                        'home-quick-beneficiary-${displayedBeneficiaries[index].id}',
                      ),
                      beneficiary: displayedBeneficiaries[index],
                      selected:
                          selectedBeneficiary?.id ==
                          displayedBeneficiaries[index].id,
                      onTap: onBeneficiaryTap == null
                          ? null
                          : () {
                              onBeneficiaryTap!(displayedBeneficiaries[index]);
                            },
                    ),
                  ),

                // =================================================
                // PLUS
                // =================================================
                Expanded(child: _MoreBeneficiariesItem(onTap: onSeeAll)),
              ],
            ),
          ),
      ],
    );
  }
}

// ===========================================================
// BENEFICIARY ITEM
// ===========================================================

class _BeneficiaryItem extends StatelessWidget {
  final HomeBeneficiaryModel beneficiary;

  final bool selected;

  final VoidCallback? onTap;

  const _BeneficiaryItem({
    super.key,
    required this.beneficiary,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color avatarColor = BeneficiaryAvatarUtil.colorForName(
      beneficiary.displayName,
    );

    final String flag = CountryFlagUtil.fromIsoCode2(
      beneficiary.countryIsoCode2,
    );

    return Semantics(
      selected: selected,
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // =====================================================
            // AVATAR + FLAG
            // =====================================================

            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? const Color(0xFFFF8A00) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: avatarColor.withValues(alpha: 0.18),
                    child: Icon(
                      Icons.person_rounded,
                      color: avatarColor,
                      size: 29,
                    ),
                  ),

                  // =================================================
                  // COUNTRY FLAG
                  // =================================================
                  if (flag.isNotEmpty)
                    Positioned(
                      right: -5,
                      bottom: -3,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.10),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(flag, style: const TextStyle(fontSize: 13)),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 7),

            // =====================================================
            // FIRST NAME
            // =====================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                beneficiary.firstName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFFFF8A00)
                      : const Color(0xFF4B4542),
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================
// MORE
// ===========================================================

class _MoreBeneficiariesItem extends StatelessWidget {
  final VoidCallback? onTap;

  const _MoreBeneficiariesItem({this.onTap});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFE6E5E4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Color(0xFF37322F),
              size: 28,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            l10n.homeSeeMore,
            maxLines: 1,
            style: const TextStyle(
              color: Color(0xFF514A46),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// EMPTY
// ===========================================================

class _EmptyBeneficiaries extends StatelessWidget {
  final String message;

  final VoidCallback? onSeeAll;

  const _EmptyBeneficiaries({required this.message, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEAE5E2)),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Color(0xFF847C78), fontSize: 13),
          ),
        ),

        if (onSeeAll != null) ...[
          const SizedBox(height: 12),

          TextButton.icon(
            onPressed: onSeeAll,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.homeSeeMore),
          ),
        ],
      ],
    );
  }
}
