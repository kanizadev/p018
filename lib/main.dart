import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const CrosswordApp());
}

class CrosswordApp extends StatefulWidget {
  const CrosswordApp({super.key});

  @override
  State<CrosswordApp> createState() => _CrosswordAppState();
}

class _CrosswordAppState extends State<CrosswordApp> {
  bool _nightMode = false;

  @override
  void initState() {
    super.initState();
    _loadNightMode();
  }

  Future<void> _loadNightMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nightMode = prefs.getBool('night_mode') ?? false;
    });
  }

  void toggleNightMode(bool value) {
    setState(() {
      _nightMode = value;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('night_mode', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Crossword',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF87A96B),
              brightness: Brightness.light,
            ).copyWith(
              primary: const Color(0xFF87A96B),
              secondary: const Color(0xFF9CAF88),
              surface: const Color(0xFFF5F7F3),
              surfaceContainerHighest: const Color(0xFFF5F7F3),
            ),
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoTextTheme(),
        fontFamily: GoogleFonts.nunito().fontFamily,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF87A96B), width: 2),
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 4,
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF2D3A2A),
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3A2A),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF87A96B),
          selectionColor: Color(0xFF87A96B),
          selectionHandleColor: Color(0xFF87A96B),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF87A96B),
              brightness: Brightness.dark,
            ).copyWith(
              primary: const Color(0xFF9CAF88),
              secondary: const Color(0xFFB8D4A6),
              surface: const Color(0xFF2D3A2A),
              surfaceContainerHighest: const Color(0xFF1E251D),
              onSurface: const Color(0xFFF5F7F3),
            ),
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
        fontFamily: GoogleFonts.nunito().fontFamily,
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF2D3A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade700, width: 1),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2D3A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF9CAF88), width: 2),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 4,
          backgroundColor: Color(0xFF2D3A2A),
          foregroundColor: Color(0xFFF5F7F3),
        ),
        scaffoldBackgroundColor: const Color(0xFF1E251D),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF9CAF88),
          selectionColor: Color(0xFF9CAF88),
          selectionHandleColor: Color(0xFF9CAF88),
        ),
      ),
      themeMode: _nightMode ? ThemeMode.dark : ThemeMode.light,
      home: LevelSelectionScreen(
        onNightModeChanged: toggleNightMode,
        nightMode: _nightMode,
      ),
    );
  }
}

enum Difficulty { easy, medium, hard }

class Entry {
  final String id;
  final String direction; // 'A' or 'D'
  final String clue;
  final String answer;
  final int row;
  final int col;

  Entry({
    required this.id,
    required this.direction,
    required this.clue,
    required this.answer,
    required this.row,
    required this.col,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'direction': direction,
    'clue': clue,
    'answer': answer,
    'row': row,
    'col': col,
  };

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    id: json['id'],
    direction: json['direction'],
    clue: json['clue'],
    answer: json['answer'],
    row: json['row'],
    col: json['col'],
  );
}

class Puzzle {
  final int rows;
  final int cols;
  final List<Entry> entries;
  final String title;

  Puzzle({
    required this.title,
    required this.rows,
    required this.cols,
    required this.entries,
  });

  factory Puzzle.fromJson(Map<String, dynamic> json) => Puzzle(
    title: json['title'],
    rows: json['rows'],
    cols: json['cols'],
    entries: (json['entries'] as List).map((e) => Entry.fromJson(e)).toList(),
  );
}

class GameStats {
  int totalCompletions = 0;
  int totalTime = 0;
  int currentStreak = 0;
  int bestStreak = 0;
  DateTime? lastPlayed;
  Map<String, int> completionsByDifficulty = {};
  Map<String, int> averageTimeByDifficulty = {};
  List<int> recentTimes = [];
  int perfectCompletions = 0;
  int hintsUsedTotal = 0;

  GameStats();

  Map<String, dynamic> toJson() => {
    'totalCompletions': totalCompletions,
    'totalTime': totalTime,
    'currentStreak': currentStreak,
    'bestStreak': bestStreak,
    'lastPlayed': lastPlayed?.toIso8601String(),
    'completionsByDifficulty': completionsByDifficulty,
    'averageTimeByDifficulty': averageTimeByDifficulty,
    'recentTimes': recentTimes,
    'perfectCompletions': perfectCompletions,
    'hintsUsedTotal': hintsUsedTotal,
  };

  factory GameStats.fromJson(Map<String, dynamic> json) {
    final stats = GameStats();
    stats.totalCompletions = json['totalCompletions'] ?? 0;
    stats.totalTime = json['totalTime'] ?? 0;
    stats.currentStreak = json['currentStreak'] ?? 0;
    stats.bestStreak = json['bestStreak'] ?? 0;
    stats.lastPlayed = json['lastPlayed'] != null
        ? DateTime.parse(json['lastPlayed'])
        : null;
    stats.completionsByDifficulty = Map<String, int>.from(
      json['completionsByDifficulty'] ?? {},
    );
    stats.averageTimeByDifficulty = Map<String, int>.from(
      json['averageTimeByDifficulty'] ?? {},
    );
    stats.recentTimes = List<int>.from(json['recentTimes'] ?? []);
    stats.perfectCompletions = json['perfectCompletions'] ?? 0;
    stats.hintsUsedTotal = json['hintsUsedTotal'] ?? 0;
    return stats;
  }
}

class DailyChallenge {
  final DateTime date;
  final String puzzleKey;
  final bool completed;
  final int? completionTime;
  final int stars;

  DailyChallenge({
    required this.date,
    required this.puzzleKey,
    this.completed = false,
    this.completionTime,
    this.stars = 0,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'puzzleKey': puzzleKey,
    'completed': completed,
    'completionTime': completionTime,
    'stars': stars,
  };

  factory DailyChallenge.fromJson(Map<String, dynamic> json) => DailyChallenge(
    date: DateTime.parse(json['date']),
    puzzleKey: json['puzzleKey'],
    completed: json['completed'] ?? false,
    completionTime: json['completionTime'],
    stars: json['stars'] ?? 0,
  );
}

class HighScore {
  final Difficulty difficulty;
  final int time;
  final DateTime timestamp;

  HighScore({
    required this.difficulty,
    required this.time,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'difficulty': difficulty.name,
    'time': time,
    'timestamp': timestamp.toIso8601String(),
  };

  factory HighScore.fromJson(Map<String, dynamic> json) => HighScore(
    difficulty: Difficulty.values.firstWhere(
      (d) => d.name == json['difficulty'],
    ),
    time: json['time'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class PuzzleLoader {
  static Future<Map<String, List<Puzzle>>> loadPuzzles() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/puzzles.json',
      );
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final Map<String, List<Puzzle>> puzzles = {};

      for (final difficulty in ['easy', 'medium', 'hard']) {
        puzzles[difficulty] = (jsonData[difficulty] as List)
            .map((p) => Puzzle.fromJson(p))
            .toList();
      }

      return puzzles;
    } catch (e) {
      // Fallback to empty puzzles if loading fails
      return {'easy': [], 'medium': [], 'hard': []};
    }
  }
}

class AdvancedStatsScreen extends StatelessWidget {
  final GameStats stats;

