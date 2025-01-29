import 'package:flutter/material.dart';
import 'package:shared_photo/components/profile_comp/event_section/profile_event_item.dart';
import 'package:shared_photo/models/album.dart';

class EventViewer extends StatefulWidget {
  final Map<String, List<Album>> eventMap;
  final ValueNotifier<String> selectedPageNotifier;
  final List<Album>? minusOneList;
  final String? minusOneName;
  final Map<String, String> headers;
  const EventViewer({
    super.key,
    required this.eventMap,
    required this.selectedPageNotifier,
    this.minusOneList,
    this.minusOneName,
    required this.headers,
  });

  @override
  State<EventViewer> createState() => _EventViewerState();
}

class _EventViewerState extends State<EventViewer> {
  String? selectedMonth;

  @override
  void initState() {
    if (widget.minusOneList != null && widget.minusOneName != null) {
      widget.eventMap[widget.minusOneName!] = widget.minusOneList!;
    }

    if (widget.eventMap.isNotEmpty) {
      selectedMonth = widget.eventMap.keys.toList()[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.selectedPageNotifier,
        builder: (context, value, _) {
          if (value != '') {
            selectedMonth = value;
          }

          if (widget.eventMap[selectedMonth] != null) {
            return ListView.separated(
              itemCount: widget.eventMap[selectedMonth]!.length + 1,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index != widget.eventMap[selectedMonth]!.length) {
                  return _buildAnimatedItem(
                    index: index,
                    child: ProfileEventItem(
                      event: widget.eventMap[selectedMonth]![index],
                      headers: widget.headers,
                    ),
                  );
                } else {
                  return SizedBox(height: 50);
                }
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 25);
              },
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }
}

Widget _buildAnimatedItem({required int index, required Widget child}) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 100.0, end: 0.0),
    duration: Duration(milliseconds: 25 + index * 100),
    curve: Curves.easeInOut,
    builder: (context, double offset, child) {
      return Transform.translate(
        offset: Offset(0, offset),
        child: AnimatedOpacity(
          opacity: offset == 0 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: child,
        ),
      );
    },
    child: child,
  );
}
