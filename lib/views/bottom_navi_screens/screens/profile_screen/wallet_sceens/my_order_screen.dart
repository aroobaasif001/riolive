import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart';

import '../../../../../utile/dialog_helper.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ---- Responsive helpers (base: 390 x 844) ----
    final size = MediaQuery.of(context).size;
    double sw(double v) => v * (size.width / 390);
    double sh(double v) => v * (size.height / 844);
    double sp(double v) => v * (size.width / 390);

    // ---- Tiny gaps ----
    SizedBox h(double v) => SizedBox(height: sh(v));
    SizedBox w(double v) => SizedBox(width: sw(v));

    // ---- Common icons ----
    const _icoDollar20 = Image(image: AssetImage('assets/icons/dolloricon.png'), height: 20, width: 20);
    const _icoDollar32 = Image(image: AssetImage('assets/icons/dolloricon.png'), height: 32, width: 32);
    const _icoMuoder   = Image(image: AssetImage('assets/images/muodericon.png'), height: 16, width: 12);
    const _icoWatch    = Image(image: AssetImage('assets/icons/watch.png'), height: 52, width: 52);
    const _bigDollar   = Image(image: AssetImage('assets/images/bigdollorimage.png'), height: 112, width: 112);

    // ---- Reusable label/value row ----
    Row kvRow({
      required String left,
      required String right,
      bool showDollar = false,
      double lf = 18,
      double rf = 20,
      FontWeight lw = FontWeight.w400,
      FontWeight rw = FontWeight.w400,
      Color lc = Colors.black,
      Color rc = Colors.black38,
      Widget? tailIcon,
    }) {
      return Row(
        children: [
          CustomText(left, fontSize: sp(lf), fontWeight: lw, color: lc),
          const Spacer(),
          if (showDollar) _icoDollar20,
          if (showDollar) w(5),
          CustomText(right, fontSize: sp(rf), fontWeight: rw, color: rc),
          if (tailIcon != null) w(5),
          if (tailIcon != null) tailIcon,
        ],
      );
    }

    // ---- Outline / Filled pill button (kept for right button) ----
    Expanded pillButton({
      required String label,
      bool filled = false,
    }) {
      return Expanded(
        child: CustomContainer(
          height: sh(56),
          conColor: filled ? const Color(0xFFA3C5FF) : null,
          border: filled
              ? Border.all(width: sw(1), color: const Color(0xFFB7C6E0))
              : Border.all(width: sw(1), color: const Color(0xFF9BB9FF)),
          borderRadius: BorderRadius.circular(sw(100)),
          child: CustomContainer(
            conColor: filled ? null : Colors.white,
            borderRadius: BorderRadius.circular(sw(100)),
            child: Center(
              child: CustomText(
                label,
                fontSize: sp(18),
                fontWeight: filled ? FontWeight.w700 : FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    // ---- Purple "Remain" panel ----
    Widget remainPanel() {
      return CustomContainer(
        height: sh(122),
        width: double.infinity,
        conColor: const Color(0xC9889AF3),
        borderRadius: BorderRadius.circular(sw(20)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Stopwatch overlap (top-left)
            Positioned(top: -sh(18), left: -sw(10), child: _icoWatch),

            // Left: "Remain" + timer
            Positioned(
              left: sw(10),
              top: sh(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'Remain',
                    fontSize: sp(18),
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  h(8),
                  CustomText(
                    '01:48:17', // spaced like mock
                    fontSize: sp(18),
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ],
              ),
            ),

            // Right: speech-bubble with BLUE border + light blue fill
            Positioned(
              top: sh(5),
              right: sw(5),
              child: CustomContainer(
                width: sw(234),                 // 👈 match mock width
                height: sh(114),                // 👈 fixed height to align with purple card
                conColor: const Color(0xFF8FA9FF),      // border color layer
                borderRadius: BorderRadius.circular(sw(16)),
                child: CustomContainer(
                  conColor: const Color(0xFFC3F0FF),  // inner fill
                  borderRadius: BorderRadius.circular(sw(14)),
                  padding: EdgeInsets.fromLTRB(
                    sw(14), sh(5), sw(14), sh(12),
                  ),
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    'Please pay immediately and upload the receipt. If you exceed the time limit, the payment qualification of the order will be cancelled.',
                    color: Colors.black,
                    fontSize: sp(14.5),
                    fontWeight: FontWeight.w500,
                    lineHeight: 1.32,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    maxLines: 7,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }


    // ---- White details card (no fixed height; lets content size naturally) ----
    Widget detailsCard() {
      return CustomContainer(
        width: double.infinity,
        padding: EdgeInsets.all(sw(16)),
        borderRadius: BorderRadius.circular(sw(12)),
        conColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // wrap content, avoid tight layout issues
          children: [
            kvRow(left: 'Total income', right: '100,000', showDollar: true,
                lw: FontWeight.w600, rw: FontWeight.w600, lf: 20, rf: 20, lc: Colors.black),
            h(25),
            kvRow(left: 'Order income:', right: '97,000', showDollar: true, lf: 18, rf: 20),
            h(25),
            kvRow(left: 'Reward:', right: '3,000', showDollar: true, lf: 18, rf: 20),
            h(25),
            kvRow(left: 'Order Number:', right: '97,000', lf: 18, rf: 20, tailIcon: _icoMuoder),
            h(20),
            Divider(color: Colors.black.withOpacity(0.4), thickness: 1),
            h(20),
            kvRow(left: 'Order:', right: '100,000', showDollar: true,
                lw: FontWeight.w600, rw: FontWeight.w600, lf: 20, rf: 20, lc: Colors.black),
            h(25),
            Row(children: [
              CustomText('Amount of payment:', color: Colors.black,
                  fontWeight: FontWeight.w400, fontSize: sp(18)),
              w(70),
              CustomText('\$10', color: Colors.black38,
                  fontWeight: FontWeight.w400, fontSize: sp(20)),
            ]),
            h(25),
            kvRow(left: 'Payment channels:', right: 'Localpayment', lf: 18, rf: 20),
            h(25),
            kvRow(left: 'Account:', right: '000256625', lf: 18, rf: 20, tailIcon: _icoMuoder),
            h(25),
            kvRow(left: 'Recipient Name:', right: '000256625', lf: 18, rf: 20, tailIcon: _icoMuoder),
          ],
        ),
      );
    }

    // ---- Top purple summary card ----
    Widget summaryCard() {
      // keep helpers in scope: sw(), sh(), sp(), h(), w(), _icoDollar20/_icoDollar32/_bigDollar
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: sh(170)), // ✅ responsive, avoids overflow
        child: CustomContainer(
          padding: EdgeInsets.symmetric(horizontal: sw(20), vertical: sh(20)),
          width: double.infinity,
          conColor: const Color(0xffE3D2FF),
          borderRadius: BorderRadius.circular(sw(20)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // content auto-sizes (no overflow)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    'Total Coin income',
                    fontSize: sp(20),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  SizedBox(height: sh(20)),
                  Row(
                    children: [
                      _icoDollar32,
                      SizedBox(width: sw(8)),
                      CustomText(
                        '100,000',
                        fontSize: sp(20),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: sh(20)),
                  Row(
                    children: [
                      CustomText(
                        'Rewards',
                        fontSize: sp(20),
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      SizedBox(width: sw(6)),
                      _icoDollar20,
                      SizedBox(width: sw(6)),
                      CustomText(
                        '3000',
                        fontSize: sp(20),
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),

              // decorative coin image (scaled & positioned responsively)
              Positioned(
                top: sh(15),
                left: sw(190),
                child: _bigDollar,
              ),
            ],
          ),
        ),
      );
    }


    // ----- LOCK text scale so UI stays same on small/mid/large & avoids overflow -----
    final mq = MediaQuery.of(context);

    return MediaQuery(
      data: mq.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          body: CustomContainer(
            image: const DecorationImage(
              image: AssetImage("assets/images/Livebroadcastdatabg.jpg"),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const RioliveAppBar(title: 'My Orders'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sw(20), vertical: sh(12)),
                    child: Column(
                      children: [
                        summaryCard(),
                        h(15),
                        detailsCard(),   // expands to content, no overflow
                        h(40),
                        remainPanel(),
                        h(18),

                        // ===== Buttons row =====
                        Row(
                          children: [
                            // Left: Unable to pay → open receipt bottom sheet
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => showUploadReceiptSheet(
                                  context,
                                  onTapUpload: () {},  // TODO: open picker
                                  onTapSubmit: () {},  // TODO: submit
                                  submitEnabled: false,
                                ),
                                child: CustomContainer(
                                  height: sh(56),
                                  border: Border.all(width: sw(1), color: const Color(0xFF9BB9FF)),
                                  borderRadius: BorderRadius.circular(sw(100)),
                                  child: CustomContainer(
                                    conColor: Colors.white,
                                    borderRadius: BorderRadius.circular(sw(100)),
                                    child: Center(
                                      child: CustomText(
                                        'Unable to pay',
                                        fontSize: sp(18),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            w(16),

                            // Right: Already paid
                            pillButton(label: 'Already paid', filled: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
