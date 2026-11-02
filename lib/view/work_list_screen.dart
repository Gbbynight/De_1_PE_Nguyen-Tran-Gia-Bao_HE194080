
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'edit_work_screen.dart';
import '../viewmodel/work_viewmodel.dart';
class WorkListScreen extends ConsumerWidget {
  const WorkListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final worksAsync = ref.watch(workViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý công việc'),
        backgroundColor: Colors.blue,
      ),

      body: worksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),

        data: (works) {
          return ListView.builder(
            itemCount: works.length,

            itemBuilder: (context, index) {
              final work = works[index];

              return Card(
                child: ListTile(
                    leading: Icon(
                      [
                        Icons.laptop_mac,
                        Icons.menu_book,
                        Icons.co_present,
                        Icons.article,
                      ][index % 4],
                      size: 28,
                      color: Colors.black87,
                    ),

                  title: Text(work.name),

                  subtitle: Text(work.description),

                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => EditWorkScreen(work: work),
                     ),
                     );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
