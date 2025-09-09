import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart';

import 'components/CommissionCard.dart';
import 'components/EarningsTable.dart';
import 'components/FilterSearchRow.dart';
import 'components/InviteHostCard.dart';
import 'components/TopSummaryCard.dart';

class SubAgency extends StatefulWidget {
  const SubAgency({super.key});

  @override
  State<SubAgency> createState() => _SubAgencyState();
}

class _SubAgencyState extends State<SubAgency> {
  String _filter = 'All Creator';
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final line = Colors.black.withOpacity(.08);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg11.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: RioliveAppBar(title: 'Agency Management'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TopSummaryCard(),
                        const SizedBox(height: 12),
                        const InviteHostCard(),
                        const SizedBox(height: 12),

                        // Tabs Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            CustomText('SUMMARY', fontWeight: FontWeight.bold, color: Colors.black),
                            CustomText('Mine', color: Colors.black87),
                            CustomText('Sub AGENCY', color: Colors.black87),
                            CustomText('Host', color: Colors.black87),
                          ],
                        ),
                        const SizedBox(height: 15),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'assets/images/agency_banner.png',
                            fit: BoxFit.contain,
                            height: 30,
                          ),
                        ),
                        const SizedBox(height: 15),

                        const CommissionCard(),
                        const SizedBox(height: 15),

                        FilterSearchRow(
                          filter: _filter,
                          onFilterChanged: (v) => setState(() => _filter = v ?? _filter),
                          searchCtrl: _searchCtrl,
                          line: line,
                        ),
                        const SizedBox(height: 15),

                        const EarningsTable(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
