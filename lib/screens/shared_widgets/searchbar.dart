import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';

class CustomSearchBar<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) displayText;
  final Function(T) onSelected;
  final String hintText;
  final Widget Function(T)? itemBuilder;

  const CustomSearchBar({
    super.key,
    required this.items,
    required this.displayText,
    required this.onSelected,
    this.hintText = 'Search...',
    this.itemBuilder,
  });

  @override
  State<CustomSearchBar<T>> createState() => _CustomSearchBarState<T>();
}

class _CustomSearchBarState<T> extends State<CustomSearchBar<T>> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<T> _filtered = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _showSuggestions = false);
      }
    });
  }

  void _onChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = [];
        _showSuggestions = false;
      } else {
        _filtered = widget.items.where((item) {
          return widget.displayText(item).toLowerCase().contains(query.toLowerCase());
        }).toList();
        _showSuggestions = true;
      }
    });
  }

  void _onSelect(T item) {
    _controller.text = widget.displayText(item);
    setState(() => _showSuggestions = false);
    _focusNode.unfocus();
    widget.onSelected(item);
  }

  void _clear() {
    _controller.clear();
    setState(() {
      _filtered = [];
      _showSuggestions = false;
    });
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _focusNode.hasFocus ? AppColors.primary : AppColors.grayMedium,
              width: 1,
            ),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _onChanged,
            style: TextStyle(fontSize: 14, color: AppColors.primary),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: 14, color: AppColors.primaryLight.withOpacity(0.6)),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: _focusNode.hasFocus ? AppColors.primary : AppColors.primaryLight,
                size: 20,
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: _clear,
                      child: Icon(Icons.close_rounded, color: AppColors.primaryLight, size: 18),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),

        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryLightest, width: 1),
            ),
            constraints: const BoxConstraints(maxHeight: 220),
            child: _filtered.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.search_off_rounded, color: AppColors.primaryLight, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'No results found',
                          style: TextStyle(fontSize: 13, color: AppColors.primaryLight),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shrinkWrap: true,
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: AppColors.primaryLightest,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final item = _filtered[index];
                      return InkWell(
                        onTap: () => _onSelect(item),
                        borderRadius: BorderRadius.circular(8),
                        child: widget.itemBuilder != null
                            ? widget.itemBuilder!(item)
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.history_rounded,
                                      size: 16,
                                      color: AppColors.primaryLight,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        widget.displayText(item),
                                        style: TextStyle(fontSize: 13, color: AppColors.primary),
                                      ),
                                    ),
                                    Icon(
                                      Icons.north_west_rounded,
                                      size: 14,
                                      color: AppColors.primaryLight,
                                    ),
                                  ],
                                ),
                              ),
                      );
                    },
                  ),
          ),
      ],
    );
  }
}
