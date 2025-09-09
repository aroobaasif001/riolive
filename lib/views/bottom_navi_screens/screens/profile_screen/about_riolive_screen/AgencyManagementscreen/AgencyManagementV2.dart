import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';

import '../../../../../../customwidgets/custom_gradient_button.dart';
import 'HostApplicationScreen.dart'; // e.g. RioliveAppBar

class AgencyManagementV2 extends StatefulWidget {
  const AgencyManagementV2({super.key});

  @override
  State<AgencyManagementV2> createState() => _AgencyManagementV2State();
}

class _AgencyManagementV2State extends State<AgencyManagementV2> {
  String _filter = 'All Creator';
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final line = Colors.black.withOpacity(.08);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background (optional): pastel image/gradient
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg11.png', // <-- apna path
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
                        // ===== Top summary card =====
                        CustomContainer(
                          conColor: const Color(0xffEFD8D8),
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ), // 🔥 reduced padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 26,
                                    backgroundImage: AssetImage(
                                      "assets/images/profile.png",
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const CustomText(
                                              "Alexander",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            const SizedBox(width: 4),
                                            CustomContainer(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const CustomText(
                                                "Agency",
                                                fontSize: 11,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        const CustomText(
                                          "ID: 10209804",
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.copy,
                                          color: Colors.black54,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: CustomText(
                                  'Agency Code:   2XD56C',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.copy,
                                color: Colors.black54,
                                size: 14,
                              ),

                              const SizedBox(height: 5), // spacing kam
                              const Divider(),
                              Row(
                                children: [
                                  // 👨‍💻 Support agent image
                                  Image.asset(
                                    "assets/icons/supporticon.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  const CustomText(
                                    "Support",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    child: CustomContainer(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Color(0xffE0F7E9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        "assets/images/rio2.png",
                                        width: 25,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                  const CustomText(
                                    "Rio",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(width: 6),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/bar_chart.png", // apna bar chart icon yahan lagao
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  const CustomText(
                                    "My Agency Level",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const Spacer(),
                                  const CustomText(
                                    "C:10%",
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ===== Invite Agency / Host card =====
                        CustomContainer(
                          conColor: Colors.white.withOpacity(.9),
                          borderRadius: BorderRadius.circular(14),
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                'Invite Host',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomContainer(
                                      conColor: const Color(0xFFF5F9FF),
                                      borderRadius: BorderRadius.circular(10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: const [
                                          CustomText(
                                            'Number of Host',
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.chevron_right,
                                            size: 18,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  CustomGradientButton(
                                    text: "Invite Host",
                                    width: 100,
                                    height: 30,
                                    borderRadius: 24,
                                    gradientColors: const [
                                      Color(0xffFE7E07),
                                      Color(0xffFFDE67),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    textColor: Colors.black,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 1),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomContainer(
                                      conColor: const Color(0xFFF0FFF4),
                                      borderRadius: BorderRadius.circular(10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: const [
                                          CustomText(
                                            'Host application',
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.chevron_right,
                                            size: 18,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const HostApplicationScreen());
                                    },
                                    child: CustomContainer(
                                      borderRadius: BorderRadius.circular(18),
                                      padding: const EdgeInsets.symmetric(horizontal: 3),
                                      child: Image.asset(
                                        'assets/images/bell9.png',
                                        width: 120,
                                        height: 80,
                                      ),
                                    ),
                                  )

                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ===== Tabs text + divider =====
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            CustomText(
                              'SUMMARY',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            CustomText('Mine', color: Colors.black87),
                            CustomText('Sub AGENCY', color: Colors.black87),
                            CustomText('Host', color: Colors.black87),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: line,
                        ),

                        const SizedBox(height: 12),

                        // ===== Image under tabs =====
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'assets/images/agency_banner.png',
                            fit: BoxFit.contain,
                            height: 30,
                          ),
                        ),


                        const SizedBox(height: 12),

                        // ===== My Commission card =====
                        CustomContainer(
                          conColor: const Color(0xFFB1C2F0),
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  CustomText(
                                    'My Commission',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  Spacer(),
                                  CustomText(
                                    'History list',
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.monetization_on,
                                    color: Color(0xffFDD835),
                                    size: 20,
                                  ),
                                  SizedBox(width: 6),
                                  CustomText(
                                    '0',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomContainer(
                          conColor: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                '01/10/2024–01/11/2024',
                                fontSize: 13,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 8),

                              // My Commission Rate: 10%
                              Row(
                                children: const [
                                  CustomText(
                                    'My Commission Rate: ',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  CustomText(
                                    '10%',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF5B7BFF), // blue like mock
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // % labels row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  CustomText(
                                    '8%',
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                  CustomText(
                                    '10%',
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                  CustomText(
                                    '12%',
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                  CustomText(
                                    '16%',
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                  CustomText(
                                    '20%',
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // progress bar (orange fill + light blue track)
                              LayoutBuilder(
                                builder: (context, c) {
                                  const double progress =
                                      0.35; // <- fill percent (0..1). 10% = 0.10
                                  final barHeight = 8.0;
                                  return Stack(
                                    children: [
                                      // track
                                      Container(
                                        width: c.maxWidth,
                                        height: barHeight,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD7E9FF),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                      ),
                                      // fill
                                      Container(
                                        width: c.maxWidth * progress,
                                        height: barHeight,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5A856),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),

                              const SizedBox(height: 8),

                              // money ticks row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/coin.png',
                                        width: 18,
                                        height: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      const CustomText(
                                        '0',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/coin.png',
                                        width: 18,
                                        height: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      const CustomText(
                                        '2M',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/coin9.png',
                                        width: 18,
                                        height: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      const CustomText(
                                        '10M',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/coin.png',
                                        width: 18,
                                        height: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      const CustomText(
                                        '50M',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/coin9.png',
                                        width: 18,
                                        height: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      const CustomText(
                                        '150M',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // inner green panel (Earnings in the Past 30 Days ...)
                              CustomContainer(
                                conColor: const Color(0xFFE6FAE9),
                                borderRadius: BorderRadius.circular(14),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 15,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // left pie icon
                                    Image.asset(
                                      'assets/images/pie.png',
                                      width: 26,
                                      height: 55,
                                    ),

                                    const SizedBox(width: 7),

                                    // texts
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const CustomText(
                                                'Earnings in the Past 30 Days:  ',
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              const SizedBox(width: 4),
                                              const CustomText(
                                                '10',
                                                fontSize: 13,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              const CustomText(
                                                'Need  ',
                                                fontSize: 13,
                                                color: Colors.black,
                                              ),
                                              Image.asset(
                                                'assets/icons/coin9.png',
                                                width: 16,
                                                height: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              const CustomText(
                                                '20 to progress to the next level',
                                                fontSize: 13,
                                                color: Colors.black,
                                              ),
                                              const CustomText(
                                                '12%',
                                                fontSize: 13,
                                                color: Color(0xFF5B7BFF),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ===== Filter row: left dropdown + right search =====
                        Row(
                          children: [
                            // left dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: line),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _filter,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'All Creator',
                                      child: CustomText(
                                        'All Creator',
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Host',
                                      child: CustomText(
                                        'Host',
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Sub Agency',
                                      child: CustomText(
                                        'Sub Agency',
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _filter = v ?? _filter),
                                ),
                              ),
                            ),

                            const Spacer(),

                            // right search
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: line),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                height: 40,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      size: 18,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: _searchCtrl,
                                        style: const TextStyle(fontSize: 13),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          hintText: 'Search ID',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ===== Simple container (table) =====
                        // ⬇️ Replace the whole CustomContainer(...) block with this:
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFF6E8FF), Color(0xFFF4EFFF)], // soft pink/purple bg (image jaisa)
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              // ---------- Header ----------
                              Row(
                                children: const [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Host ID',
                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                                    ),
                                  ),
                                  // vertical line
                                  SizedBox(
                                    width: 1, height: 24,
                                    child: ColoredBox(color: Color(0x1F000000)), // ~12% black
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Host Earning',
                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1, height: 24,
                                    child: ColoredBox(color: Color(0x1F000000)),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'My Commission',
                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // horizontal line
                              const SizedBox(
                                height: 1, width: double.infinity,
                                child: ColoredBox(color: Color(0x1F000000)),
                              ),

                              // ---------- Row 1 (Raaj) ----------
                              SizedBox(
                                height: 56,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text('Raaj',
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                                          SizedBox(height: 2),
                                          Text('ID:1236548',
                                              style: TextStyle(fontSize: 12, color: Colors.black54)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 1, height: 36,
                                      child: ColoredBox(color: Color(0x1F000000)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('100k',
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                                          const SizedBox(width: 6),
                                          Image.asset(
                                            'assets/icons/coin.png',
                                            width: 16, height: 16,
                                            errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.attach_money, size: 16, color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 1, height: 36,
                                      child: ColoredBox(color: Color(0x1F000000)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('10k',
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                                          const SizedBox(width: 6),
                                          Image.asset(
                                            'assets/icons/coin.png',
                                            width: 16, height: 16,
                                            errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.attach_money, size: 16, color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 1, width: double.infinity,
                                child: ColoredBox(color: Color(0x1F000000)),
                              ),

                              // ---------- Row 2 (Mansi) ----------
                              SizedBox(
                                height: 56,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text('Mansi',
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                                          SizedBox(height: 2),
                                          Text('ID:1236548',
                                              style: TextStyle(fontSize: 12, color: Colors.black54)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 1, height: 36,
                                      child: ColoredBox(color: Color(0x1F000000)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('0.00',
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                                          const SizedBox(width: 6),
                                          Image.asset(
                                            'assets/icons/coin.png',
                                            width: 16, height: 16,
                                            errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.attach_money, size: 16, color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 1, height: 36,
                                      child: ColoredBox(color: Color(0x1F000000)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('0.00',
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                                          const SizedBox(width: 6),
                                          Image.asset(
                                            'assets/icons/coin.png',
                                            width: 16, height: 16,
                                            errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.attach_money, size: 16, color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 1, width: double.infinity,
                                child: ColoredBox(color: Color(0x1F000000)),
                              ),

                              // ---------- Row 3 (Sukana) ----------
                              SizedBox(
                                height: 56,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text('Sukana',
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                                          SizedBox(height: 2),
                                          Text('ID:1236548',
                                              style: TextStyle(fontSize: 12, color: Colors.black54)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 1, height: 36,
                                      child: ColoredBox(color: Color(0x1F000000)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('0.00',
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                                          const SizedBox(width: 6),
                                          Image.asset(
                                            'assets/icons/coin.png',
                                            width: 16, height: 16,
                                            errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.attach_money, size: 16, color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 1, height: 36,
                                      child: ColoredBox(color: Color(0x1F000000)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('0.00',
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                                          const SizedBox(width: 6),
                                          Image.asset(
                                            'assets/icons/coin.png',
                                            width: 16, height: 16,
                                            errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.attach_money, size: 16, color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
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
