// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// Project imports:
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/todo.dart';
import '../providers/todo_notifier.dart';

/// Page for adding or editing a todo
class AddEditTodoPage extends ConsumerStatefulWidget {
  const AddEditTodoPage({super.key, this.todo});

  final dynamic todo;

  @override
  ConsumerState<AddEditTodoPage> createState() => _AddEditTodoPageState();
}

class _AddEditTodoPageState extends ConsumerState<AddEditTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool get isEditing => widget.todo != null;

  Todo? get todoEntity => widget.todo as Todo?;

  @override
  void initState() {
    super.initState();
    if (isEditing && todoEntity != null) {
      _titleController.text = todoEntity!.title;
      _descriptionController.text = todoEntity!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoNotifierProvider);

    ref.listen<AsyncValue<void>>(todoNotifierProvider, (previous, next) {
      next.when(
        data: (_) {
          context.showSnackBar(
            isEditing
                ? 'Todo updated successfully'
                : 'Todo created successfully',
          );
          Navigator.of(context).pop();
        },
        loading: () {},
        error: (error, stack) {
          context.showSnackBar(error.toString(), isError: true);
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Todo' : 'Add Todo'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _titleController,
                labelText: 'Title',
                hintText: 'Enter todo title',
                validator: (value) =>
                    Validators.required(value, fieldName: 'Title'),
                textInputAction: TextInputAction.next,
              ),
              const Gap(AppConstants.defaultPadding),
              AppTextField(
                controller: _descriptionController,
                labelText: 'Description',
                hintText: 'Enter todo description',
                maxLines: 4,
                validator: (value) =>
                    Validators.required(value, fieldName: 'Description'),
                textInputAction: TextInputAction.done,
              ),
              const Gap(AppConstants.largePadding),
              AppButton(
                text: isEditing ? 'Update Todo' : 'Create Todo',
                onPressed: _saveTodo,
                isLoading: todoState.isLoading,
                icon: isEditing ? Icons.update : Icons.add,
              ),
              const Gap(AppConstants.defaultPadding),
              AppButton(
                text: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
                variant: AppButtonVariant.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTodo() {
    if (!_formKey.currentState!.validate()) return;

    context.hideKeyboard();

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (isEditing && todoEntity != null) {
      final updatedTodo = todoEntity!.copyWith(
        title: title,
        description: description,
        updatedAt: DateTime.now(),
      );
      ref.read(todoNotifierProvider.notifier).updateTodo(updatedTodo);
    } else {
      ref
          .read(todoNotifierProvider.notifier)
          .createTodo(title: title, description: description);
    }
  }

  void _showDeleteConfirmation() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (todoEntity != null) {
                ref
                    .read(todoNotifierProvider.notifier)
                    .deleteTodo(todoEntity!.id);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