  const AdvancedStatsScreen({super.key, required this.stats});

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return mins > 0 ? '${mins}m ${secs}s' : '${secs}s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avgTime = stats.totalCompletions > 0
        ? stats.totalTime ~/ stats.totalCompletions
        : 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Advanced Statistics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overall Stats Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF87A96B), Color(0xFF9CAF88)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.analytics,
                          color: Color(0xFFF5F7F3),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Overall Statistics',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildStatItem(
                    Icons.check_circle,
                    'Total Completions',
                    '${stats.totalCompletions}',
                    const Color(0xFF87A96B),
                  ),
                  const Divider(height: 24),
                  _buildStatItem(
                    Icons.timer,
                    'Average Time',
                    avgTime > 0 ? _formatTime(avgTime) : '--',
                    const Color(0xFF87A96B),
                  ),
                  const Divider(height: 24),
                  _buildStatItem(
                    Icons.local_fire_department,
                    'Current Streak',
                    '${stats.currentStreak} days',
                    const Color(0xFF9CAF88),
                  ),
                  const Divider(height: 24),
                  _buildStatItem(
                    Icons.emoji_events,
                    'Best Streak',
                    '${stats.bestStreak} days',
                    const Color(0xFFB8D4A6),
                  ),
                  const Divider(height: 24),
                  _buildStatItem(
                    Icons.star,
                    'Perfect Completions',
                    '${stats.perfectCompletions}',
                    const Color(0xFF9CAF88),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Difficulty Breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9CAF88), Color(0xFF87A96B)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.pie_chart,
                          color: Color(0xFFF5F7F3),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'By Difficulty',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ...Difficulty.values.map((d) {
                    final completions =
                        stats.completionsByDifficulty[d.name] ?? 0;
                    final avgTime = stats.averageTimeByDifficulty[d.name] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                d.name.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$completions puzzles',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF9CAF88),
                                ),
                              ),
                            ],
                          ),
                          if (avgTime > 0) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Avg: ${_formatTime(avgTime)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color(0xFF9CAF88),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recent Performance
          if (stats.recentTimes.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF87A96B), Color(0xFF6B8E4E)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.trending_up,
                            color: Color(0xFFF5F7F3),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Recent Performance',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ...stats.recentTimes.reversed.take(5).map((time) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: const Color(0xFF87A96B),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _formatTime(time),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class HighScoreScreen extends StatelessWidget {
  final Map<String, int> bestTimes;
  final List<HighScore> allScores;

  const HighScoreScreen({
    super.key,
    required this.bestTimes,
    required this.allScores,
  });

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return mins > 0 ? '${mins}m ${secs}s' : '${secs}s';
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'High Scores',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best Times',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...Difficulty.values.map(
                    (d) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            d.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            bestTimes[d.name] == 0
                                ? '--'
                                : _formatTime(bestTimes[d.name]!),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? const Color(0xFF9CAF88)
                                  : const Color(0xFF87A96B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (allScores.isNotEmpty) ...[
            Text(
              'Recent Scores',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            ...allScores
                .take(10)
                .map(
                  (score) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getDifficultyColor(score.difficulty),
                        child: Text(
                          score.difficulty.name[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        _formatTime(score.time),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${score.difficulty.name.toUpperCase()} • ${_formatDate(score.timestamp)}',
                      ),
                      trailing: Icon(
                        Icons.emoji_events,
                        color: const Color(0xFF87A96B),
                      ),
                    ),
                  ),
                ),
          ] else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'No scores yet. Complete a puzzle to see your scores!',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(Difficulty d) {
    switch (d) {
      case Difficulty.easy:
        return const Color(0xFF87A96B);
      case Difficulty.medium:
        return const Color(0xFF9CAF88);
      case Difficulty.hard:
        return const Color(0xFF6B8E4E);
    }
  }
}

class PuzzleProgress {
  final String puzzleKey;
  final bool completed;
  final int? completionTime;
  final DateTime? completedAt;
  final int hintsUsed;
  final int cellsFilled;

  PuzzleProgress({
    required this.puzzleKey,
    this.completed = false,
    this.completionTime,
    this.completedAt,
    this.hintsUsed = 0,
    this.cellsFilled = 0,
  });

  Map<String, dynamic> toJson() => {
    'puzzleKey': puzzleKey,
    'completed': completed,
    'completionTime': completionTime,
    'completedAt': completedAt?.toIso8601String(),
    'hintsUsed': hintsUsed,
    'cellsFilled': cellsFilled,
  };

  factory PuzzleProgress.fromJson(Map<String, dynamic> json) => PuzzleProgress(
    puzzleKey: json['puzzleKey'],
    completed: json['completed'] ?? false,
    completionTime: json['completionTime'],
    completedAt: json['completedAt'] != null
        ? DateTime.parse(json['completedAt'])
        : null,
    hintsUsed: json['hintsUsed'] ?? 0,
    cellsFilled: json['cellsFilled'] ?? 0,
  );
}

class LevelSelectionScreen extends StatefulWidget {
  final Function(bool)? onNightModeChanged;
  final bool nightMode;

  const LevelSelectionScreen({
    super.key,
    this.onNightModeChanged,
    this.nightMode = false,
  });

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final Map<String, int> _puzzleCounts = {'easy': 0, 'medium': 0, 'hard': 0};
  final Map<String, int> _completedCounts = {'easy': 0, 'medium': 0, 'hard': 0};
  bool _isLoading = true;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    try {
      final puzzles = await PuzzleLoader.loadPuzzles();
      setState(() {
        _puzzleCounts['easy'] = puzzles['easy']?.length ?? 0;
        _puzzleCounts['medium'] = puzzles['medium']?.length ?? 0;
        _puzzleCounts['hard'] = puzzles['hard']?.length ?? 0;

        // Load completed puzzles
        _completedCounts['easy'] =
            _prefs?.getStringList('completed_easy')?.length ?? 0;
        _completedCounts['medium'] =
            _prefs?.getStringList('completed_medium')?.length ?? 0;
        _completedCounts['hard'] =
            _prefs?.getStringList('completed_hard')?.length ?? 0;

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Choose level',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF3A4A3A), const Color(0xFF2D3A2A)]
                    : [
                        const Color(0xFF87A96B).withValues(alpha: 0.15),
                        const Color(0xFF9CAF88).withValues(alpha: 0.1),
                      ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF87A96B).withValues(alpha: 0.4)
                    : const Color(0xFF87A96B).withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF87A96B,
                  ).withValues(alpha: isDark ? 0.2 : 0.15),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  widget.onNightModeChanged?.call(!widget.nightMode);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: isDark
                        ? const Color(0xFF9CAF88)
                        : const Color(0xFF87A96B),
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDifficultyCard(
                    context,
                    'Easy',
                    'Easy vocabulary',
                    const Color(0xFFF5F7F3),
                    const Color(0xFF9CAF88),
                    Difficulty.easy,
                    _puzzleCounts['easy'] ?? 0,
                  ),
                  const SizedBox(height: 16),
                  _buildDifficultyCard(
                    context,
                    'Normal',
                    'Normal Vocabulary',
                    const Color(0xFFE8EDE3),
                    const Color(0xFF9CAF88),
                    Difficulty.medium,
                    _puzzleCounts['medium'] ?? 0,
                  ),
                  const SizedBox(height: 16),
                  _buildDifficultyCard(
                    context,
                    'Difficult',
                    'Difficult Vocabulary',
                    const Color(0xFFF5F7F3),
                    const Color(0xFF9CAF88),
                    Difficulty.hard,
                    _puzzleCounts['hard'] ?? 0,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDifficultyCard(
    BuildContext context,
    String title,
    String subtitle,
    Color backgroundColor,
    Color borderColor,
    Difficulty difficulty,
    int puzzleCount,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final completedCount = _completedCounts[difficulty.name] ?? 0;
    final progress = puzzleCount > 0 ? completedCount / puzzleCount : 0.0;
    final isComplete = completedCount == puzzleCount && puzzleCount > 0;

    final cardBgColor = isDark
        ? (difficulty == Difficulty.easy
              ? const Color(0xFF2D3A2A)
              : difficulty == Difficulty.medium
              ? const Color(0xFF2D3A2A)
              : const Color(0xFF2D3A2A))
        : backgroundColor;

    final cardBorderColor = isDark
        ? (isComplete ? const Color(0xFF87A96B) : const Color(0xFF3A4A3A))
        : (isComplete ? const Color(0xFF87A96B) : borderColor);

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        border: Border.all(
          color: cardBorderColor,
          width: isComplete ? 2.5 : 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isComplete
                ? const Color(0xFF87A96B).withAlpha(isDark ? 60 : 40)
                : Colors.black.withAlpha(isDark ? 40 : 15),
            blurRadius: isComplete ? 16 : 12,
            offset: const Offset(0, 4),
            spreadRadius: isComplete ? 1 : 0.5,
          ),
          if (isComplete)
            BoxShadow(
              color: const Color(0xFF87A96B).withAlpha(20),
              blurRadius: 20,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PuzzleSelectionScreen(difficulty: difficulty),
              ),
            ).then((_) => _loadData());
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          if (isComplete) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF87A96B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Color(0xFFF5F7F3),
                                size: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFF9CAF88)
                              : const Color(0xFF6B8E4E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [
                                        const Color(0xFF6B8E4E),
                                        const Color(0xFF87A96B),
                                      ]
                                    : [
                                        const Color(0xFF9CAF88),
                                        const Color(0xFFB8D4A6),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$puzzleCount puzzles',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? const Color(0xFFB8D4A6)
                                    : const Color(0xFF2D3A2A),
                              ),
                            ),
                          ),
                          if (completedCount > 0) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF87A96B),
                                    Color(0xFF6B8E4E),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFFF5F7F3),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$completedCount',
                                    style: const TextStyle(
                                      color: Color(0xFFF5F7F3),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (puzzleCount > 0) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFE8EDE3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress == 1.0
                                  ? const Color(0xFF87A96B)
                                  : const Color(0xFF87A96B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(progress * 100).toInt()}% Complete',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF9CAF88)
                                : const Color(0xFF6B8E4E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _buildMiniGrid(difficulty),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniGrid(Difficulty difficulty) {
    final size = 5;
    final cellSize = 8.0;
    final cells = <Widget>[];

    // Create a simple pattern based on difficulty
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        bool isBlocked = false;
        Color? highlightColor;

        if (difficulty == Difficulty.easy) {
          // Simple pattern for easy
          isBlocked = (r + c) % 3 == 0;
        } else if (difficulty == Difficulty.medium) {
          // Medium pattern
          isBlocked = (r + c) % 2 == 0;
          if (r == 2 && c == 2) {
            highlightColor = const Color(0xFF9CAF88);
          }
        } else {
          // Complex pattern for hard
          isBlocked = (r + c) % 2 == 1 || (r == c);
          if ((r == 1 && c == 1) || (r == 3 && c == 3)) {
            highlightColor = const Color(0xFFB8D4A6);
          }
        }

        cells.add(
          Container(
            width: cellSize,
            height: cellSize,
            margin: const EdgeInsets.all(0.5),
            decoration: BoxDecoration(
              color:
                  highlightColor ??
                  (isBlocked
                      ? const Color(0xFF2D3A2A)
                      : const Color(0xFFF5F7F3)),
              border: Border.all(color: const Color(0xFF9CAF88), width: 0.5),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDE3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: cellSize * size + size,
        height: cellSize * size + size,
        child: Wrap(children: cells),
      ),
    );
  }
}

class PuzzleSelectionScreen extends StatefulWidget {
  final Difficulty difficulty;

  const PuzzleSelectionScreen({super.key, required this.difficulty});

  @override
  State<PuzzleSelectionScreen> createState() => _PuzzleSelectionScreenState();
}

class _PuzzleSelectionScreenState extends State<PuzzleSelectionScreen> {
  List<Puzzle> _puzzles = [];
  Set<String> _completedPuzzles = {};
  bool _isLoading = true;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadPuzzles();
  }

  Future<void> _loadPuzzles() async {
    _prefs = await SharedPreferences.getInstance();
    try {
      final puzzles = await PuzzleLoader.loadPuzzles();
      setState(() {
        _puzzles = puzzles[widget.difficulty.name] ?? [];
        final completedList =
            _prefs?.getStringList('completed_${widget.difficulty.name}') ?? [];
        _completedPuzzles = completedList.toSet();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getDifficultyName() {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Normal';
      case Difficulty.hard:
        return 'Difficult';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF87A96B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _getDifficultyName(),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _puzzles.isEmpty
          ? Center(
              child: Text(
                'No puzzles available',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _puzzles.length,
              itemBuilder: (context, index) {
                final puzzle = _puzzles[index];
                final puzzleKey = '${widget.difficulty.name}_$index';
                final isCompleted = _completedPuzzles.contains(puzzleKey);
                final progress = _prefs?.getString('progress_$puzzleKey');
                final progressData = progress != null
                    ? PuzzleProgress.fromJson(jsonDecode(progress))
                    : null;

                return _buildPuzzleCard(
                  puzzle,
                  index,
                  isCompleted,
                  progressData,
                );
              },
            ),
    );
  }

  Widget _buildPuzzleCard(
    Puzzle puzzle,
    int index,
    bool isCompleted,
    PuzzleProgress? progress,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isCompleted
            ? LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFF6B8E4E).withAlpha(100),
                        const Color(0xFF87A96B).withAlpha(50),
                      ]
                    : [
                        const Color(0xFFF5F7F3),
                        const Color(0xFFE8EDE3).withAlpha(200),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: isDark
                    ? [const Color(0xFF2D3A2A), const Color(0xFF1E251D)]
                    : [const Color(0xFFF5F7F3), const Color(0xFFE8EDE3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF9CAF88)
              : (isDark ? const Color(0xFF3A4A3A) : const Color(0xFF9CAF88)),
          width: isCompleted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isCompleted
                ? Colors.green.withAlpha(isDark ? 50 : 30)
                : Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: isCompleted ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CrosswordHome(
                  initialDifficulty: widget.difficulty,
                  initialPuzzleIndex: index,
                ),
              ),
            ).then((_) => _loadPuzzles());
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF87A96B), Color(0xFF6B8E4E)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFFF5F7F3),
                      size: 24,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF3A4A3A)
                          : const Color(0xFFE8EDE3),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey[200] : Colors.black87,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  puzzle.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCompleted
                        ? const Color(0xFF87A96B)
                        : (isDark ? Colors.grey[200] : Colors.black87),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${puzzle.rows}×${puzzle.cols}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                if (progress != null && progress.completionTime != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(progress.completionTime!),
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFF9CAF88)
                              : const Color(0xFF6B8E4E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return mins > 0 ? '${mins}m ${secs}s' : '${secs}s';
  }
}

class CrosswordHome extends StatefulWidget {
  final Difficulty? initialDifficulty;
  final int? initialPuzzleIndex;

  const CrosswordHome({
    super.key,
    this.initialDifficulty,
    this.initialPuzzleIndex,
  });

  @override
  State<CrosswordHome> createState() => _CrosswordHomeState();
}

class _CrosswordHomeState extends State<CrosswordHome>
    with TickerProviderStateMixin {
  Puzzle? _puzzle;
  List<Puzzle> _availablePuzzles = [];
  int _currentPuzzleIndex = 0;
  late Difficulty _difficulty;
  final Map<String, TextEditingController> _cellControllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, bool> _cellReadonly = {};
  final Map<String, Color> _cellColor = {};
  final Map<String, String> _cellNumbers = {};
  final Map<String, AnimationController> _entryAnimations = {};
  SharedPreferences? _prefs;
  final Map<String, int> _bestTimes = {};
  final List<HighScore> _allScores = [];
  Timer? _timer;
  int _elapsed = 0;
  bool _running = false;
  late AnimationController _successController;
  String? _currentDirection;
  Entry? _selectedEntry;
  int _hintsRemaining = 5;
  GameStats _stats = GameStats();
  String? _currentCellKey;
  final bool _autoCheck = true;
  final Map<String, bool> _entryCompleted = {};
  bool _isLoading = true;

  final Map<String, AnimationController> _cellFocusAnimations = {};

  @override
  void initState() {
    super.initState();
    _difficulty = widget.initialDifficulty ?? Difficulty.easy;
    _currentPuzzleIndex = widget.initialPuzzleIndex ?? 0;
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _loadPuzzles();
  }

  Future<void> _loadPuzzles() async {
    setState(() => _isLoading = true);
    final puzzles = await PuzzleLoader.loadPuzzles();
    await _loadPrefs();
    _changeDifficulty(_difficulty, puzzles: puzzles);
    setState(() => _isLoading = false);
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _bestTimes['easy'] = _prefs?.getInt('best_easy') ?? 0;
      _bestTimes['medium'] = _prefs?.getInt('best_medium') ?? 0;
      _bestTimes['hard'] = _prefs?.getInt('best_hard') ?? 0;
      // Hints are now loaded per puzzle in _loadSavedGame()

      final statsJson = _prefs?.getString('game_stats');
      if (statsJson != null) {
        _stats = GameStats.fromJson(jsonDecode(statsJson));
      }

      final scoresJson = _prefs?.getString('all_scores');
      if (scoresJson != null) {
        final List<dynamic> scores = jsonDecode(scoresJson);
        _allScores.clear();
        _allScores.addAll(scores.map((s) => HighScore.fromJson(s)).toList());
        _allScores.sort((a, b) => a.time.compareTo(b.time));
      }
    });
  }

  void _saveScore(Difficulty d, int seconds) async {
    final score = HighScore(
      difficulty: d,
      time: seconds,
      timestamp: DateTime.now(),
    );
    _allScores.add(score);
    _allScores.sort((a, b) => a.time.compareTo(b.time));
    await _prefs?.setString(
      'all_scores',
      jsonEncode(_allScores.map((s) => s.toJson()).toList()),
    );
  }

  void _loadSavedGame() {
    if (_puzzle == null) return;
    final saved = _prefs?.getString(
      'saved_game_${_difficulty.name}_$_currentPuzzleIndex',
    );
    if (saved != null) {
      final data = jsonDecode(saved);
      _elapsed = data['elapsed'] ?? 0;
      final cells = data['cells'] as Map<String, dynamic>;
      for (final entry in cells.entries) {
        if (_cellControllers.containsKey(entry.key)) {
          _cellControllers[entry.key]!.text = entry.value as String;
        }
      }
    }
    // Load hints for this specific puzzle
    _hintsRemaining =
        _prefs?.getInt('hints_${_difficulty.name}_$_currentPuzzleIndex') ?? 5;
  }

  Future<void> _saveGame() async {
    if (_puzzle == null) return;
    final cells = <String, String>{};
    for (final entry in _cellControllers.entries) {
      if (entry.value.text.isNotEmpty) {
        cells[entry.key] = entry.value.text;
      }
    }
    await _prefs?.setString(
      'saved_game_${_difficulty.name}_$_currentPuzzleIndex',
      jsonEncode({'elapsed': _elapsed, 'cells': cells}),
    );
  }

  void _clearSavedGame() async {
    await _prefs?.remove('saved_game_${_difficulty.name}_$_currentPuzzleIndex');
    // Also clear hints for this puzzle so it resets to 5 next time
    await _prefs?.remove('hints_${_difficulty.name}_$_currentPuzzleIndex');
  }

  void _saveBest(Difficulty d, int seconds) async {
    final key = 'best_${d.name}';
    final prev = _prefs?.getInt(key) ?? 0;
    if (prev == 0 || seconds < prev) {
      await _prefs?.setInt(key, seconds);
      setState(() {
        _bestTimes[d.name] = seconds;
      });
    }
  }

  void _markPuzzleCompleted() async {
    final puzzleKey = '${_difficulty.name}_$_currentPuzzleIndex';
    final completedList =
        _prefs?.getStringList('completed_${_difficulty.name}') ?? [];
    if (!completedList.contains(puzzleKey)) {
      completedList.add(puzzleKey);
      await _prefs?.setStringList(
        'completed_${_difficulty.name}',
        completedList,
      );
    }

    final progress = PuzzleProgress(
      puzzleKey: puzzleKey,
      completed: true,
      completionTime: _elapsed,
      completedAt: DateTime.now(),
      hintsUsed: 5 - _hintsRemaining,
      cellsFilled: _cellControllers.values
          .where((c) => c.text.isNotEmpty)
          .length,
    );
    await _prefs?.setString(
      'progress_$puzzleKey',
      jsonEncode(progress.toJson()),
    );
  }

  void _updateStats(int seconds) async {
    _stats.totalCompletions++;
    _stats.totalTime += seconds;
    _stats.completionsByDifficulty[_difficulty.name] =
        (_stats.completionsByDifficulty[_difficulty.name] ?? 0) + 1;

    final diffCount = _stats.completionsByDifficulty[_difficulty.name] ?? 1;
    final prevAvg = _stats.averageTimeByDifficulty[_difficulty.name] ?? 0;
    _stats.averageTimeByDifficulty[_difficulty.name] =
        ((prevAvg * (diffCount - 1)) + seconds) ~/ diffCount;

    _stats.recentTimes.add(seconds);
    if (_stats.recentTimes.length > 10) {
      _stats.recentTimes.removeAt(0);
    }

    if (_hintsRemaining == 5) {
      _stats.perfectCompletions++;
    }
    _stats.hintsUsedTotal += (5 - _hintsRemaining);

    final now = DateTime.now();
    if (_stats.lastPlayed != null) {
      final diff = now.difference(_stats.lastPlayed!);
      if (diff.inDays == 1) {
        _stats.currentStreak++;
      } else if (diff.inDays > 1) {
        _stats.currentStreak = 1;
      }
    } else {
      _stats.currentStreak = 1;
    }
    if (_stats.currentStreak > _stats.bestStreak) {
      _stats.bestStreak = _stats.currentStreak;
    }
    _stats.lastPlayed = now;
    await _prefs?.setString('game_stats', jsonEncode(_stats.toJson()));
  }

  void _changeDifficulty(
    Difficulty d, {
    Map<String, List<Puzzle>>? puzzles,
  }) async {
    final allPuzzles = puzzles ?? await PuzzleLoader.loadPuzzles();
    setState(() {
      _difficulty = d;
      _availablePuzzles = allPuzzles[d.name] ?? [];
      _currentPuzzleIndex = 0;
      // Hints are reset in _initGrid() and loaded per puzzle in _loadSavedGame()
      if (_availablePuzzles.isNotEmpty) {
        _puzzle = _availablePuzzles[_currentPuzzleIndex];
        _initGrid();
      }
    });
  }

  void _loadNextPuzzle() {
    if (_availablePuzzles.isEmpty) return;
    setState(() {
      _currentPuzzleIndex =
          (_currentPuzzleIndex + 1) % _availablePuzzles.length;
      _puzzle = _availablePuzzles[_currentPuzzleIndex];
      _initGrid();
    });
  }

  void _initGrid() {
    if (_puzzle == null) return;
    _stopTimer();
    _elapsed = 0;
    _running = false;
    _currentDirection = null;
    _selectedEntry = null;
    _currentCellKey = null;
    _entryCompleted.clear();
    // Reset hints to 5 for new puzzle (will be overridden if loading saved game)
    _hintsRemaining = 5;

    // Dispose old animations
    for (final anim in _entryAnimations.values) {
      anim.dispose();
    }
    _entryAnimations.clear();

    for (final anim in _cellFocusAnimations.values) {
      anim.dispose();
    }
    _cellFocusAnimations.clear();

    // Dispose old controllers
    for (final c in _cellControllers.values) {
      c.dispose();
    }
    for (final f in _focusNodes.values) {
      f.dispose();
    }

    _cellControllers.clear();
    _focusNodes.clear();
    _cellReadonly.clear();
    _cellColor.clear();
    _cellNumbers.clear();

    // Create animations for each entry
    for (final e in _puzzle!.entries) {
      _entryAnimations[e.id] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    }

    // Create focus animations for cells
    for (int r = 0; r < _puzzle!.rows; r++) {
      for (int c = 0; c < _puzzle!.cols; c++) {
        final key = '$r-$c';
        _cellFocusAnimations[key] = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    // Initialize all cells
    for (int r = 0; r < _puzzle!.rows; r++) {
      for (int c = 0; c < _puzzle!.cols; c++) {
        final key = '$r-$c';
        _cellControllers[key] = TextEditingController();
        _focusNodes[key] = FocusNode();
        _focusNodes[key]!.addListener(() {
          if (_focusNodes[key]!.hasFocus) {
            _onCellFocused(key);
          }
        });
        _cellReadonly[key] = true;
        _cellColor[key] = const Color(0xFFF5F7F3);
      }
    }

    // Mark editable cells and assign numbers
    for (final e in _puzzle!.entries) {
      final word = e.answer.toUpperCase();
      for (int i = 0; i < word.length; i++) {
        final r = e.row + (e.direction == 'D' ? i : 0);
        final c = e.col + (e.direction == 'A' ? i : 0);
        final key = '$r-$c';
        _cellReadonly[key] = false;
        if (i == 0) {
          _cellNumbers[key] = e.id;
        }
      }
    }

    _loadSavedGame();
    setState(() {});
  }

  void _onCellFocused(String key) {
    setState(() {
      _currentCellKey = key;
      final parts = key.split('-');
      final r = int.parse(parts[0]);
      final c = int.parse(parts[1]);

      // Animate focus
      _cellFocusAnimations[key]?.forward(from: 0);

      for (final e in _puzzle!.entries) {
        final word = e.answer.toUpperCase();
        for (int i = 0; i < word.length; i++) {
          final er = e.row + (e.direction == 'D' ? i : 0);
          final ec = e.col + (e.direction == 'A' ? i : 0);
          if (er == r && ec == c) {
            _selectedEntry = e;
            _currentDirection = e.direction;

            break;
          }
        }
        if (_selectedEntry != null) break;
      }
    });
  }

  Entry? _getEntryForCell(String key) {
    if (_puzzle == null) return null;
    final parts = key.split('-');
    final r = int.parse(parts[0]);
    final c = int.parse(parts[1]);

    for (final e in _puzzle!.entries) {
      final word = e.answer.toUpperCase();
      for (int i = 0; i < word.length; i++) {
        final er = e.row + (e.direction == 'D' ? i : 0);
        final ec = e.col + (e.direction == 'A' ? i : 0);
        if (er == r && ec == c) {
          return e;
        }
      }
    }
    return null;
  }

  void _moveFocus(String direction) {
    if (_currentCellKey == null || _puzzle == null) return;
    final parts = _currentCellKey!.split('-');
    int r = int.parse(parts[0]);
    int c = int.parse(parts[1]);

    if (direction == 'left') {
      for (int nc = c - 1; nc >= 0; nc--) {
        final nkey = '$r-$nc';
        if (!(_cellReadonly[nkey] ?? true)) {
          _focusNodes[nkey]!.requestFocus();
          return;
        }
      }
    } else if (direction == 'right') {
      for (int nc = c + 1; nc < _puzzle!.cols; nc++) {
        final nkey = '$r-$nc';
        if (!(_cellReadonly[nkey] ?? true)) {
          _focusNodes[nkey]!.requestFocus();
          return;
        }
      }
    } else if (direction == 'up') {
      for (int nr = r - 1; nr >= 0; nr--) {
        final nkey = '$nr-$c';
        if (!(_cellReadonly[nkey] ?? true)) {
          _focusNodes[nkey]!.requestFocus();
          return;
        }
      }
    } else if (direction == 'down') {
      for (int nr = r + 1; nr < _puzzle!.rows; nr++) {
        final nkey = '$nr-$c';
        if (!(_cellReadonly[nkey] ?? true)) {
          _focusNodes[nkey]!.requestFocus();
          return;
        }
      }
    }
  }

  void _toggleDirection() {
    if (_currentCellKey == null || _selectedEntry == null) return;
    setState(() {
      _currentDirection = _currentDirection == 'A' ? 'D' : 'A';
    });
  }

  void _useHint() {
    if (_hintsRemaining <= 0 || _puzzle == null) return;

    // If no entry is selected, try to use the current cell's entry
    Entry? entry = _selectedEntry;
    if (entry == null && _currentCellKey != null) {
      entry = _getEntryForCell(_currentCellKey!);
    }

    if (entry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a clue first'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.grey.shade700,
        ),
      );
      return;
    }

    final word = entry.answer.toUpperCase();
    final emptyCells = <String>[];

    // Find all empty cells in this entry
    for (int i = 0; i < word.length; i++) {
      final r = entry.row + (entry.direction == 'D' ? i : 0);
      final c = entry.col + (entry.direction == 'A' ? i : 0);
      final key = '$r-$c';
      final controller = _cellControllers[key];
      if (controller != null && controller.text.isEmpty) {
        emptyCells.add(key);
      }
    }

    if (emptyCells.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('This clue is already complete'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.grey.shade700,
        ),
      );
      return;
    }

    // Reveal a random empty cell
    final random =
        emptyCells[DateTime.now().millisecondsSinceEpoch % emptyCells.length];
    final parts = random.split('-');
    final r = int.parse(parts[0]);
    final c = int.parse(parts[1]);

    // Find the position in the word
    int pos = -1;
    for (int i = 0; i < word.length; i++) {
      final er = entry.row + (entry.direction == 'D' ? i : 0);
      final ec = entry.col + (entry.direction == 'A' ? i : 0);
      if (er == r && ec == c) {
        pos = i;
        break;
      }
    }

    if (pos >= 0 && pos < word.length) {
      setState(() {
        final controller = _cellControllers[random];
        if (controller != null) {
          controller.text = word[pos];
          controller.selection = const TextSelection.collapsed(offset: 1);
        }
        _hintsRemaining--;
        _prefs?.setInt(
          'hints_${_difficulty.name}_$_currentPuzzleIndex',
          _hintsRemaining,
        );
        _saveGame();
        // Check if the entry is now complete after revealing the hint
        if (entry != null) {
          _checkEntry(entry);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hint revealed: ${word[pos]}'),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF87A96B),
        ),
      );
    }
  }

  void _startTimer() {
    if (_running) return;
    _running = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed += 1;
      });
      _saveGame();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _running = false;
  }

  void _checkEntry(Entry e) {
    if (_puzzle == null) return;
    final expected = e.answer.toUpperCase();
    final buffer = StringBuffer();
    for (int i = 0; i < expected.length; i++) {
      final r = e.row + (e.direction == 'D' ? i : 0);
      final c = e.col + (e.direction == 'A' ? i : 0);
      final key = '$r-$c';
      final val = _cellControllers[key]!.text.toUpperCase();
      buffer.write(val.isEmpty ? ' ' : val[0]);
    }
    final got = buffer.toString();
    final matches = got == expected;

    setState(() {
      _entryCompleted[e.id] = matches;
      final anim = _entryAnimations[e.id];
      if (matches && anim != null) {
        anim.forward(from: 0);
      }

      for (int i = 0; i < expected.length; i++) {
        final r = e.row + (e.direction == 'D' ? i : 0);
        final c = e.col + (e.direction == 'A' ? i : 0);
        final key = '$r-$c';
        if (_autoCheck) {
          if (matches) {
            _cellColor[key] = const Color.fromRGBO(76, 175, 80, 0.4);
          } else if (got[i] == expected[i] && got[i] != ' ') {
            _cellColor[key] = const Color.fromRGBO(255, 193, 7, 0.3);
          } else {
            _cellColor[key] = const Color(0xFFF5F7F3);
          }
        }
      }
    });
  }

  void _checkAll() {
    if (_puzzle == null) return;
    _startTimer();
    bool allCorrect = true;
    for (final e in _puzzle!.entries) {
      _checkEntry(e);
      final expected = e.answer.toUpperCase();
      final buffer = StringBuffer();
      for (int i = 0; i < expected.length; i++) {
        final r = e.row + (e.direction == 'D' ? i : 0);
        final c = e.col + (e.direction == 'A' ? i : 0);
        final key = '$r-$c';
        final val = _cellControllers[key]!.text.toUpperCase();
        buffer.write(val.isEmpty ? ' ' : val[0]);
      }
      if (buffer.toString() != expected) allCorrect = false;
    }

    if (allCorrect) {
      _stopTimer();
      _clearSavedGame();
      final time = _elapsed == 0 ? 1 : _elapsed;
      _saveBest(_difficulty, time);
      _saveScore(_difficulty, time);
      _updateStats(time);
      _markPuzzleCompleted();
      _successController.forward();
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      showDialog(
        context: context,
        barrierColor: const Color(0xFF2D3A2A).withAlpha(100),
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D3A2A) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF87A96B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Puzzle Complete!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? const Color(0xFFF5F7F3)
                          : const Color(0xFF2D3A2A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildStatRow(
                          Icons.timer,
                          'Completed in',
                          _formatTime(_elapsed),
                        ),
                        Divider(
                          height: 20,
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                        ),
                        _buildStatRow(
                          Icons.emoji_events,
                          'Best',
                          _bestTimes[_difficulty.name] == 0
                              ? '--'
                              : _formatTime(_bestTimes[_difficulty.name]!),
                        ),
                        Divider(
                          height: 20,
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                        ),
                        _buildStatRow(
                          Icons.local_fire_department,
                          'Streak',
                          '${_stats.currentStreak} days',
                        ),
                        Divider(
                          height: 20,
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                        ),
                        _buildStatRow(
                          Icons.check_circle,
                          'Total Completions',
                          '${_stats.totalCompletions}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_availablePuzzles.length > 1)
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _loadNextPuzzle();
                          },
                          icon: const Icon(
                            Icons.skip_next,
                            color: Color(0xFF87A96B),
                          ),
                          label: const Text('Next Puzzle'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.check, color: Color(0xFF87A96B)),
                        label: const Text('OK'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return mins > 0 ? '${mins}m ${secs}s' : '${secs}s';
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(
              0xFF87A96B,
            ).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF87A96B)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? const Color(0xFFF5F7F3) : const Color(0xFF2D3A2A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF87A96B),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _stopTimer();
    for (final c in _cellControllers.values) {
      c.dispose();
    }
    for (final f in _focusNodes.values) {
      f.dispose();
    }
    for (final anim in _entryAnimations.values) {
      anim.dispose();
    }
    for (final anim in _cellFocusAnimations.values) {
      anim.dispose();
    }
    _successController.dispose();
    super.dispose();
  }

  Widget _buildGrid() {
    if (_puzzle == null) return const SizedBox();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive cell size based on available width
        final maxWidth = constraints.maxWidth - 24; // Account for padding
        final cellSpacing = 3.0;
        final totalSpacing = (_puzzle!.cols - 1) * cellSpacing;
        final availableWidth = maxWidth - totalSpacing;
        final cellSize = (availableWidth / _puzzle!.cols).clamp(35.0, 60.0);

        final cells = <Widget>[];

        for (int r = 0; r < _puzzle!.rows; r++) {
          for (int c = 0; c < _puzzle!.cols; c++) {
            final key = '$r-$c';
            final readonly = _cellReadonly[key] ?? true;
            final controller = _cellControllers[key]!;
            final focus = _focusNodes[key]!;
            final number = _cellNumbers[key];
            final isFocused = _currentCellKey == key;
            final entry = _getEntryForCell(key);
            final isCompleted = _entryCompleted[entry?.id] == true;

            cells.add(
              Semantics(
                label: readonly
                    ? 'Blocked cell'
                    : 'Input cell for ${entry?.id ?? "entry"} ${entry?.direction == "A" ? "across" : "down"}, row ${r + 1} column ${c + 1}',
                hint: readonly
                    ? null
                    : 'Tap to focus this cell. Current clue: ${entry?.clue ?? ""}',
                child: GestureDetector(
                  onTap: () {
                    if (!readonly) {
                      focus.requestFocus();
                    }
                  },
                  child: SizedBox(
                    width: cellSize,
                    height: cellSize,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        gradient: readonly
                            ? null
                            : (isDark
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFF2D3A2A),
                                        const Color(0xFF3A4A3A),
                                      ],
                                    )
                                  : LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white,
                                        const Color(0xFFF5F7F3),
                                      ],
                                    )),
                        color: readonly
                            ? (isDark
                                  ? const Color(0xFF1E251D)
                                  : Colors.grey.shade300)
                            : null,
                        border: Border.all(
                          color: isFocused
                              ? const Color(0xFF87A96B)
                              : readonly
                              ? (isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade400)
                              : (isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300),
                          width: isFocused ? 2.5 : 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isFocused
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF87A96B,
                                  ).withValues(alpha: isDark ? 0.6 : 0.5),
                                  blurRadius: 16,
                                  spreadRadius: 3,
                                  offset: const Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: const Color(
                                    0xFF87A96B,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : readonly
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: isDark ? 0.3 : 0.1,
                                  ),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: isDark ? 0.2 : 0.05,
                                  ),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: readonly
                          ? const SizedBox.shrink()
                          : Stack(
                              children: [
                                if (number != null)
                                  Positioned(
                                    top: 3,
                                    left: 3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: isDark
                                              ? [
                                                  const Color(
                                                    0xFF87A96B,
                                                  ).withValues(alpha: 0.4),
                                                  const Color(
                                                    0xFF9CAF88,
                                                  ).withValues(alpha: 0.3),
                                                ]
                                              : [
                                                  const Color(
                                                    0xFF87A96B,
                                                  ).withValues(alpha: 0.2),
                                                  const Color(
                                                    0xFF9CAF88,
                                                  ).withValues(alpha: 0.15),
                                                ],
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color:
                                              (isDark
                                                      ? const Color(0xFF9CAF88)
                                                      : const Color(0xFF87A96B))
                                                  .withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF87A96B,
                                            ).withValues(alpha: 0.25),
                                            blurRadius: 3,
                                            spreadRadius: 0,
                                            offset: const Offset(0, 1.5),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        number,
                                        style: TextStyle(
                                          fontSize: cellSize * 0.13,
                                          fontWeight: FontWeight.w900,
                                          color: isDark
                                              ? const Color(0xFF9CAF88)
                                              : const Color(0xFF87A96B),
                                          height: 1.0,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: TextField(
                                      controller: controller,
                                      focusNode: focus,
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      maxLines: 1,
                                      maxLength: 1,
                                      cursorColor: isDark
                                          ? const Color(0xFF9CAF88)
                                          : const Color(0xFF87A96B),
                                      cursorWidth: 3.0,
                                      cursorRadius: const Radius.circular(2),
                                      style: TextStyle(
                                        fontSize: cellSize * 0.44,
                                        fontWeight: isFocused
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        letterSpacing: isFocused ? 1.0 : 0.5,
                                        height: 1.0,
                                        color: isCompleted
                                            ? (isDark
                                                  ? const Color(0xFF9CAF88)
                                                  : const Color(0xFF87A96B))
                                            : (isDark
                                                  ? const Color(0xFFF5F7F3)
                                                  : const Color(0xFF2D3A2A)),
                                        shadows: isFocused
                                            ? [
                                                Shadow(
                                                  color:
                                                      (isCompleted
                                                              ? (isDark
                                                                    ? const Color(
                                                                        0xFF9CAF88,
                                                                      )
                                                                    : const Color(
                                                                        0xFF87A96B,
                                                                      ))
                                                              : (isDark
                                                                    ? const Color(
                                                                        0xFFF5F7F3,
                                                                      )
                                                                    : const Color(
                                                                        0xFF2D3A2A,
                                                                      )))
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        counterText: '',
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      selectionControls:
                                          MaterialTextSelectionControls(),
                                      buildCounter:
                                          (
                                            context, {
                                            required currentLength,
                                            required isFocused,
                                            maxLength,
                                          }) => null,
                                      onChanged: (v) {
                                        _startTimer();
                                        if (v.isNotEmpty) {
                                          controller.text = v[0].toUpperCase();
                                          controller.selection =
                                              const TextSelection.collapsed(
                                                offset: 1,
                                              );

                                          if (_autoCheck && entry != null) {
                                            _checkEntry(entry);
                                          }
                                          if (_currentDirection == 'A') {
                                            _moveFocus('right');
                                          } else if (_currentDirection == 'D') {
                                            _moveFocus('down');
                                          } else {
                                            _moveFocus('right');
                                          }
                                          setState(() {});
                                        }
                                      },
                                      onSubmitted: (_) {
                                        if (_currentDirection == 'A') {
                                          _moveFocus('right');
                                        } else {
                                          _moveFocus('down');
                                        }
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[A-Za-z]'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            );
          }
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.transparent),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                  _moveFocus('left');
                } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                  _moveFocus('right');
                } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                  _moveFocus('up');
                } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  _moveFocus('down');
                } else if (event.logicalKey == LogicalKeyboardKey.tab) {
                  _toggleDirection();
                }
              }
            },
            child: GridView.count(
              crossAxisCount: _puzzle!.cols,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: cellSpacing,
              crossAxisSpacing: cellSpacing,
              childAspectRatio: 1.0,
              children: cells,
            ),
          ),
        );
      },
    );
  }

  Widget _buildClues() {
    if (_puzzle == null) return const SizedBox();
    final clueTheme = Theme.of(context);
    final clueIsDark = clueTheme.brightness == Brightness.dark;
    final across = _puzzle!.entries.where((e) => e.direction == 'A').toList();
    final down = _puzzle!.entries.where((e) => e.direction == 'D').toList();

    Widget buildClueItem(Entry e, String direction) {
      final isSelected = _selectedEntry?.id == e.id;
      final isCompleted = _entryCompleted[e.id] == true;

      return Semantics(
        label:
            'Clue ${e.id}: ${e.clue}. ${isCompleted ? "Completed" : "Not completed"}',
        hint: 'Tap to focus on this clue\'s cells',
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      const Color(0xFF87A96B).withValues(alpha: 0.15),
                      const Color(0xFF9CAF88).withValues(alpha: 0.1),
                    ],
                  )
                : isCompleted
                ? (clueIsDark
                      ? LinearGradient(
                          colors: [Colors.grey.shade800, Colors.grey.shade900],
                        )
                      : LinearGradient(
                          colors: [Colors.grey.shade100, Colors.grey.shade50],
                        ))
                : (clueIsDark
                      ? LinearGradient(
                          colors: [
                            const Color(0xFF2D3A2A),
                            const Color(0xFF3A4A3A).withValues(alpha: 0.5),
                          ],
                        )
                      : LinearGradient(
                          colors: [Colors.white, Colors.grey.shade50],
                        )),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF87A96B)
                  : (clueIsDark ? Colors.grey.shade700 : Colors.grey.shade300),
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFF87A96B).withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: clueIsDark ? 0.2 : 0.05),
                blurRadius: isSelected ? 8 : 4,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                final key = '${e.row}-${e.col}';
                _focusNodes[key]?.requestFocus();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF87A96B),
                            const Color(0xFF9CAF88),
                            const Color(0xFF87A96B),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF87A96B,
                            ).withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: const Color(
                              0xFF87A96B,
                            ).withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        e.id,
                        style: const TextStyle(
                          color: Color(0xFFF5F7F3),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        e.clue,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationThickness: 2,
                          decorationColor: clueIsDark
                              ? const Color(0xFF9CAF88)
                              : const Color(0xFF87A96B),
                          height: 1.4,
                          color: isCompleted
                              ? (clueIsDark
                                    ? const Color(0xFF9CAF88)
                                    : const Color(0xFF87A96B))
                              : (clueIsDark
                                    ? const Color(0xFFF5F7F3)
                                    : const Color(0xFF2D3A2A)),
                        ),
                      ),
                    ),
                    if (isCompleted)
                      Icon(
                        Icons.check_circle,
                        color: clueIsDark
                            ? const Color(0xFF9CAF88)
                            : const Color(0xFF87A96B),
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: clueIsDark
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2D3A2A),
                      const Color(0xFF3A4A3A).withValues(alpha: 0.6),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey.shade50, Colors.white],
                  ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: clueIsDark ? Colors.grey.shade700 : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: clueIsDark ? 0.3 : 0.06),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF87A96B), Color(0xFF9CAF88)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF87A96B).withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Across',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      letterSpacing: 0.5,
                      color: clueIsDark
                          ? const Color(0xFFF5F7F3)
                          : const Color(0xFF2D3A2A),
                    ),
                  ),
                  const Spacer(),
                  if (_selectedEntry != null &&
                      _selectedEntry!.direction == 'A' &&
                      across.contains(_selectedEntry))
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF87A96B), Color(0xFF9CAF88)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF87A96B,
                            ).withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Selected',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ...across.map((e) => buildClueItem(e, 'A')),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: clueIsDark
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2D3A2A),
                      const Color(0xFF3A4A3A).withValues(alpha: 0.6),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey.shade50, Colors.white],
                  ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: clueIsDark ? Colors.grey.shade700 : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: clueIsDark ? 0.3 : 0.06),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF87A96B), Color(0xFF9CAF88)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF87A96B).withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Down',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      letterSpacing: 0.5,
                      color: clueIsDark
                          ? const Color(0xFFF5F7F3)
                          : const Color(0xFF2D3A2A),
                    ),
                  ),
                  const Spacer(),
                  if (_selectedEntry != null &&
                      _selectedEntry!.direction == 'D' &&
                      down.contains(_selectedEntry))
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF87A96B), Color(0xFF9CAF88)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF87A96B,
                            ).withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Selected',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ...down.map((e) => buildClueItem(e, 'D')),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_puzzle == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Advanced Crossword')),
        body: const Center(
          child: Text('No puzzles available for this difficulty.'),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? const Color(0xFF9CAF88) : const Color(0xFF87A96B),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LevelSelectionScreen(),
              ),
            );
          },
        ),
        title: Text(
          'Advanced Crossword (${_currentPuzzleIndex + 1}/${_availablePuzzles.length})',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: isDark ? const Color(0xFFF5F7F3) : null,
          ),
        ),
        actions: [],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF2D3A2A),
                            const Color(0xFF3A4A3A).withValues(alpha: 0.6),
                            const Color(0xFF2D3A2A),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey.shade50,
                            Colors.white,
                            Colors.grey.shade50,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.grey.shade700.withValues(alpha: 0.6)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.4 : 0.08,
                      ),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.04,
                      ),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => isDark
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFF5F7F3),
                                      Color(0xFF9CAF88),
                                    ],
                                  ).createShader(bounds)
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF2D3A2A),
                                      Color(0xFF87A96B),
                                    ],
                                  ).createShader(bounds),
                            child: Text(
                              _puzzle!.title,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.8,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _hintsRemaining > 0 ? _useHint : null,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: _hintsRemaining > 0 && isDark
                                    ? LinearGradient(
                                        colors: [
                                          const Color(0xFF3A4A3A),
                                          const Color(0xFF2D3A2A),
                                        ],
                                      )
                                    : null,
                                color: _hintsRemaining > 0 && !isDark
                                    ? Colors.white
                                    : (_hintsRemaining == 0
                                          ? (isDark
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade100)
                                          : null),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _hintsRemaining > 0
                                      ? (isDark
                                            ? Colors.grey.shade700
                                            : Colors.grey.shade300)
                                      : Colors.grey.shade400,
                                  width: 1,
                                ),
                                boxShadow: _hintsRemaining > 0
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: isDark ? 0.2 : 0.05,
                                          ),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _hintsRemaining > 0
                                        ? Icons.lightbulb_outline
                                        : Icons.lightbulb,
                                    size: 16,
                                    color: _hintsRemaining > 0
                                        ? (isDark
                                              ? const Color(0xFF9CAF88)
                                              : const Color(0xFF87A96B))
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Hints: $_hintsRemaining',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: _hintsRemaining > 0
                                          ? (isDark
                                                ? const Color(0xFFF5F7F3)
                                                : const Color(0xFF2D3A2A))
                                          : Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                      const Color(0xFF3A4A3A),
                                      const Color(0xFF2D3A2A),
                                      const Color(0xFF3A4A3A),
                                    ]
                                  : [
                                      const Color(
                                        0xFF87A96B,
                                      ).withValues(alpha: 0.2),
                                      const Color(
                                        0xFF9CAF88,
                                      ).withValues(alpha: 0.15),
                                      const Color(
                                        0xFF87A96B,
                                      ).withValues(alpha: 0.1),
                                    ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? const Color(
                                      0xFF87A96B,
                                    ).withValues(alpha: 0.5)
                                  : const Color(
                                      0xFF87A96B,
                                    ).withValues(alpha: 0.4),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF87A96B,
                                ).withValues(alpha: isDark ? 0.3 : 0.25),
                                blurRadius: 12,
                                spreadRadius: 2,
                                offset: const Offset(0, 3),
                              ),
                              BoxShadow(
                                color: const Color(
                                  0xFF87A96B,
                                ).withValues(alpha: 0.15),
                                blurRadius: 6,
                                spreadRadius: 0,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer,
                                size: 18,
                                color: isDark
                                    ? const Color(0xFF9CAF88)
                                    : const Color(0xFF87A96B),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _formatTime(_elapsed),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? const Color(0xFF9CAF88)
                                      : const Color(0xFF87A96B),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Best: ${_bestTimes[_difficulty.name] == 0 ? '--' : _formatTime(_bestTimes[_difficulty.name]!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(child: _buildGrid()),
                      const SizedBox(height: 16),
                      _buildClues(),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF87A96B), Color(0xFF9CAF88)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF87A96B,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: const Color(
                                    0xFF87A96B,
                                  ).withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _checkAll();
                              },
                              icon: const Icon(Icons.check_circle),
                              label: const Text(
                                'Check All',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  (isDark
                                          ? const Color(0xFF9CAF88)
                                          : const Color(0xFF87A96B))
                                      .withValues(alpha: 0.1),
                                  (isDark
                                          ? const Color(0xFF9CAF88)
                                          : const Color(0xFF87A96B))
                                      .withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF9CAF88)
                                    : const Color(0xFF87A96B),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (isDark
                                              ? const Color(0xFF9CAF88)
                                              : const Color(0xFF87A96B))
                                          .withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _initGrid();
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: isDark
                                    ? const Color(0xFF9CAF88)
                                    : const Color(0xFF87A96B),
                              ),
                              label: Text(
                                'Reset',
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFF9CAF88)
                                      : const Color(0xFF87A96B),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: isDark
                                    ? const Color(0xFF9CAF88)
                                    : const Color(0xFF87A96B),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide.none,
                              ),
                            ),
                          ),
                          if (_availablePuzzles.length > 1)
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    (isDark
                                            ? const Color(0xFF9CAF88)
                                            : const Color(0xFF87A96B))
                                        .withValues(alpha: 0.1),
                                    (isDark
                                            ? const Color(0xFF9CAF88)
                                            : const Color(0xFF87A96B))
                                        .withValues(alpha: 0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF9CAF88)
                                      : const Color(0xFF87A96B),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (isDark
                                                ? const Color(0xFF9CAF88)
                                                : const Color(0xFF87A96B))
                                            .withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _loadNextPuzzle();
                                },
                                icon: Icon(
                                  Icons.skip_next,
                                  color: isDark
                                      ? const Color(0xFF9CAF88)
                                      : const Color(0xFF87A96B),
                                ),
                                label: Text(
                                  'Next Puzzle',
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFF9CAF88)
                                        : const Color(0xFF87A96B),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: isDark
                                      ? const Color(0xFF9CAF88)
                                      : const Color(0xFF87A96B),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide.none,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: isDark
                              ? LinearGradient(
                                  colors: [
                                    const Color(0xFF2D3A2A),
                                    const Color(
                                      0xFF3A4A3A,
                                    ).withValues(alpha: 0.3),
                                  ],
                                )
                              : LinearGradient(
                                  colors: [Colors.grey.shade50, Colors.white],
                                ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.2 : 0.03,
                              ),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.keyboard,
                              size: 16,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                'Arrow keys: Navigate • Tab: Switch direction',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : const Color(0xFF2D3A2A),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
