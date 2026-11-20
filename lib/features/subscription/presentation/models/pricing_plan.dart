import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/asset_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';

enum PricingPlanType { regularDeal, goodDeal, betterDeal, bestDeal }

class PricingPlan {
  const new({
    required this.type,
    required this.productId,
    required this.dealValue,
    required this.duration,
    required this.months,
    required this.color,
    required this.colorBright,
    required this.iconPath,
  });

  final PricingPlanType type;
  final String productId;
  final String dealValue;
  final String duration;
  final int months;
  final Color color;
  final Color colorBright;
  final String iconPath;
}

const pricingPlans = [
  PricingPlan(
    type: PricingPlanType.regularDeal,
    productId: 'tarkeez_premium_1m',
    dealValue: 'Regular deal',
    duration: '1 month',
    months: 1,
    color: AppTheme.blue,
    colorBright: AppTheme.blueBright,
    iconPath: AssetPaths.bookmark,
  ),
  PricingPlan(
    type: PricingPlanType.goodDeal,
    productId: 'tarkeez_premium_3m',
    dealValue: 'Good deal',
    duration: '3 months',
    months: 3,
    color: AppTheme.purple,
    colorBright: AppTheme.purpleBright,
    iconPath: AssetPaths.bookmark,
  ),
  PricingPlan(
    type: PricingPlanType.betterDeal,
    productId: 'tarkeez_premium_6m',
    dealValue: 'Better deal',
    duration: '6 months',
    months: 6,
    color: AppTheme.pink,
    colorBright: AppTheme.pinkBright,
    iconPath: AssetPaths.bookmark,
  ),
  PricingPlan(
    type: PricingPlanType.bestDeal,
    productId: 'tarkeez_premium_1y',
    dealValue: 'Best deal',
    duration: '1 year',
    months: 12,
    color: AppTheme.fireTone,
    colorBright: AppTheme.lightningGold,
    iconPath: AssetPaths.bookmark,
  ),
];