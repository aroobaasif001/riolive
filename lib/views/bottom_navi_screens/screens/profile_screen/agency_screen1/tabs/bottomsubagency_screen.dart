import 'package:flutter/material.dart';

class BottomSubAgencyScreen extends StatelessWidget {
  const BottomSubAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // same soft background feel
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF2EDF7), Color(0xFFF0E7F4)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _CalendarChip(),
              SizedBox(height: 14),
              _SummaryCard(),     // green card with "History list"
              SizedBox(height: 18),
              _FilterAndSearch(), // All Agency + search
              SizedBox(height: 16),
              _HostCommissionTable(), // 3-column table only
            ],
          ),
        ),
      ),
    );
  }
}

/* ────────── Calendar (top-left) ────────── */
class _CalendarChip extends StatelessWidget {
  const _CalendarChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFCC6BFF), Color(0xFF53C8E8)],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.calendar_today_rounded, size: 16, color: Colors.white),
          SizedBox(width: 8),
          Text('2024-20',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              )),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Colors.white),
        ],
      ),
    );
  }
}

/* ────────── Green summary card (with “History list”) ────────── */
class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFCCF2D8),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // History list — top-right inside the card
          const SizedBox(height: 6),
          // two columns content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10,left: 10),
              child: Row(
                children: [
                  // My Commission
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('My Commission',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('assets/icons/dolloricon.png', height: 24, width: 24),
                            const SizedBox(width: 6),
                            const Text('0', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // divider
                  // My Agency Commission
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text('My Agency Commission',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                          SizedBox(height: 8),
                          Text('10%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ────────── Filter + Search row ────────── */
class _FilterAndSearch extends StatelessWidget {
  const _FilterAndSearch();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('All Agency',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(width: 6),
        const Icon(Icons.arrow_drop_down, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 2)),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: const Center(
              child: TextField(
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search User ID',
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(Icons.search, size: 20),
                  prefixIconConstraints: BoxConstraints(minWidth: 32, minHeight: 20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/* ────────── 3-column table (only what’s in the image) ────────── */
class _HostCommissionTable extends StatelessWidget {
  const _HostCommissionTable();

  @override
  Widget build(BuildContext context) {
    // ratios (aapke given)
    const double flex0 = 2.1; // Host ID
    const double flex1 = 2.0; // Host Earning
    const double flex2 = 2.9; // My Commission

    // ↓ 0.0 se 36.0 kiya — isi se vertical lines header me kitni dikhengi
    const headerBandHeight = 0.0;

    final headerStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
    final cellStyle   = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
    final idStyle     = TextStyle(fontSize: 12, color: Colors.black.withOpacity(.48), fontWeight: FontWeight.w600);

    final rows = <_RowData>[
      _RowData(
        name: 'Ryan',
        id: 'ID:1236548',
        earning: '1000k',
        commission: '20k',
        earnHasCoin: true,
        commHasCoin: true,
      ),
      _RowData(
        name: 'Muneeb',
        id: 'ID:1236548',
        earning: '100k',
        commission: '2k',
        earnHasCoin: true,
        commHasCoin: true,
      ),
      _RowData(
        name: 'Sukana',
        id: 'ID:1236548',
        earning: '10k',
        commission: '200',
        earnHasCoin: true,
        commHasCoin: true,
      ),
      _RowData.blank(),
      _RowData.blank(),
    ];


    // ints for Expanded.flex
    const int f0 = 25, f1 = 30, f2 = 35;

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
                        child: Text('Agency Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      )),
                      Expanded(flex: f1, child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text('Earning', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
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
