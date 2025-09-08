import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';

class ExhangeScreen extends StatelessWidget {
  const ExhangeScreen({super.key});

  // colors
  static const _labelDark = Colors.black;
  static const _cardLav   = Color(0xFFB1ABF7); // first purple card
  static const _panelLav  = Color(0xFFD7CCF8); // outer panel for Exchange Rate

  @override
  Widget build(BuildContext context) {
    // local builders (functions, not classes)
    Widget inputLike(String iconPath, String hint) {
      return CustomContainer(
        height: 51,
        width: double.infinity,
        conColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  height: 24,
                  width: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(child: SizedBox()),
            Expanded(
              flex: 100,
              child: Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget rateRow({
      required String leftLabel,
      required String rightLabel,
      bool isLast = false,
    }) {
      final divider = Container(
        height: 1,
        color: Colors.white.withOpacity(0.6),
      );

      return Column(
        children: [
          SizedBox(
            height: 64,
            child: Row(
              children: [
                // Left cell
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          leftLabel,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Image(
                          image: AssetImage('assets/icons/dolloricon.png'),
                          height: 20,
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                // Right cell
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Image(
                          image: AssetImage('assets/icons/dolloricon.png'),
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          rightLabel,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Image(
                          image: AssetImage('assets/icons/purpaldaimond.png'),
                          height: 22,
                          width: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isLast) divider,
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          image: const DecorationImage(
            image: AssetImage("assets/images/Livebroadcastdatabg.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar (right text "Records")
                const RioliveAppBar(
                  title: 'Exchange',
                  rightText: 'Records',
                  rightTextFontSize: 12,
                  rightTextFontWeight: FontWeight.w400,
                ),

                // ===== Available balance line =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Available coin balance:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: _labelDark,
                        ),
                      ),
                      SizedBox(width: 3),
                      Image(
                        image: AssetImage('assets/icons/dolloricon.png'),
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        '12,321,210',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: _labelDark,
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== Purple Card (inputs) =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: CustomContainer(
                    height:255 ,
                    width:385 ,
                    conColor: Color(0xffBBABF7),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Coins amount:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: _labelDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        inputLike('assets/icons/dolloricon.png',
                            'Enter the amount of Coin'),
                        const SizedBox(height: 22),
                        const Text(
                          'Diamond amount (1 coin = 0.94 diamond)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: _labelDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        inputLike('assets/icons/purpaldaimond.png',
                            'Automatic convert in to Diamonds'),
                      ],
                    ),
                  ),
                ),

                // ===== Redeem Button (gradient) =====
                const SizedBox(height: 22),
                Center(
                  child: CustomGradientButton(text: 'Redeem',width: 180,height: 51, onPressed: () {

                  },borderRadius: 30,
                  gradientColors: [
                    Color(0xff0076F6),
                    Color(0xffE496FF)
                  ],),
                ),

                const SizedBox(height: 18),

                // ====== LAST PART: Exchange Rate Panel ======
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: CustomContainer(
                    width: double.infinity,
                    conColor: _panelLav,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      children: [
                        const Text(
                          'Exchange Rate',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: _labelDark,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // === Table (direct code) ===
                        Builder(
                          builder: (_) {
                            const double br = 30;
                            const double headerH =67;

                            return CustomContainer(
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(br),
                              conColor: Colors.transparent,
                              child: Stack(
                                children: [
                                  // center vertical divider under header
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        margin: const EdgeInsets.only(top: headerH),
                                        width: 1,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ),

                                  // header
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(br),
                                      topRight: Radius.circular(br),
                                    ),
                                    child: Container(
                                      height: headerH,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFF8EC2FB),
                                            Color(0xFFE496FF)
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'Coin',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                                      .withOpacity(0.9),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'Unit Price',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                                      .withOpacity(0.9),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // rows
                                  Padding(
                                    padding: const EdgeInsets.only(top: headerH),
                                    child: Column(
                                      children: [
                                        rateRow(
                                          leftLabel: '≤  500 k',
                                          rightLabel: '100 = 94',
                                          isLast: false,
                                        ),
                                        rateRow(
                                          leftLabel: '≥  501 K',
                                          rightLabel: '100 = 96',
                                          isLast: false,
                                        ),
                                        rateRow(
                                          leftLabel: '≥  2.5 M',
                                          rightLabel: '100 = 99',
                                          isLast: true,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // outline
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(br),
                                          border: Border.all(
                                            color:
                                            Colors.white.withOpacity(0.6),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
