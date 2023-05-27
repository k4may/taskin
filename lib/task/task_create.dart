import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskin/widgets/form_select.dart';
import 'package:taskin/widgets/forms.dart';
import 'package:taskin/widgets/space.dart';

class TaskCreateScreen extends StatefulWidget {
  final String? taskId;

  const TaskCreateScreen({Key? key, this.taskId}) : super(key: key);

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final List<String> priori = ['Baixa', 'Média', 'Alta'];
  final List<String> tags = ['Casa', 'Trabalho', 'Outros'];
  int selectedIndexPrioridade = 0;
  int selectedIndexEtiqueta = 0;

  @override
  void dispose() {
    nomeController.dispose();
    description.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      loadTaskData();
    }
  }

  void loadTaskData() async {
    final taskDoc =
        FirebaseFirestore.instance.collection('tasks').doc(widget.taskId);

    final taskSnapshot = await taskDoc.get();
    if (taskSnapshot.exists) {
      final taskData = taskSnapshot.data() as Map<String, dynamic>;
      nomeController.text = taskData['nome'];
      description.text = taskData['descricao'];

      final prioridade = taskData['prioridade'];
      selectedIndexPrioridade = priori.indexWhere((item) => item == prioridade);
      final etiqueta = taskData['etiqueta'];
      selectedIndexEtiqueta = tags.indexWhere((item) => item == etiqueta);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId != null ? 'Editar Tarefa' : 'Criar Tarefa'),
        actions: [
          IconButton(
            onPressed: saveFormData,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                FormPad(
                  nomeController: nomeController,
                  labelText: 'Nome da tarefa',
                  hintText: 'Ex: Fazer Compras',
                  validatorText: 'A tarefa precisa de um nome',
                ),
                Spc(height: 8),
                FormPad(
                  nomeController: description,
                  labelText: 'Descrição da tarefa',
                  hintText: 'Ex: Lembrete para fazer compras',
                  validatorText: 'É necessária uma descrição',
                ),
                Spc(height: 8),
                // Inside the build method of _TaskCreateScreenState

                Row(
                  children: [
                    Expanded(
                      child: FormSelect(
                        labeltext: 'Prioridade',
                        items: priori,
                        initialValue: selectedIndexPrioridade,
                        onSelect: (selectedItem) {
                          setState(() {
                            selectedIndexPrioridade =
                                priori.indexOf(selectedItem);
                          });
                        },
                      ),
                    ),
                    Spc(width: 8),
                    Expanded(
                      child: FormSelect(
                        labeltext: 'Etiqueta',
                        items: tags,
                        initialValue: selectedIndexEtiqueta,
                        onSelect: (selectedItem) {
                          setState(() {
                            selectedIndexEtiqueta = tags.indexOf(selectedItem);
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveFormData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? userId = user?.uid;

    try {
      final CollectionReference tasksCollection =
          FirebaseFirestore.instance.collection('tasks');

      if (widget.taskId != null) {
        final taskDoc = tasksCollection.doc(widget.taskId);
        final taskData = {
          'nome': nomeController.text,
          'descricao': description.text,
          'prioridade': priori[selectedIndexPrioridade],
          'etiqueta': tags[selectedIndexEtiqueta],
        };
        await taskDoc.update(taskData);
      } else {
        final newTaskDoc = tasksCollection.doc();
        final taskData = {
          'userId': userId,
          'nome': nomeController.text,
          'descricao': description.text,
          'prioridade': priori[selectedIndexPrioridade],
          'etiqueta': tags[selectedIndexEtiqueta],
          'isDone': false,
        };
        await newTaskDoc.set(taskData);
      }

      _showToast('Dados salvos no Firestore com sucesso!');
      Navigator.pop(context);
    } catch (error) {
      _showToast('Erro ao salvar os dados');
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
}
