import 'package:flutter/material.dart';
import 'package:shared_photo/components/new_create_album_comp/create_album_info_comp/duration_item.dart';

class DurationSelectorGrid extends StatelessWidget {
  DurationSelectorGrid({super.key});

  final List<Map<String, dynamic>> durationOptions = [
    {"number": "24", "durationString": "HOURS"},
    {"number": "2", "durationString": "DAYS"},
    {"number": "1", "durationString": "WEEK"},
    {"number": "", "durationString": "CUSTOM"}
  ];

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        childAspectRatio: 4 / 5,
      ),
      children: List.generate(
        durationOptions.length,
        (index) => DurationItem(
          number: durationOptions[index]["number"].toString(),
          durationString: durationOptions[index]["durationString"],
          item: index,
        ),
      ),
    );
  }
}
