import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';

class FilterSearchRow extends StatelessWidget {
  final String filter;
  final ValueChanged<String?> onFilterChanged;
  final TextEditingController searchCtrl;
  final Color line;

  const FilterSearchRow({
    super.key,
    required this.filter,
    required this.onFilterChanged,
    required this.searchCtrl,
    required this.line,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: line),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: filter,
              items: const [
                DropdownMenuItem(
                  value: 'All Creator',
                  child: CustomText('All Creator', fontSize: 13, color: Colors.black),
                ),
                DropdownMenuItem(
                  value: 'Host',
                  child: CustomText('Host', fontSize: 13, color: Colors.black),
                ),
                DropdownMenuItem(
                  value: 'Sub Agency',
                  child: CustomText('Sub Agency', fontSize: 13, color: Colors.black),
                ),
              ],
              onChanged: onFilterChanged,
            ),
          ),
        ),

        const Spacer(),

        // Search
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: line),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            height: 40,
            child: Row(
              children: const [
                Icon(Icons.search, size: 18, color: Colors.black54),
                SizedBox(width: 8),
                _SearchField(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller parent se aa raha hai; isliye yahan simple TextField as child
    // Parent se pass karna ho to is widget ko Stateless rakh kar parameterized bhi kar sakte ho
    return Expanded(
      child: TextField(
        style: const TextStyle(fontSize: 13),
        decoration: const InputDecoration(
          isDense: true,
          hintText: 'Search ID',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
