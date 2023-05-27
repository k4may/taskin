import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskin/task/task_create.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/user'),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Center(child: _buildTaskList()),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/taskcreate'),
      ),
    );
  }

  Widget _buildTaskList() {
    if (currentUser == null) {
      return const Text('Usuário não autenticado');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Ocorreu um erro ao carregar as tarefas.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final tasks = snapshot.data!.docs;

        // Separar os itens com isDone igual a true dos itens com isDone igual a false
        final List<DocumentSnapshot> doneTasks = [];
        final List<DocumentSnapshot> undoneTasks = [];

        for (final task in tasks) {
          final taskData = task.data() as Map<String, dynamic>;
          final isDone = taskData['isDone'] ?? false;

          if (isDone) {
            doneTasks.add(task);
          } else {
            undoneTasks.add(task);
          }
        }

        // Concatenar as duas listas, colocando primeiro os itens com isDone igual a false
        final sortedTasks = [...undoneTasks, ...doneTasks];

        return ListView.builder(
          itemCount: sortedTasks.length,
          itemBuilder: (context, index) {
            final task = sortedTasks[index];
            final taskData = task.data() as Map<String, dynamic>;

            return Dismissible(
              key: Key(task.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) => _deleteTask(task.id),
              child: ListTile(
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskCreateScreen(taskId: task.id),
                    ),
                  );
                }),
                trailing: Checkbox(
                  value: taskData['isDone'] ?? false,
                  onChanged: (value) => _updateTaskStatus(task.id, value),
                ),
                title: Text(
                  taskData['nome'],
                  style: TextStyle(
                    decoration: taskData['isDone'] ?? false
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                  taskData['descricao'],
                  style: TextStyle(
                    decoration: taskData['isDone'] ?? false
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _updateTaskStatus(String taskId, bool? isDone) async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'isDone': isDone});
      // _showToast('Status da tarefa atualizado com sucesso!');
    } catch (error) {
      _showToast('Erro ao atualizar o status da tarefa: $error');
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
      _showToast('Tarefa excluída com sucesso!');
    } catch (error) {
      _showToast('Erro ao excluir a tarefa: $error');
    }
  }
}
