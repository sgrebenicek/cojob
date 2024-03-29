import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cojob/api_service.dart';
import 'package:cojob/secure_storage.dart';
import 'package:cojob/widgets/bottom_navbar.dart';
import 'package:cojob/pages/login_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  final SecureStorage _secureStorage = SecureStorage();
  final APIService _apiService = APIService();
  List<dynamic> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    _checkLoginStatus();
    _firstDay = DateTime.utc(2020, 1, 1);
    _lastDay = DateTime.utc(2030, 1, 1);
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  void _fetchTasks() async {
    try {
      List? tasks = await _apiService.fetchTasks();
      setState(() {
        _tasks = tasks!;
      });
    } catch (e) {}
  }

  List<Widget> _tasksForSelectedDay() {
    return _tasks
        .where((task) =>
            isSameDay(DateTime.parse(task['timestamp']), _selectedDay))
        .map((task) {
      bool isDone = task['isDone'] == 1;
      return ListTile(
        title: Text(
          task['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(task['description']),
        trailing: IconButton(
          icon: Icon(isDone ? Icons.check : Icons.close),
          color: isDone ? Colors.green : Colors.red,
          onPressed: () {
            setState(() {
              task['isDone'] = isDone ? 0 : 1;
            });
            _updateTaskStatus(task['id'].toString(), !isDone);
          },
        ),
      );
    }).toList();
  }

  Future<void> _updateTaskStatus(String taskId, bool isDone) async {
    await _apiService.updateTaskStatus(taskId, isDone);
    _fetchTasks();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await _secureStorage.getToken();
    if (token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController descriptionController =
            TextEditingController();
        bool isDone = false;
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text('Add Task'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  String timestamp =
                      _selectedDay.toIso8601String().split('T').first;
                  bool success = await _apiService.addTask(
                    nameController.text,
                    descriptionController.text,
                    isDone,
                    timestamp,
                  );
                  if (success) {
                    Navigator.of(context).pop();
                    _fetchTasks();
                  } else {}
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                shape: BoxShape.rectangle,
              ),
              selectedDecoration: BoxDecoration(
                color: colorScheme.inversePrimary,
                shape: BoxShape.rectangle,
              ),
              defaultTextStyle: const TextStyle(fontSize: 16),
              weekendTextStyle:
                  TextStyle(color: colorScheme.primary, fontSize: 16),
              selectedTextStyle: const TextStyle(fontSize: 16),
              todayTextStyle: const TextStyle(fontSize: 16),
              outsideTextStyle:
                  TextStyle(color: colorScheme.surfaceVariant, fontSize: 16),
            ),
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
          ),
          Expanded(
            child: ListView(
              children: _tasksForSelectedDay(),
            ),
          ),
        ],
      ),
    );
  }
}
