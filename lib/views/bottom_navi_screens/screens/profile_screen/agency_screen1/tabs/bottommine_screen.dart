import 'package:flutter/material.dart';

class BottomMineScreen extends StatelessWidget {
  const BottomMineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // soft lilac background like the screenshot
      decoration: const BoxDecoration(
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _CalendarChip(),
              SizedBox(height: 14),
              _MyCommissionCard(),
              SizedBox(height: 14),
              _RateAndProgressCard(),

              // ▼▼▼ APPENDED PART (do not remove existing code above) ▼▼▼
              SizedBox(height: 18),
              _CreatorFilterSearch(),
              SizedBox(height: 16),
              _HostCommissionTable(),
            ],
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────── Calendar chip ───────────────────────── */

class _CalendarChip extends StatelessWidget {
  const _CalendarChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 96,
      padding: const EdgeInsets.only(left: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFF94E1), Color(0xFF2FC4DB)], // purple → cyan
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 20,
            width: 20,
            child: Image(image: AssetImage('assets/icons/calendar_24.png')),
          ),
          const SizedBox(width: 2),
          const Text(
            '2024-20',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              height: 12,
              width: 12,
              child: const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/* ─────────────────────── Blue “My Commission” card ─────────────────────── */

class _MyCommissionCard extends StatelessWidget {
  const _MyCommissionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      decoration: BoxDecoration(
        color: const Color(0xFFB1C2F0), // periwinkle blue
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // left block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Commission',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Image.asset('assets/icons/dolloricon.png', height: 28, width: 28),
                    const SizedBox(width: 8),
                    const Text(
                      '0',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // right “History list”
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('History list',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────── White card: date range + rate + segmented progress ───────────── */

class _RateAndProgressCard extends StatelessWidget {
  const _RateAndProgressCard();

  @override
  Widget build(BuildContext context) {
    const currentRate = 10.0; // %
    const minRate = 8.0;
    const maxRate = 20.0;

    return Container(
      height: 262,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FA),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('01/10/2024–01/11/2024',
              style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                    text: 'My Commission Rate: ',
                    style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                TextSpan(
                    text: '10%',
                    style: TextStyle(fontSize: 18, color: Color(0xFF246BFF), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // top ticks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _TinyLabel('8%'),
              _TinyLabel('10%'),
              _TinyLabel('12%'),
              _TinyLabel('16%'),
              _TinyLabel('20%'),
            ],
          ),
          const SizedBox(height: 6),

          // progress line
          LayoutBuilder(
            builder: (context, constraints) {
              final fraction =
              ((currentRate - minRate) / (maxRate - minRate)).clamp(0.0, 1.0);
              final filled = constraints.maxWidth * fraction;
              return Stack(
                children: [
                  // base line (blue)
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8E9FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // filled (orange)
                  Container(
                    width: filled,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9A3D), Color(0xFFFFC46A)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),

          // coin milestones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _CoinMilestone(label: '0'),
              _CoinMilestone(label: '2M'),
              _CoinMilestone(label: '10M'),
              _CoinMilestone(label: '50M'),
              _CoinMilestone(label: '150M'),
            ],
          ),
          const SizedBox(height: 16),
          // green info box
          Container(
            height: 67,
            decoration: BoxDecoration(
              color: const Color(0xFFCBF3CD),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              children: [
                // Left pie icon (bigger like shot)
                Image(image: AssetImage('assets/images/pie-chart 1.png'),height: 37,width:28 ,),
                const SizedBox(width: 10),

                // Center texts (wrap to avoid overflow)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Line 1: "Earnings in the Past 30 Days: 0 [coin]"
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Earnings in the Past 30 Days: ',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                              const TextSpan(
                                text: '0',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Image.asset(
                                    'assets/icons/dolloricon.png',
                                    height: 18,
                                    width: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          softWrap: true,
                          textAlign: TextAlign.start,
                        ),
                        // Line 2: "Need [coin] 200000 to progress to the next level 12%"
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Need  ',
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Image.asset(
                                  'assets/icons/dolloricon.png',
                                  height: 15,
                                  width: 15,
                                ),
                              ),
                              const TextSpan(
                                text: ' 200000  ',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                              ),
                              const TextSpan(
                                text: 'to progress to the next level ',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(
                                text: '12%',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF246BFF),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          softWrap: true,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}

/* ───────────────────────── helpers ───────────────────────── */

class _TinyLabel extends StatelessWidget {
  final String text;
  const _TinyLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Colors.black.withOpacity(.7),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CoinMilestone extends StatelessWidget {
  final String label;
  const _CoinMilestone({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/icons/dolloricon.png', height: 20, width: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

/* ─────────────────────── APPENDED WIDGETS FOR LIST ─────────────────────── */

class _CreatorFilterSearch extends StatelessWidget {
  const _CreatorFilterSearch();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'All Creator',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 6),
        Image(image: AssetImage('assets/icons/drap...png'),height:10 ,width: 12,),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            height: 39,
            width: 226,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: const [
                BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 2)),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: const Center(
              child: TextField(
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search ID',
                  hintStyle: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(Icons.search, size: 20, color: Colors.black87),
                  prefixIconConstraints: BoxConstraints(minWidth: 36, minHeight: 24),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HostCommissionTable extends StatelessWidget {
  const _HostCommissionTable();

  @override
  Widget build(BuildContext context) {
    // ratios (aapke given)
    const double flex0 = 2.1; // Host ID
    const double flex1 = 2.7; // Host Earning
    const double flex2 = 2.9; // My Commission

    // ↓ 0.0 se 36.0 kiya — isi se vertical lines header me kitni dikhengi
    const headerBandHeight = 0.0;

    final headerStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
    final cellStyle   = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
    final idStyle     = TextStyle(fontSize: 12, color: Colors.black.withOpacity(.48), fontWeight: FontWeight.w600);

    final rows = <_RowData>[
      _RowData(name: 'Raaj',   id: 'ID:1236548', earning: '100k', commission: '10k', earnHasCoin: true,  commHasCoin: true),
      _RowData(name: 'Mansi',  id: 'ID:1236548', earning: '0.00', commission: '0.00', earnHasCoin: true,  commHasCoin: true),
      _RowData(name: 'Sukana', id: 'ID:1236548', earning: '0.00', commission: '0.00', earnHasCoin: true,  commHasCoin: true),
      _RowData.blank(),
      _RowData.blank(),
    ];

    // ints for Expanded.flex
    const int f0 = 25, f1 = 35, f2 = 35;

    return LayoutBuilder(
      builder: (context, constraints) {
        final total = flex0 + flex1 + flex2;
        final x1 = constraints.maxWidth * (flex0 / total);
        final x2 = constraints.maxWidth * ((flex0 + flex1) / total);

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER (no borders)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Row(
                    children: [
                      Expanded(flex: f0, child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text('Host ID', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      )),
                      Expanded(flex: f1, child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text('Host Earning', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      )),
                      Expanded(flex: f2, child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('My Commission', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
                      )),
                    ],
                  ),
                ),

                // DATA TABLE (with borders)
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(flex0),
                    1: FlexColumnWidth(flex1),
                    2: FlexColumnWidth(flex2),
                  },
                  border: TableBorder(
                    horizontalInside: BorderSide(color: Colors.black.withOpacity(.15), width: 1),
                    verticalInside:   BorderSide(color: Colors.black.withOpacity(.15), width: 1),
                    top: BorderSide.none, bottom: BorderSide.none, left: BorderSide.none, right: BorderSide.none,
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    ...rows.map((r) {
                      if (r.isBlank) {
                        return TableRow(children: List.generate(3, (_) => const SizedBox(height: 86)));
                      }
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 8, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.name, style: cellStyle),
                                const SizedBox(height: 4),
                                Text(r.id, style: idStyle),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(r.earning, style: cellStyle),
                                if (r.earnHasCoin) ...[
                                  const SizedBox(width: 6),
                                  Image.asset('assets/icons/dolloricon.png', height: 20, width: 20),
                                ],
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 16, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(r.commission, style: cellStyle),
                                if (r.commHasCoin) ...[
                                  const SizedBox(width: 6),
                                  Image.asset('assets/icons/dolloricon.png', height: 20, width: 20),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),

            // === Vertical separators drawn into header (shorter & with top gap) ===
            Positioned(
              left: x1, top: 6, height: headerBandHeight - 12,
              child: Container(width: 1, color: Colors.black.withOpacity(.15)),
            ),
            Positioned(
              left: x2, top: 6, height: headerBandHeight - 12,
              child: Container(width: 1, color: Colors.black.withOpacity(.15)),
            ),
          ],
        );
      },
    );
  }
}
/* data holder */
class _RowData {
  final String name;
  final String id;
  final String earning;
  final String commission;
  final bool earnHasCoin;
  final bool commHasCoin;
  final bool isBlank;

  _RowData({
    required this.name,
    required this.id,
    required this.earning,
    required this.commission,
    required this.earnHasCoin,
    required this.commHasCoin,
  }) : isBlank = false;

  _RowData.blank()
      : name = '',
        id = '',
        earning = '',
        commission = '',
        earnHasCoin = false,
        commHasCoin = false,
        isBlank = true;
}
