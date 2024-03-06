import 'package:flutter/material.dart';
import 'custom_search_bar.dart';
import 'filter_button.dart';

class SearchBarWithFilter extends StatelessWidget {
  const SearchBarWithFilter(
      {super.key,
      required this.searchController,
      required this.hintText,
      required this.onChanged,
      required this.filterDialogContent});

  final TextEditingController searchController;
  final String hintText;
  final ValueChanged<String?> onChanged;
  final Widget filterDialogContent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 7,
          child: CustomSearchBar(
              controller: searchController,
              hintText: hintText,
              onChanged: (String? newVal) => onChanged(newVal)),
        ),
        Expanded(
            child: FilterButton(
          dialogContent: filterDialogContent,
        ))
      ],
    );
  }
}
