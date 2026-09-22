import 'features/beneficiaries/presentation/view/beneficiaries_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'dart:ui';
import 'app/router/app_routes.dart';
import 'app/navigation/payflow_bottom_navigation.dart';
import 'app/navigation/payflow_transfer_button.dart';
import 'features/home/domain/model/home_beneficiary_model.dart';
import 'features/home/presentation/view/home_view.dart';
import 'features/home/presentation/view_model/home_view_model.dart';
import 'features/transfer/domain/model/transfer_draft_seed.dart';
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
  static const double _collapseDistance = 118;
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  double _navigationCollapse = 0;
  HomeBeneficiaryModel? _selectedBeneficiary;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // =========================================================
  // BUILD
  // =========================================================
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final double bottomSafeArea = media.padding.bottom;
    final double compactInset = (media.size.width - 78) / 2;
    final double navigationInset = lerpDouble(
      34,
      compactInset > 34 ? compactInset : 34,
      _navigationCollapse,
    )!;
    final double transferBottom = lerpDouble(
      bottomSafeArea + 82,
      bottomSafeArea + 29,
      _navigationCollapse,
    )!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                onPageChanged: (index) {
                  if (_selectedIndex != index && mounted) {
                    setState(() => _selectedIndex = index);
                  }
                },
                itemBuilder: (context, index) => KeyedSubtree(
                  key: ValueKey('payflow-tab-$index'),
                  child: _buildPage(index),
                ),
              ),
            ),
          ),
          if (_selectedIndex == 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: transferBottom,
              child: Center(
                child: PayflowTransferButton(
                  label: l10n.transferAction,
                  collapseProgress: _navigationCollapse,
                  onTap: _openTransfer,
                ),
              ),
            ),
          Positioned(
            left: navigationInset,
            right: navigationInset,
            bottom: 0,
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.zero,
              child: PayflowBottomNavigation(
                selectedIndex: _selectedIndex,
                collapseProgress: _navigationCollapse,
                onSelected: _selectTab,
                onExpand: _expandNavigation,
                items: [
                  PayflowNavigationItem(
                    selectedIcon: Icons.home_rounded,
                    unselectedIcon: Icons.home_outlined,
                    label: l10n.homeTab,
                  ),
                  PayflowNavigationItem(
                    selectedIcon: Icons.people_alt_rounded,
                    unselectedIcon: Icons.people_outline_rounded,
                    label: l10n.contactsTab,
                  ),
                  PayflowNavigationItem(
                    selectedIcon: Icons.group_add_rounded,
                    unselectedIcon: Icons.group_add_outlined,
                    label: l10n.referralTab,
                  ),
                  PayflowNavigationItem(
                    selectedIcon: Icons.person_rounded,
                    unselectedIcon: Icons.person_outline_rounded,
                    label: l10n.profileTab,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SELECTED PAGE
  // =========================================================
  Widget _buildPage(int index) {
    switch (index) {
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
          onTransactionTap: (transaction) {
            context.push(AppRoutes.transactionDetailPath(transaction.id));
          },

          onViewAllTransactions: () {
            context.push(AppRoutes.transactionHistory);
          },

          onMoreTransactions: () {
            context.push(AppRoutes.transactionHistory);
          },
        );

      // -------------------------------------------------------
      // CONTACTS
      // -------------------------------------------------------
      case 1:
        return BeneficiariesView(
          onBeneficiaryTap: (contact) {
            _openTransferForBeneficiary(contact.id);
          },
        );
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
  // NAVIGATION MOTION
  // =========================================================
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }

    double delta = 0;
    if (notification is ScrollUpdateNotification) {
      delta = notification.scrollDelta ?? 0;
    } else if (notification is OverscrollNotification) {
      delta = notification.overscroll;
    }

    if (delta != 0) {
      _setNavigationCollapse(_navigationCollapse + (delta / _collapseDistance));
    }
    return false;
  }

  void _setNavigationCollapse(double value) {
    final double next = value.clamp(0.0, 1.0).toDouble();
    if ((next - _navigationCollapse).abs() < 0.001 || !mounted) {
      return;
    }
    setState(() => _navigationCollapse = next);
  }

  void _expandNavigation() {
    if (_navigationCollapse == 0) {
      return;
    }
    setState(() => _navigationCollapse = 0);
  }

  void _selectTab(int index) {
    if (_selectedIndex == index || !_pageController.hasClients) {
      return;
    }

    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  // =========================================================
  // TRANSFER
  // =========================================================

  Future<void> _openTransfer() async {
    final transferId = await context.push<String>(
      AppRoutes.transfer,
      extra: TransferDraftSeed(
        beneficiaryId: _selectedBeneficiary?.id,
        sentCurrency: context
            .read<HomeViewModel>()
            .home
            ?.exchangeRate
            ?.sourceCurrencyCode,
      ),
    );
    await _refreshHomeAndOpenTransfer(transferId);
  }

  Future<void> _openTransferForBeneficiary(String beneficiaryId) async {
    final transferId = await context.push<String>(
      AppRoutes.transfer,
      extra: TransferDraftSeed(
        beneficiaryId: beneficiaryId,
        sentCurrency: context
            .read<HomeViewModel>()
            .home
            ?.exchangeRate
            ?.sourceCurrencyCode,
      ),
    );
    await _refreshHomeAndOpenTransfer(transferId);
  }

  Future<void> _refreshHomeAndOpenTransfer(String? transferId) async {
    if (!mounted || transferId == null) {
      return;
    }
    await context.read<HomeViewModel>().load();
    if (!mounted) {
      return;
    }
    await context.push(AppRoutes.transactionDetailPath(transferId));
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
