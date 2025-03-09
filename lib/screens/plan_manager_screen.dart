import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/plan.dart';

class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({super.key});

  @override
  PlanManagerScreenState createState() => PlanManagerScreenState();
}

class PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];
  DateTime _selectedDate = DateTime.now();

  void addPlan(String name, String description, String category, String priority) {
    setState(() {
      plans.add(Plan(name: name, description: description, date: _selectedDate, category: category, priority: priority));
    });
  }

  void editPlan(int index) {
    TextEditingController nameController = TextEditingController(text: plans[index].name);
    TextEditingController descriptionController = TextEditingController(text: plans[index].description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Plan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Plan Name')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  plans[index].name = nameController.text;
                  plans[index].description = descriptionController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Update"),
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
          onDoubleTap: () {
            setState(() {
              plans.removeAt(index);
            });
          },
          onLongPress: () => editPlan(index),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Slidable(
              key: Key(plan.name),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => setState(() => plan.isCompleted = !plan.isCompleted),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: Icons.check,
                    label: 'Complete',
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Icon(
                  plan.priority == 'High' ? Icons.warning_amber_rounded : plan.priority == 'Medium' ? Icons.priority_high : Icons.low_priority,
                  color: plan.priority == 'High' ? Colors.red : (plan.priority == 'Medium' ? Colors.orange : Colors.green),
                ),
                title: Text(plan.name, style: TextStyle(decoration: plan.isCompleted ? TextDecoration.lineThrough : TextDecoration.none, fontWeight: FontWeight.bold)),
                subtitle: Text(plan.description),
                tileColor: plan.isCompleted ? Colors.green[100] : Colors.white,
                trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
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

  void showCreatePlanDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String selectedCategory = 'Adoption';
    String selectedPriority = 'Medium';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Plan"),
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
                addPlan(nameController.text, descriptionController.text, selectedCategory, selectedPriority);
                Navigator.pop(context);
              },
              child: const Text("Add Plan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) { // FIX: Ensure this method exists
    return Scaffold(
      appBar: AppBar(title: const Text('Adoption & Travel Plans')),
      body: Column(children: [buildCalendar(), Expanded(child: buildPlanList())]),
      floatingActionButton: FloatingActionButton(onPressed: showCreatePlanDialog, child: const Icon(Icons.add)),
    );
  }
}
