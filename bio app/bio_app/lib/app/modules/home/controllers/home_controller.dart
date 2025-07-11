import 'package:bio_app/app/modules/to_do/controllers/to_do_controller.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:get_storage/get_storage.dart';


class HomeController extends GetxController {
  // User information
  final RxString userName = 'Nadhif'.obs;
  final RxString currentDate = ''.obs;
  final RxString currentTime = ''.obs;
  
  // Task statistics - these will be updated by ToDoController
  final RxInt todayTasks = 0.obs;
  final RxInt completedTasks = 0.obs;
  final RxInt pendingTasks = 0.obs;
  final RxInt totalTasks = 0.obs;
  
  // Daily quotes
  final RxString dailyQuote = 'Orang pemberani akan memperlihatkan keberaniannya dan orang pemalu akan memperlihatkan kemaluannya.'.obs;
  final RxString quoteAuthor = 'Wisdom of the Day'.obs;
  
  // Navigation tracking
  final RxString currentGreeting = 'Welcome Back!'.obs;
  
  // Random generator instance
  final Random _random = Random();
  
  // List of inspirational quotes
  final List<Map<String, String>> quotes = [
    {
      'quote': 'Orang pemberani akan memperlihatkan keberaniannya dan orang pemalu akan memperlihatkan kemaluannya.',
      'author': 'Wisdom of the Day'
    },
    {
      'quote': 'Kesuksesan adalah kemampuan untuk berpindah dari satu kegagalan ke kegagalan lain tanpa kehilangan semangat.',
      'author': 'Winston Churchill'
    },
    {
      'quote': 'Cara terbaik untuk memulai adalah berhenti berbicara dan mulai melakukan.',
      'author': 'Walt Disney'
    },
    {
      'quote': 'Inovasi membedakan antara pemimpin dan pengikut.',
      'author': 'Steve Jobs'
    },
    {
      'quote': 'Must be the water.',
      'author': 'Unknown'
    },
    {
      'quote': 'Hidup ini seperti mengendarai sepeda. Untuk menjaga keseimbangan, kamu harus terus bergerak.',
      'author': 'Albert Einstein'
    },
    {
      'quote': 'Jangan takut gagal. Takutlah tidak mencoba.',
      'author': 'Michael Jordan'
    },
    {
      'quote': 'Masa depan milik mereka yang percaya pada keindahan mimpi mereka.',
      'author': 'Eleanor Roosevelt'
    },
  ];

  @override
  void onInit() {
    super.onInit();
    initializeData();
    updateDateTime();
    setupPeriodicUpdates();
  }

  @override
  void onReady() {
    super.onReady();
    updateGreeting();
    // Initialize stats with default values if ToDoController is not ready
    initializeDefaultStats();
  }

  // Initialize default stats
  void initializeDefaultStats() {
    // Only set default values if stats are still 0
    if (totalTasks.value == 0) {
      todayTasks.value = 0;
      completedTasks.value = 0;
      pendingTasks.value = 0;
      totalTasks.value = 0;
    }
  }

  // Initialize app data
  void initializeData() {
    updateDateTime();
    setRandomQuote();
  }

  // Update current date and time
  void updateDateTime() {
    final now = DateTime.now();
    currentDate.value = formatDate(now);
    currentTime.value = formatTime(now);
  }

  // Format date for display
  String formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Format time for display
  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Update greeting based on time of day
  void updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      currentGreeting.value = 'Good Morning!';
    } else if (hour < 17) {
      currentGreeting.value = 'Good Afternoon!';
    } else {
      currentGreeting.value = 'Good Evening!';
    }
  }

  // Set random daily quote - Now truly random every time
  void setRandomQuote() {
    final randomIndex = _random.nextInt(quotes.length);
    final selectedQuote = quotes[randomIndex];
    dailyQuote.value = selectedQuote['quote']!;
    quoteAuthor.value = selectedQuote['author']!;
  }

  // Method to manually change quote
  void changeQuote() {
    setRandomQuote();
  }

  // Setup periodic updates (every minute)
  void setupPeriodicUpdates() {
    // Update time every minute
    Stream.periodic(const Duration(minutes: 1), (i) => i)
        .listen((value) => updateDateTime());
    
    // Update greeting every hour
    Stream.periodic(const Duration(hours: 1), (i) => i)
        .listen((value) => updateGreeting());
  }

  // Navigation methods
  void navigateToProfile() {
    Get.toNamed('/profile-screen');
  }

  void navigateToTodo() {
    Get.toNamed('/to-do');
  }

  // Task management methods - Now these will be called by ToDoController
  void updateTaskStats({
    required int today,
    required int completed,
    required int pending,
    required int total,
  }) {
    todayTasks.value = today;
    completedTasks.value = completed;
    pendingTasks.value = pending;
    totalTasks.value = total;
  }

  // Sync with ToDoController if available
  void syncWithToDoController() {
    try {
      // Try to get ToDoController and sync stats
      final todoController = Get.find<ToDoController>();
      
      // Calculate today's tasks
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(Duration(days: 1));
      
      final todayTasksCount = todoController.todoItems.where((item) => 
        item.createdAt.isAfter(todayStart) && 
        item.createdAt.isBefore(todayEnd)
      ).length;
      
      // Update stats
      todayTasks.value = todayTasksCount;
      completedTasks.value = todoController.completedTodos;
      pendingTasks.value = todoController.pendingTodos;
      totalTasks.value = todoController.totalTodos;
      
    } catch (e) {
      // ToDoController not available, use default stats
      print('ToDoController not available for sync: $e');
    }
  }

  // Utility methods
  String get formattedUserName => userName.value.isNotEmpty ? userName.value : 'User';
  
  String get welcomeMessage => '${currentGreeting.value}\nHave a great day, $formattedUserName!';
  
  String get dateTimeString => '${currentDate.value} • ${currentTime.value}';
  
  // Get completion percentage
  double get completionPercentage {
    if (totalTasks.value == 0) return 0.0;
    return (completedTasks.value / totalTasks.value) * 100;
  }
  
  // Get productivity status
  String get productivityStatus {
    final percentage = completionPercentage;
    if (percentage >= 80) return 'Excellent!';
    if (percentage >= 60) return 'Good Progress';
    if (percentage >= 40) return 'Keep Going';
    return 'Let\'s Start!';
  }

  // Action methods for quick actions
  void onProfileTap() {
    navigateToProfile();
  }

  void onTodoTap() {
    navigateToTodo();
  }

  // Refresh all data - Now also syncs with ToDoController
  void refreshAllData() {
    updateDateTime();
    updateGreeting();
    setRandomQuote();
    syncWithToDoController(); // Sync with ToDoController
    
    Get.snackbar(
      'Refreshed',
      'All data has been updated!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Add task quickly from home screen (this would navigate to todo page)
  void addQuickTask(String title) {
    if (title.trim().isNotEmpty) {
      // Navigate to todo page instead of creating task here
      Get.toNamed('/to-do');
      
      Get.snackbar(
        'Navigate to Tasks',
        'Opening task manager to add your task!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Mark task as completed (this would interact with ToDoController)
  void markTaskCompleted() {
    try {
      final todoController = Get.find<ToDoController>();
      final firstPendingTask = todoController.pendingTodoItems.first;
      todoController.toggleTodo(firstPendingTask.id);
    } catch (e) {
      Get.snackbar(
        'No Tasks',
        'No pending tasks to complete!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Method to be called when app resumes or comes back to home
  void onResumed() {
    syncWithToDoController();
    updateDateTime();
    updateGreeting();
  }
}