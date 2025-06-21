import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/todo_providers.dart';

/// Search bar widget for filtering todos
class TodoSearchBar extends ConsumerStatefulWidget {
  const TodoSearchBar({super.key});

  @override
  ConsumerState<TodoSearchBar> createState() => _TodoSearchBarState();
}

class _TodoSearchBarState extends ConsumerState<TodoSearchBar> {
  final _searchController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(todoSearchProvider.notifier).state = _searchController.text;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final searchQuery = ref.watch(todoSearchProvider);

    return AnimatedContainer(
      duration: AppConstants.shortAnimation,
      height: _isExpanded ? 80 : 0,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search todos...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(todoSearchProvider.notifier).state = '';
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.smallPadding,
            ),
          ),
          onChanged: (value) {
            ref.read(todoSearchProvider.notifier).state = value;
          },
        ),
      ),
    );
  }

  void toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) {
        _searchController.clear();
        ref.read(todoSearchProvider.notifier).state = '';
      }
    });
  }
}
