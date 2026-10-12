import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/payment_operator_logo.dart';
import '../../domain/model/home_beneficiary_model.dart';
import '../util/country_flag_util.dart';

/// A stable frame for the transfer destination, with motion following the
/// physical position of the quick contacts. Selection remains owned by HomePage.
class HomeBeneficiaryCard extends StatefulWidget {
  const HomeBeneficiaryCard({
    super.key,
    required this.beneficiary,
    required this.beneficiaries,
    this.onTap,
  });

  final HomeBeneficiaryModel? beneficiary;
  final List<HomeBeneficiaryModel> beneficiaries;
  final VoidCallback? onTap;

  @override
  State<HomeBeneficiaryCard> createState() => _HomeBeneficiaryCardState();
}

class _HomeBeneficiaryCardState extends State<HomeBeneficiaryCard> {
  Offset _movement = const Offset(0, 1);
  int _revision = 0;

  @override
  void didUpdateWidget(covariant HomeBeneficiaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = oldWidget.beneficiary;
    final next = widget.beneficiary;
    if (previous?.id == next?.id) return;

    _revision++;
    if (previous == null) {
      _movement = const Offset(0, 1);
    } else if (next == null) {
      _movement = const Offset(0, -1);
    } else {
      var previousIndex = widget.beneficiaries.indexWhere(
        (contact) => contact.id == previous.id,
      );
      if (previousIndex < 0) {
        previousIndex = oldWidget.beneficiaries.indexWhere(
          (contact) => contact.id == previous.id,
        );
      }
      final nextIndex = widget.beneficiaries.indexWhere(
        (contact) => contact.id == next.id,
      );
      _movement = previousIndex < 0 || nextIndex < 0
          ? const Offset(0, 1)
          : Offset(nextIndex > previousIndex ? 1 : -1, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final bodyHeight = 104.0 * (textScale > 1 ? textScale : 1);
    final direction = Directionality.of(context) == TextDirection.rtl ? -1 : 1;
    final movement = Offset(_movement.dx * direction, _movement.dy);
    // Unique per change, including A -> B -> A while A is still animating out.
    final contentKey = ValueKey('home-destination-$_revision');

    return Container(
      key: const ValueKey('home-beneficiary-card'),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.primary.withValues(alpha: .035)],
        ),
        border: Border.all(color: AppColors.secondary.withValues(alpha: .14)),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryDark.withValues(alpha: .055),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Semantics(
        button: widget.onTap != null,
        label: l10n.transferAction,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeBeneficiaryLabel,
                    style: const TextStyle(
                      color: AppColors.secondaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: bodyHeight,
                    child: ClipRect(
                      child: AnimatedSwitcher(
                        duration: reduceMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 320),
                        reverseDuration: reduceMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 240),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        layoutBuilder: (currentChild, previousChildren) => Stack(
                          fit: StackFit.expand,
                          children: [
                            ...previousChildren,
                            if (currentChild != null) currentChild,
                          ],
                        ),
                        transitionBuilder: (child, animation) {
                          final incoming = child.key == contentKey;
                          final start = movement * (incoming ? -.22 : .22);
                          return IgnorePointer(
                            ignoring: !incoming,
                            child: ExcludeSemantics(
                              excluding: !incoming,
                              child: FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: start,
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: contentKey,
                          child: widget.beneficiary == null
                              ? _PaymentNetwork(hint: l10n.homeSelectBeneficiaryHint)
                              : _BeneficiaryDetails(beneficiary: widget.beneficiary!),
                        ),
              ),
            ),
          ),
        ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentNetwork extends StatelessWidget {
  const _PaymentNetwork({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey('home-payment-network'),
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        children: [
          Expanded(
            flex: 4,
            child: Image.asset(
              'assets/images/login/payflow_logo.png',
              height: 40,
              fit: BoxFit.contain,
              semanticLabel: 'PayFlow',
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ExcludeSemantics(
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: AppColors.secondary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Semantics(
              label: 'Orange Money',
              child: const PaymentOperatorLogo(name: 'Orange Money', height: 40),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Semantics(
              label: 'MTN Mobile Money',
              child: const PaymentOperatorLogo(
                name: 'MTN Mobile Money',
                height: 40,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        hint,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          height: 1.4,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _BeneficiaryDetails extends StatelessWidget {
  const _BeneficiaryDetails({required this.beneficiary});

  final HomeBeneficiaryModel beneficiary;

  @override
  Widget build(BuildContext context) {
    final flag = CountryFlagUtil.fromIsoCode2(beneficiary.countryIsoCode2);
    final phone = beneficiary.phoneE164?.trim();
    final operator = beneficiary.operatorName?.trim();
    return Semantics(
      key: ValueKey('home-beneficiary-details-${beneficiary.id}'),
      container: true,
      liveRegion: true,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.secondary.withValues(alpha: .09),
            child: flag.isEmpty
                ? const Icon(Icons.person_rounded, color: AppColors.secondary)
                : Text(
                    flag,
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(fontSize: 22),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  beneficiary.displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                if (phone != null && phone.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
                if (operator != null && operator.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    operator,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.secondaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (operator != null && operator.isNotEmpty) ...[
            const SizedBox(width: 10),
            PaymentOperatorLogo(name: operator, width: 48, height: 36),
          ],
        ],
      ),
    );
  }
}
