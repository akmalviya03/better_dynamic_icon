part of 'implementation.dart';

///Holds details of the icon
class IconDetails {
  ///Android -> Full Activity Name
  ///iOS -> AppIcon Name
  final String accessName;

  ///Android -> android:label provided inside activity
  ///iOS -> imageasset name
  final String label;

  ///Icon is currently active or not
  final bool enabled;

  ///Image data
  final Uint8List iconData;

  ///Create IconDetails by specifying details
  IconDetails(
      {required this.accessName,
      required this.label,
      required this.enabled,
      required this.iconData});

  ///Provide map of icon values
  factory IconDetails.fromJson(Map<dynamic, dynamic> values) {
    return IconDetails(
        accessName: values['name'] ?? "NA",
        label: values['label'] ?? "NA",
        enabled: values['enabled'] ?? false,
        iconData: values['icon'] ?? Uint8List.fromList([]));
  }
}
