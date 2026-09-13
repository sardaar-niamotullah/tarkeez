import 'package:flutter/material.dart';

extension LabelBehaviorX on TextEditingController {
  FloatingLabelBehavior get labelBehavior => text.isNotEmpty ? .always : .auto;
}
