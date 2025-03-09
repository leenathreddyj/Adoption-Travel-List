import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/plan.dart';

class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({super.key}); // Fixed by using super parameter

  @override
  PlanManagerScreenState createState() => PlanManagerScreenState();
}

class PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, List<Plan>> _events = {};

  void addPlan(String name, String description, DateTime date, String category, String priority) {
    setState(() {
      Plan newPlan = Plan(name: name, description: description, date: date, category: category, priority: priority);
      plans.add(newPlan);
      plans.sort((a, b) => b.priority.compareTo(a.priority));
      _events.putIfAbsent(date, () => []).add(newPlan);
    });
  }

  void updatePlan(int index, String name, String description, String priority) {
    setState(() {
      plans[index].name = name;
      plans[index].description = description;
      plans[index].priority = priority;
      plans.sort((a, b) => b.priority.compareTo(a.priority));
    });
  }

  void markCompleted(int index) {
    setState(() {
      plans[index].isCompleted = !plans[index].isCompleted;
    });
  }

  void deletePlan(int index) {
    setState(() {
      _events[plans[index].date]?.remove(plans[index]);
      plans.removeAt(index);
    });
  }

  void showCreatePlanDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String selectedCategory = 'Adoption';
    String selectedPriority = 'Medium';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Plan Name')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              DropdownButton<String>(
                value: selectedCategory,
                items: ['Adoption', 'Travel'].map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (value) => setState(() => selectedCategory = value!),
              ),
              DropdownButton<String>(
                value: selectedPriority,
                items: ['Low', 'Medium', 'High'].map((priority) => DropdownMenuItem(value: priority, child: Text(priority))).toList(),
                onChanged: (value) => setState(() => selectedPriority = value!),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                addPlan(nameController.text, descriptionController.text, _selectedDate, selectedCategory, selectedPriority);
                Navigator.pop(context);
              },
              child: const Text('Add Plan'),
            ),
          ],
        );
      },
    );
  }

  Widget buildPlanList() {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];

        return GestureDetector(
          onDoubleTap: () => deletePlan(index),
          onLongPress: () => showCreatePlanDialog(),
          child: Slidable(
            key: Key(plan.name),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => markCompleted(index),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.check,
                  label: 'Complete',
                ),
              ],
            ),
            child: ListTile(
              title: Text(plan.name, style: TextStyle(decoration: plan.isCompleted ? TextDecoration.lineThrough : TextDecoration.none)),
              subtitle: Text(plan.description),
              trailing: Text(plan.priority, style: TextStyle(color: plan.priority == 'High' ? Colors.red : (plan.priority == 'Medium' ? Colors.orange : Colors.green))),
              tileColor: plan.isCompleted ? Colors.greenAccent : Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget buildCalendar() {
    return TableCalendar(
      focusedDay: _selectedDate,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      calendarFormat: CalendarFormat.month,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDate = selectedDay;
        });
        showCreatePlanDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adoption & Travel Plans')),
      body: Column(
        children: [
          buildCalendar(),
          Expanded(child: buildPlanList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreatePlanDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
