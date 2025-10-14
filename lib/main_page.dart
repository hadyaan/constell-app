import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:note_app/habits/pages/home_page.dart';
import 'package:note_app/pages/notes_page.dart';
import 'package:note_app/pages/add_or_edit_note_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    NotesPage(),
    SizedBox(), // index 1 (Add button)
    HomePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      // Tombol Add ditekan -> buka AddOrEditNotePage dengan animasi seperti updateNote
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AddOrEditNotePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animasi masuk (halaman baru)
            final newPageAnimation =
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // dari kanan
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                );

            // Animasi keluar (halaman lama sedikit geser ke kiri)
            final oldPageAnimation =
                Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-0.3, 0.0),
                ).animate(
                  CurvedAnimation(
                    parent: secondaryAnimation,
                    curve: Curves.easeInOut,
                  ),
                );

            return SlideTransition(
              position: oldPageAnimation,
              child: SlideTransition(position: newPageAnimation, child: child),
            );
          },
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex == 1 ? 0 : _currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 28.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 38),
              decoration: BoxDecoration(
                color: (isDark
                    ? colorScheme
                          .inversePrimary //Colors.white.withOpacity(0.02)
                    : colorScheme
                          .inversePrimary), //Colors.black.withOpacity(0.02))
                //.withOpacity(0.3),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: isDark
                      ? colorScheme
                            .inversePrimary //Colors.white.withOpacity(0.1)
                      : colorScheme
                            .inversePrimary, //Colors.black.withOpacity(0.1),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    index: 0,
                    isDark: isDark,
                    colorScheme: colorScheme,
                  ),
                  _addButton(context, colorScheme, isDark),
                  _buildNavItem(
                    index: 2,
                    isDark: isDark,
                    colorScheme: colorScheme,
                  ),
                ],
                // children: [
                //   _navItem(
                //     icon: Icons.sticky_note_2_rounded,
                //     index: 0,
                //     colorScheme: colorScheme,
                //   ),
                //   _addButton(context, colorScheme, isDark),
                //   _navItem(
                //     icon: Icons.track_changes_rounded,
                //     index: 2,
                //     colorScheme: colorScheme,
                //   ),
                // ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    // Tentukan ikon berdasarkan index dan status aktif
    IconData icon;
    switch (index) {
      case 0:
        icon = _currentIndex == 0
            ? Icons
                  .sticky_note_2 // aktif (filled)
            : Icons.sticky_note_2_outlined; // tidak aktif (outline)
        break;
      case 2:
        icon = _currentIndex == 2
            ? Icons
                  .perm_contact_calendar // aktif (filled)
            : Icons.perm_contact_calendar_outlined; // tidak aktif (outline)
        break;
      default:
        icon = Icons.circle;
    }

    final bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(10),
        // decoration: BoxDecoration(
        //   color: isActive
        //       ? colorScheme.primary.withOpacity(0.1)
        //       : Colors.transparent,
        //   shape: BoxShape.circle,
        // ),
        child: Icon(
          icon,
          size: isActive ? 30 : 30,
          color: isActive
              ? colorScheme.primary
              : (isDark ? colorScheme.primary : colorScheme.primary),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required int index,
    required ColorScheme colorScheme,
  }) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          size: isActive ? 30 : 30,
          color: isActive ? colorScheme.outline : colorScheme.primary,
        ),
      ),
    );
  }

  Widget _addButton(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => _onItemTapped(1),
      child: Container(
        height: 58,
        width: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isDark
                ? [
                    colorScheme.surface, //.withOpacity(0.9),
                    colorScheme.surface, //.withOpacity(0.6),
                  ]
                : [
                    colorScheme.surface, //.withOpacity(0.9),
                    //Colors.black.withOpacity(0.7),
                    colorScheme.surface, //.withOpacity(0.9),
                    //Colors.black.withOpacity(0.5),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: colorScheme.primary,  //.withOpacity(0.4),
          //     blurRadius: 20,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Icon(
          Icons.add,
          size: 30,
          color: isDark
              ? colorScheme.inversePrimary
              : colorScheme.inversePrimary,
        ),
      ),
    );
  }

  void _openAddHabit(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Add New Habit"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter habit name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final habitName = controller.text.trim();
              if (habitName.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Habit "$habitName" added!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
              controller.clear();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
