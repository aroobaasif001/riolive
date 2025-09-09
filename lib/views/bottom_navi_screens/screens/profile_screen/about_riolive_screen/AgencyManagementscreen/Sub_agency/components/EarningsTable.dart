import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

class EarningsTable extends StatelessWidget {
  const EarningsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final vline = Colors.black.withOpacity(.12);

    return CustomContainer(
      // gradient + radius via decoration
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF6E8FF), Color(0xFFF4EFFF)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Header
          Row(
            children: const [
              Expanded(flex: 4, child: CustomText('Host ID', fontWeight: FontWeight.w700, color: Colors.black)),
              _VLine(),
              Expanded(flex: 3, child: CustomText('Host Earning', fontWeight: FontWeight.w700, color: Colors.black)),
              _VLine(),
              Expanded(flex: 3, child: CustomText('My Commission', fontWeight: FontWeight.w700, color: Colors.black)),
            ],
          ),
          const SizedBox(height: 8),
          const _HLine(),

          // Rows
          _DataRow(name: 'Raaj', id: '1236548', earning: '100k', commission: '10k', vColor: vline),
          const _HLine(),
          _DataRow(name: 'Mansi', id: '1236548', earning: '0.00', commission: '0.00', vColor: vline),
          const _HLine(),
          _DataRow(name: 'Sukana', id: '1236548', earning: '0.00', commission: '0.00', vColor: vline),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String name;
  final String id;
  final String earning;
  final String commission;
  final Color vColor;

  const _DataRow({
    required this.name,
    required this.id,
    required this.earning,
    required this.commission,
    required this.vColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // left: name + id
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(name, fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                const SizedBox(height: 2),
                CustomText('ID:$id', fontSize: 12, color: Colors.black54),
              ],
            ),
          ),

          const _VLine(),

          // center: earning + coin
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(earning, fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                const SizedBox(width: 6),
                Image.asset(
                  'assets/icons/coin.png',
                  width: 16,
                  height: 16,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.attach_money, size: 16, color: Colors.black87),
                ),
              ],
            ),
          ),

          const _VLine(),

          // right: commission + coin
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(commission, fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                const SizedBox(width: 6),
                Image.asset(
                  'assets/icons/coin.png',
                  width: 16,
                  height: 16,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.attach_money, size: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VLine extends StatelessWidget {
  const _VLine();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 1,
      height: 36,
      child: ColoredBox(color: Color(0x1F000000)), // ~12% black
    );
  }
}

class _HLine extends StatelessWidget {
  const _HLine();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 1,
      width: double.infinity,
      child: ColoredBox(color: Color(0x1F000000)),
    );
  }
}
