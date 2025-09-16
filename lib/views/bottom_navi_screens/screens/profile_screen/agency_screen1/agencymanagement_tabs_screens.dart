import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/agency_screen1/tabs/bottomhost_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/agency_screen1/tabs/bottommine_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/agency_screen1/tabs/bottomsubagency_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/agency_screen1/tabs/bottomsummarypart_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/agency_screen1/tabs/tophost_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/agency_screen1/tabs/topmine_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/agency_screen1/tabs/topsubagency_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/agency_screen1/tabs/topsummarypart_screen.dart';

class AgencyTabsEasy extends StatelessWidget {
  const AgencyTabsEasy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 4, // SUMMARY, Host, Sub AGENCY, MINE
          child: CustomContainer(
            height: double.infinity,
            width: double.infinity,
            image: DecorationImage(image: AssetImage('assets/images/AgencyManagementManagebg..png'),fit:BoxFit.fill ),

            child: Column(
              children: [
                RioliveAppBar(title: 'Agency Management',),
                // TOP area (changes with tab)
                SizedBox(
                  height: 300, // top ki fixed height
                  child: const TabBarView(
                    physics: NeverScrollableScrollPhysics(), // swipe disable (sirf TabBar se change)
                    children: [
                      TopSummaryScreen(),
                      TopMineScreen(),
                      TopSubAgencyScreen(),
                      TopHostScreen(),
                    ],
                  ),
                ),

                const SizedBox(height: 15), // ↑ space above TabBar

                // CENTER: TabBar (no horizontal scroll, 10px label padding, 15px outer padding)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15), // outer left/right 15
                  child: TabBar(
                    isScrollable: false, // ❌ no horizontal scroll
                    dividerColor: Colors.transparent,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w500,fontSize: 14),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                    // each tab inner 10
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(color: Colors.black, width: 3),
                      insets: EdgeInsets.symmetric(horizontal: 24), // short underline
                    ),
                    tabs:  [
                      Tab(text: 'SUMMARY',),
                      Tab(text: 'MINE'),
                      Tab(text: 'Sub AGENCY'),
                      Tab(text: 'Host'),
                    ],
                  ),
                ),

                const SizedBox(height: 15), // ↓ space below TabBar

                // BOTTOM area (changes with tab)
                const Expanded(
                  child: TabBarView(
                    children: [
                      BottomSummaryScreen(),
                      BottomMineScreen(),
                      BottomSubAgencyScreen(),
                      BottomHostScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
