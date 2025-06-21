import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/todo.dart';
import '../providers/todo_notifier.dart';

/// Widget representing a single todo item
class TodoItem extends ConsumerWidget {
  const TodoItem({required this.todo, super.key, this.onTap});

  final Todo todo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              // Completion checkbox
              Checkbox(
                value: todo.isCompleted,
                onChanged: (_) => _toggleCompletion(ref),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Gap(AppConstants.smallPadding),

              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: todo.isCompleted
                            ? colorScheme.onSurface.withValues(alpha: 0.6)
                            : colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (todo.description.isNotEmpty) ...[
                      const Gap(4),
                      Text(
                        todo.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.isCompleted
                              ? colorScheme.onSurface.withValues(alpha: 0.4)
                              : colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Gap(AppConstants.smallPadding),

                    // Task metadata
                    Row(
                      children: [
                        // Status chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: todo.isCompleted
                                ? colorScheme.primary.withValues(alpha: 0.1)
                                : colorScheme.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            todo.isCompleted ? 'Completed' : 'Pending',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: todo.isCompleted
                                  ? colorScheme.primary
                                  : colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),

                        // Created date
                        Text(
                          todo.createdAt.isToday
                              ? 'Today'
                              : todo.createdAt.isYesterday
                              ? 'Yesterday'
                              : todo.createdAt.formatDate,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action button
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showActionMenu(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleCompletion(WidgetRef ref) {
    ref.read(todoNotifierProvider.notifier).toggleTodoCompletion(todo.id);
  }

  void _showActionMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.of(context).pop();
                onTap?.call();
              },
            ),
            ListTile(
              leading: Icon(todo.isCompleted ? Icons.undo : Icons.check),
              title: Text(
                todo.isCompleted ? 'Mark as Pending' : 'Mark as Completed',
              ),
              onTap: () {
                Navigator.of(context).pop();
                _toggleCompletion(ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                _showDeleteConfirmation(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(todoNotifierProvider.notifier).deleteTodo(todo.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
