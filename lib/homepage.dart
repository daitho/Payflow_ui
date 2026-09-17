import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:ui';
import 'app/router/app_routes.dart';
import 'features/home/domain/model/home_beneficiary_model.dart';
import 'features/home/presentation/view/home_view.dart';
import 'features/profile/presentation/view/profile_view.dart';
import 'l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  // =========================================================
  // STATE
  // =========================================================
  int _selectedIndex = 0;
  HomeBeneficiaryModel? _selectedBeneficiary;

  // =========================================================
  // BUILD
  // =========================================================
  @override
  Widget build(BuildContext context) {
    final double bottomSafeArea = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      /*
       * Le contenu peut continuer derrière les éléments
       * flottants.
       */
      extendBody: true,
      body: Stack(
        children: [
          // ===================================================
          // PAGE
          // ===================================================
          Positioned.fill(child: _buildSelectedPage()),
          // ===================================================
          // TRANSFER CTA
          // ===================================================
          if (_selectedIndex == 0)
            Positioned(
              left: 0,
              right: 0,
              /*
               * Juste au-dessus de la navigation.
               */
              bottom: bottomSafeArea + 82,
              child: Center(child: _buildTransferButton()),
            ),

          // ===================================================
          // FLOATING NAVIGATION
          // ===================================================
          Positioned(
            left: 34,
            right: 34,
            /*
             * Pas de marge artificielle supplémentaire.
             * La SafeArea fait uniquement le travail nécessaire.
             */
            bottom: 0,
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.zero,
              child: _buildFloatingNavigation(),
            ),
          ),
        ],
      ),
    );
  }
  // =========================================================
  // SELECTED PAGE
  // =========================================================
  Widget _buildSelectedPage() {
    switch (_selectedIndex) {
      // -------------------------------------------------------
      // HOME
      // -------------------------------------------------------
      case 0:
        return HomeView(
          selectedBeneficiary: _selectedBeneficiary,
          onBeneficiarySelected: (beneficiary) {
            setState(() {
              _selectedBeneficiary = beneficiary;
            });
          },
          onBeneficiaryCleared: () {
            setState(() {
              _selectedBeneficiary = null;
            });
          },
          onProfileTap: () {
            _selectTab(3);
          },
          onSeeAllBeneficiaries: () {
            _selectTab(1);
          },
          onTransferTap: _openTransfer,
          onNotificationsTap: () {
            _showComingSoon();
          },
          onExchangeRatesTap: () {
            context.push(AppRoutes.exchangeRates);
          },
          /*onTransactionTap: (
              String transactionId,
              ) {
            context.push(
              AppRoutes.transactionDetailPath(
                transactionId,
              ),
            );
          },*/

          onViewAllTransactions: () {
            context.push(
              AppRoutes.transactionHistory,
            );
          },

          onMoreTransactions: () {
            context.push(
              AppRoutes.transactionHistory,
            );
          },
        );

      // -------------------------------------------------------
      // CONTACTS
      // -------------------------------------------------------
      case 1:
        return const _ComingSoonPage(icon: Icons.people_outline_rounded);
      // -------------------------------------------------------
      // REFERRAL
      // -------------------------------------------------------
      case 2:
        return const _ComingSoonPage(icon: Icons.group_add_outlined);

      // -------------------------------------------------------
      // PROFILE
      // -------------------------------------------------------
      case 3:
        return const ProfileView();
      default:
        return const SizedBox.shrink();
    }
  }

  // =========================================================
  // TRANSFER CTA
  // =========================================================
  Widget _buildTransferButton() {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openTransfer,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFF8A00),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*
               * L'icône remplace le +
               */
              const Icon(
                Icons.swap_horiz_rounded,
                color: Colors.white,
                size: 25,
              ),
              const SizedBox(width: 9),
              Text(
                l10n.transferAction,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // FLOATING NAVIGATION
  // =========================================================
  Widget _buildFloatingNavigation() {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Container(
      height: 64,
      // Ombre extérieure séparée du fond translucide
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 28,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              // 92 % opaque = légère transparence professionnelle
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(5),
              // Bordure très légère pour détacher la barre du contenu
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.20),
                width: 0.8,
              ),
            ),

            child: Row(
              children: [
                // =================================================
                // HOME
                // =================================================
                Expanded(
                  child: _buildNavItem(
                    index: 0,
                    selectedIcon: Icons.home_rounded,
                    unselectedIcon: Icons.home_outlined,
                    label: l10n.homeTab,
                  ),
                ),

                // =================================================
                // CONTACTS
                // =================================================
                Expanded(
                  child: _buildNavItem(
                    index: 1,
                    selectedIcon: Icons.people_alt_rounded,
                    unselectedIcon: Icons.people_outline_rounded,
                    label: l10n.contactsTab,
                  ),
                ),

                // =================================================
                // REFERRAL
                // =================================================
                Expanded(
                  child: _buildNavItem(
                    index: 2,
                    selectedIcon: Icons.group_add_rounded,
                    unselectedIcon: Icons.group_add_outlined,
                    label: l10n.referralTab,
                  ),
                ),
                // =================================================
                // PROFILE
                // =================================================
                Expanded(
                  child: _buildNavItem(
                    index: 3,
                    selectedIcon: Icons.person_rounded,
                    unselectedIcon: Icons.person_outline_rounded,
                    label: l10n.profileTab,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // NAVIGATION ITEM
  // =========================================================
  Widget _buildNavItem({
    required int index,
    required IconData selectedIcon,
    required IconData unselectedIcon,
    required String label,
  }) {
    final bool selected = _selectedIndex == index;
    const Color selectedColor = Color(0xFF008B80);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _selectTab(index);
        },
        borderRadius: BorderRadius.circular(28),
        // Suppression du flash/ripple visuel
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Container(
          //duration: const Duration(milliseconds: 180),
          //curve: Curves.easeOut,
          height: double.infinity,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF0F3F2) : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? selectedIcon : unselectedIcon,
                size: 23,
                color: selected ? selectedColor : const Color(0xFF302C2A),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? selectedColor : const Color(0xFF302C2A),
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // TAB
  // =========================================================
  void _selectTab(int index) {
    if (_selectedIndex == index) {
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  // =========================================================
  // TRANSFER
  // =========================================================

  void _openTransfer() {
    /*
     * Plus tard :
     *
     * context.push(
     *   AppRoutes.transfer,
     *   extra: _selectedBeneficiary,
     * );
     *
     * Si un bénéficiaire a été sélectionné depuis Home,
     * il sera donc prérempli.
     */

    _showComingSoon();
  }

  // =========================================================
  // TEMPORARY PLACEHOLDER
  // =========================================================
  void _showComingSoon() {
    final AppLocalizations l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
  }
}

// ===========================================================
// TEMPORARY TAB
// ===========================================================
class _ComingSoonPage extends StatelessWidget {
  final IconData icon;
  const _ComingSoonPage({required this.icon});
  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return SafeArea(
      bottom: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: const Color(0xFFAAA29E)),
            const SizedBox(height: 12),
            Text(
              l10n.comingSoon,
              style: const TextStyle(
                color: Color(0xFF756D69),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
