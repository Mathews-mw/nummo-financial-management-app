import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:nummo/theme/app_colors.dart';

class MonthSelector extends StatefulWidget {
  final void Function(int) onSelectMonth;

  const MonthSelector({super.key, required this.onSelectMonth});

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  int _selectedMonth = DateTime.now().month;
  late int _selectedMonthIndex;

  final ScrollController _scrollController = ScrollController();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();

    final currentMonth = DateTime.now().month;
    _selectedMonthIndex = yearMonths.indexWhere(
      (item) => item.$1 == currentMonth,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _itemScrollController.scrollTo(
        index: _selectedMonthIndex,
        duration: const Duration(milliseconds: 500),
        alignment: 0.5, // centraliza
        curve: Curves.easeInOut,
      );
    });
  }

  int get _currentIndex {
    return yearMonths.indexWhere((element) => element.$1 == _selectedMonth);
  }

  void _goToPreviousMonth() {
    final index = _currentIndex;

    if (index > 0) {
      setState(() {
        _selectedMonth = yearMonths[index - 1].$1;
        widget.onSelectMonth(yearMonths[index - 1].$1);
        _scrollToIndex(index - 1);
      });
    }
  }

  void _goToNextMonth() {
    final index = _currentIndex;

    if (index < yearMonths.length - 1) {
      setState(() {
        _selectedMonth = yearMonths[index + 1].$1;
        widget.onSelectMonth(yearMonths[index + 1].$1);
        _scrollToIndex(index + 1);
      });
    }
  }

  void _scrollToIndex(int index) {
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.5, // centraliza o item
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 18,
            padding: EdgeInsets.all(0),
            icon: Icon(PhosphorIcons.caretLeft()),
            onPressed: _goToPreviousMonth,
          ),
          Expanded(
            child: ScrollablePositionedList.separated(
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 32),
              itemCount: yearMonths.length,
              itemBuilder: (ctx, index) {
                final isSelected = yearMonths[index].$1 == _selectedMonth;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMonth = yearMonths[index].$1;
                      widget.onSelectMonth(yearMonths[index].$1);
                    });
                    _itemScrollController.scrollTo(
                      index: index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      alignment: 0.5, // centraliza o item
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      yearMonths[index].$2,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.gray500,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            iconSize: 18,
            icon: Icon(PhosphorIcons.caretRight()),
            onPressed: _goToNextMonth,
          ),
        ],
      ),
    );
  }
}

final yearMonths = [
  (1, 'JAN'),
  (2, 'FEV'),
  (3, 'MAR'),
  (4, 'ABR'),
  (5, 'MAI'),
  (6, 'JUN'),
  (7, 'JUL'),
  (8, 'AGO'),
  (9, 'SET'),
  (10, 'OUT'),
  (11, 'NOV'),
  (12, 'DEZ'),
];
