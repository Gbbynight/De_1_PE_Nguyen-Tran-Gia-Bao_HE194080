
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/work.dart';
import '../viewmodel/work_viewmodel.dart';

class EditWorkScreen extends ConsumerStatefulWidget {
  final Work work;

  const EditWorkScreen({
    super.key,
    required this.work,
  });

  @override
  ConsumerState<EditWorkScreen> createState() =>
      _EditWorkScreenState();
}

class _EditWorkScreenState extends ConsumerState<EditWorkScreen> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;

  final formKey = GlobalKey<FormState>();

  bool isCompleted = false;
  bool isSaving = false;


  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.work.name,
    );

    descriptionController = TextEditingController(
      text: widget.work.description,
    );

    isCompleted = widget.work.isCompleted;
  }


  Future<void> saveWork() async {
    if (isSaving || !formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    final updatedWork = Work(
      id: widget.work.id,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      isCompleted: isCompleted,
    );

    try {
      await ref
          .read(workViewModelProvider.notifier)
          .updateWork(updatedWork);

      if (!mounted) return;

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }


  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Work'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Hãy nhập tiêu đề';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),


            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),


            SwitchListTile(
              title: const Text('Đã Hoàn Thành'),
              value: isCompleted,
              onChanged: (value) {
                setState(() {
                  isCompleted = value;
                });
              },
            ),

            const SizedBox(height: 24),
            Row(
              children: [

                Expanded(
                  child: OutlinedButton(
                    onPressed: isSaving
                        ? null
                        : () {
                      Navigator.pop(context);
                    },
                    child: const Text('Hủy'),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ElevatedButton(
                    onPressed: isSaving ? null : saveWork,
                    child: Text(
                      isSaving ? 'Đang lưu...' : 'Lưu',
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
