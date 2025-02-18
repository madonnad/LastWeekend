import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/components/create_event_comp/event_rounded_option.dart';

class EventOptionRow extends StatelessWidget {
  final IconData icon;
  final String rowTitle;
  final List<EventRoundedOption>? optionList;
  final VoidCallback? rowOnTap;
  final Widget? rowWidget;
  const EventOptionRow({
    super.key,
    required this.icon,
    required this.rowTitle,
    required this.optionList,
    this.rowOnTap,
    this.rowWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: rowOnTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            const Gap(10),
            Row(
              children: [
                Icon(
                  icon,
                  color: Color.fromRGBO(242, 243, 247, 1),
                  size: 20,
                ),
                const Gap(8),
                Text(
                  rowTitle,
                  style: GoogleFonts.lato(
                    color: Color.fromRGBO(242, 243, 247, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                rowOnTap != null
                    ? const Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromRGBO(242, 243, 247, 1),
                        size: 20,
                      )
                    : SizedBox.shrink(),
              ],
            ),
            Gap(optionList != null ? 10 : 0),
            optionList != null
                ? SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: optionList!.length,
                      itemBuilder: (contest, index) {
                        return optionList![index];
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 8);
                      },
                    ),
                  )
                : SizedBox.shrink(),
            Gap(rowWidget != null ? 10 : 0),
            rowWidget != null ? rowWidget! : SizedBox.shrink(),
            const Gap(10),
            const Divider(
              color: Colors.white54,
            )
          ],
        ),
      ),
    );
  }
}
