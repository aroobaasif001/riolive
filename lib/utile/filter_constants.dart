import 'package:flutter/material.dart';

/// Filter types available for live streaming
class FilterConstants {
  // Filter types
  static const String none = 'none';
  static const String beauty = 'beauty';
  static const String vintage = 'vintage';
  static const String cool = 'cool';
  static const String warm = 'warm';

  /// Available filters with their display info
  static final List<FilterOption> availableFilters = [
    FilterOption(
      id: none,
      name: 'None',
      icon: Icons.filter_none,
      color: Colors.grey,
      description: 'No filter applied',
    ),
    FilterOption(
      id: beauty,
      name: 'Beauty',
      icon: Icons.face_retouching_natural,
      color: Colors.pink,
      description: 'Enhance facial features',
    ),
    FilterOption(
      id: vintage,
      name: 'Vintage',
      icon: Icons.camera_alt,
      color: Colors.amber,
      description: 'Classic vintage look',
    ),
    FilterOption(
      id: cool,
      name: 'Cool',
      icon: Icons.ac_unit,
      color: Colors.blue,
      description: 'Cool color tones',
    ),
    FilterOption(
      id: warm,
      name: 'Warm',
      icon: Icons.wb_sunny,
      color: Colors.orange,
      description: 'Warm color tones',
    ),
  ];
  
  /// Get filter by ID
  static FilterOption? getFilterById(String id) {
    try {
      return availableFilters.firstWhere((filter) => filter.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Get filter icon by ID
  static IconData getFilterIcon(String id) {
    final filter = getFilterById(id);
    return filter?.icon ?? Icons.filter_none;
  }
  
  /// Get filter color by ID
  static Color getFilterColor(String id) {
    final filter = getFilterById(id);
    return filter?.color ?? Colors.grey;
  }
}

/// Filter option model
class FilterOption {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  const FilterOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}

/// Beauty filter presets
class BeautyPresets {
  static const Map<String, Map<String, double>> presets = {
    'natural': {
      'beauty': 0.3,
      'smoothness': 0.4,
      'brightness': 0.1,
    },
    'enhanced': {
      'beauty': 0.6,
      'smoothness': 0.6,
      'brightness': 0.2,
    },
    'dramatic': {
      'beauty': 0.8,
      'smoothness': 0.8,
      'brightness': 0.3,
    },
  };
  
  /// Get preset values
  static Map<String, double>? getPreset(String presetName) {
    return presets[presetName];
  }
}
