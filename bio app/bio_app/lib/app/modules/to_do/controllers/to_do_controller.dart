import 'package:bio_app/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ToDoItem {
  String id;
  String title;
  bool isCompleted;
  DateTime createdAt;

  ToDoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });
}

class ToDoController extends GetxController {
  final RxList<ToDoItem> todoItems = <ToDoItem>[].obs;
  final RxString newTodoTitle = ''.obs;
  final RxBool isLoading = false.obs;

  final box = GetStorage();
  final String storageKey = 'todo_list';

  // Get reference to HomeController
  HomeController get homeController => Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
    updateHomeStats();
  }

  void addTodo(String title) {
    if (title.trim().isNotEmpty) {
      final newTodo = ToDoItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        createdAt: DateTime.now(),
      );
      todoItems.add(newTodo);
      saveTodos();
      newTodoTitle.value = '';
      updateHomeStats();

      Get.snackbar(
        'Task Added',
        'Task "${title.trim()}" added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void toggleTodo(String id) {
    final index = todoItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final wasCompleted = todoItems[index].isCompleted;
      todoItems[index].isCompleted = !wasCompleted;
      todoItems.refresh();
      saveTodos();
      updateHomeStats();

      if (!wasCompleted) {
        Get.snackbar(
          'Great Job!',
          'Task completed! 🎉',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  void deleteTodo(String id) {
    final todoToDelete = todoItems.firstWhereOrNull((item) => item.id == id);

    if (todoToDelete != null) {
      todoItems.removeWhere((item) => item.id == id);
      saveTodos();
      updateHomeStats();

      Get.snackbar(
        'Task Deleted',
        'Task "${todoToDelete.title}" deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Not Found',
        'Task not found or already deleted.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void updateTodoTitle(String id, String newTitle) {
    final index = todoItems.indexWhere((item) => item.id == id);
    if (index != -1 && newTitle.trim().isNotEmpty) {
      todoItems[index].title = newTitle.trim();
      todoItems.refresh();
      saveTodos();
      updateHomeStats();
    }
  }

  void clearCompleted() {
    final completedCount = completedTodos;
    todoItems.removeWhere((item) => item.isCompleted);
    saveTodos();
    updateHomeStats();

    Get.snackbar(
      'Tasks Cleared',
      '$completedCount completed task${completedCount > 1 ? 's' : ''} cleared!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void saveTodos() {
    final jsonList = todoItems.map((item) => {
          'id': item.id,
          'title': item.title,
          'isCompleted': item.isCompleted,
          'createdAt': item.createdAt.toIso8601String(),
        }).toList();
    box.write(storageKey, jsonList);
  }
  void loadTodos() {
    final List<dynamic>? jsonList = box.read(storageKey);
    if (jsonList != null) {
      final loadedItems = jsonList.map((json) {
        return ToDoItem(
          id: json['id'],
          title: json['title'],
          isCompleted: json['isCompleted'],
          createdAt: DateTime.parse(json['createdAt']),
        );
      }).toList();

      todoItems.assignAll(loadedItems);
    }
  }

  void updateHomeStats() {
    try {
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(Duration(days: 1));

      final todayTasksCount = todoItems.where((item) =>
          item.createdAt.isAfter(todayStart) &&
          item.createdAt.isBefore(todayEnd)).length;

      homeController.todayTasks.value = todayTasksCount;
      homeController.completedTasks.value = completedTodos;
      homeController.pendingTasks.value = pendingTodos;
      homeController.totalTasks.value = totalTodos;
    } catch (e) {
      print('Error updating home stats: $e');
    }
  }

  // Getters
  int get totalTodos => todoItems.length;
  int get completedTodos =>
      todoItems.where((item) => item.isCompleted).length;
  int get pendingTodos =>
      todoItems.where((item) => !item.isCompleted).length;

  List<ToDoItem> get pendingTodoItems =>
      todoItems.where((item) => !item.isCompleted).toList();
  List<ToDoItem> get completedTodoItems =>
      todoItems.where((item) => item.isCompleted).toList();

  List<ToDoItem> get todayPendingTasks {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(Duration(days: 1));

    return todoItems.where((item) =>
        !item.isCompleted &&
        item.createdAt.isAfter(todayStart) &&
        item.createdAt.isBefore(todayEnd)).toList();
  }

  List<ToDoItem> get todayCompletedTasks {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(Duration(days: 1));

    return todoItems.where((item) =>
        item.isCompleted &&
        item.createdAt.isAfter(todayStart) &&
        item.createdAt.isBefore(todayEnd)).toList();
  }
}
