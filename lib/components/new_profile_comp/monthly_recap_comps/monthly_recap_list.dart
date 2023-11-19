import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/components/new_profile_comp/monthly_recap_comps/current_month.dart';
import 'package:shared_photo/components/new_profile_comp/monthly_recap_comps/empty_month.dart';
import 'package:shared_photo/components/new_profile_comp/monthly_recap_comps/published_month.dart';
import 'package:shared_photo/components/new_profile_comp/monthly_recap_comps/unpublished_month.dart';

class MonthlyRecapList extends StatelessWidget {
  const MonthlyRecapList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          CurrentMonth(month: "NOV", year: "'23"),
          SizedBox(width: 10),
          PublishedMonth(month: "OCT", year: "'23'"),
          SizedBox(width: 10),
          UnpublishedMonth(month: "SEP", year: "'23'"),
          SizedBox(width: 10),
          EmptyMonth(month: "AUG", year: "'23'")
        ],
      ),
    );
  }
}
