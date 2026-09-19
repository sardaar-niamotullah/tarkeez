import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';

enum PricingPlanType { regularDeal, goodDeal, betterDeal, bestDeal }

class PricingPlan {
  const PricingPlan({
    required this.type,
    required this.dealValue,
    required this.duration,
    required this.price,
    required this.saveAmount,
    required this.color,
    required this.colorBright,
    required this.iconPath,
    this.isActive = false,
  });

  final PricingPlanType type;
  final String dealValue;
  final String duration;
  final String price;
  final String saveAmount;
  final Color color;
  final Color colorBright;
  final String iconPath;
  final bool isActive;
}

const pricingPlans = [
  PricingPlan(
    type: PricingPlanType.regularDeal,
    dealValue: 'Regular deal',
    duration: '3 months',
    price: '1.9',
    saveAmount: 'Save 0%',
    color: AppTheme.blue,
    colorBright: AppTheme.blueBright,
    iconPath: SvgPaths.bookmark,
  ),
  PricingPlan(
    type: PricingPlanType.goodDeal,
    dealValue: 'Good deal',
    duration: '6 months',
    price: '2.9',
    saveAmount: 'Save 23%',
    color: AppTheme.purple,
    colorBright: AppTheme.purpleBright,
    iconPath: SvgPaths.bookmark,
  ),
  PricingPlan(
    type: PricingPlanType.betterDeal,
    dealValue: 'Better deal',
    duration: '1 year',
    price: '3.9',
    saveAmount: 'Save 48%',
    color: AppTheme.pink,
    colorBright: AppTheme.pinkBright,
    iconPath: SvgPaths.bookmark,
  ),
  PricingPlan(
    type: PricingPlanType.bestDeal,
    dealValue: 'Best deal',
    duration: 'Life time',
    price: '4.9',
    saveAmount: 'Maximum saving',
    color: AppTheme.fireTone,
    colorBright: AppTheme.lightningGold,
    iconPath: SvgPaths.bookmark,
  ),
];