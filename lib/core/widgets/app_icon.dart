import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _iconPaths = <String, String>{
  'washer':
      '<rect x="4" y="2.5" width="16" height="19" rx="2.5"/><circle cx="12" cy="14" r="4.2"/><path d="M7.5 6h.01M10.5 6h.01M14.5 6h3"/>',
  'fridge':
      '<rect x="6" y="2" width="12" height="20" rx="2.5"/><path d="M6 10h12M9 5.5v2M9 13v3"/>',
  'tools':
      '<path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/>',
  'chip':
      '<rect x="6" y="6" width="12" height="12" rx="2"/><rect x="9.5" y="9.5" width="5" height="5" rx=".8"/><path d="M9 2v4M15 2v4M9 18v4M15 18v4M2 9h4M2 15h4M18 9h4M18 15h4"/>',
  'bolt': '<path d="M13 2 4 14h7l-1 8 9-12h-7z"/>',
  'hat':
      '<path d="M4 16a8 8 0 0 1 16 0M2 16h20v3.5H2zM10 8.5V5h4v3.5"/>',
  'toolbox':
      '<rect x="3" y="8" width="18" height="12" rx="2"/><path d="M8 8V5h8v3M3 13.5h18"/><rect x="10.5" y="11.5" width="3" height="4" rx=".6"/>',
  'screw':
      '<path d="M6.5 3h11M12 3v3M8.5 6h7l-1.2 14.5a2.3 2.3 0 0 1-4.6 0zM9 10h6M9.3 14h5.4"/>',
  'search': '<circle cx="11" cy="11" r="7"/><path d="m21 21-4.5-4.5"/>',
  'back': '<path d="m15 18-6-6 6-6"/>',
  'box': '<path d="M21 8 12 3 3 8v8l9 5 9-5zM3 8l9 5 9-5M12 13v8"/>',
  'chevron-right': '<path d="m9 18 6-6-6-6"/>',
  'phone':
      '<path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3.1 19.5 19.5 0 0 1-6-6A19.8 19.8 0 0 1 2.1 4.2 2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .4 1.9.7 2.8a2 2 0 0 1-.5 2.1L8.1 9.9a16 16 0 0 0 6 6l1.3-1.3a2 2 0 0 1 2.1-.5c.9.3 1.8.6 2.8.7a2 2 0 0 1 1.7 2z"/>',
};

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.name, {
    super.key,
    this.size = 24,
    this.color = const Color(0xFF4A4A4A),
    this.strokeWidth = 1.8,
  });

  final String name;
  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final path = _iconPaths[name];
    if (path == null) {
      throw ArgumentError.value(name, 'name', 'Unknown SOGAME icon');
    }
    String channel(int value) => value.toRadixString(16).padLeft(2, '0');
    final colorHex =
        '#${channel(color.red)}${channel(color.green)}${channel(color.blue)}';
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="$colorHex" stroke-width="$strokeWidth" stroke-linecap="round" stroke-linejoin="round">$path</svg>',
      width: size,
      height: size,
      semanticsLabel: null,
    );
  }
}
