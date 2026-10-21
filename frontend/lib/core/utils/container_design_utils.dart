import 'package:flutter/material.dart';

class ContainerDesignUtils {
  static const double radius = 16;
  static const double halfRadius = 8;
  static const double quarterRadius = 4;
  static const double padding = 16;
  static const double halfPadding = 8;
  static const double quarterPadding = 4;
  static const double margin = 16;

  // Full rounded
  static const BorderRadius allRadius = .all(.circular(radius));
  static const BorderRadius allHalfRadius = .all(.circular(halfRadius));
  static const BorderRadius allQuarterRadius = .all(.circular(quarterRadius));

  // Top rounded corners
  static const BorderRadius topRadius = .vertical(top: .circular(radius));
  static const BorderRadius topHalfRadius = .vertical(
    top: .circular(halfRadius),
  );
  static const BorderRadius topQuraterRadius = .vertical(
    top: .circular(quarterRadius),
  );

  // Bottom rounded corners
  static const BorderRadius bottomRadius = .vertical(bottom: .circular(radius));

  // Left rounded corners
  static const BorderRadius leftRadius = .horizontal(left: .circular(radius));

  // Right rounded corners
  static const BorderRadius rightRadius = .horizontal(right: .circular(radius));
  static const BorderRadius rightHalfRadius = .horizontal(
    right: .circular(halfRadius),
  );
  static const BorderRadius rightQuarterRadius = .horizontal(
    right: .circular(quarterRadius),
  );
}
