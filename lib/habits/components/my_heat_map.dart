import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final DateTime startDate;

  const MyHeatMap({super.key, required this.startDate, required this.datasets});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Habit Progress",
          style: GoogleFonts.satisfy(
            fontSize: 32,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),

        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 80),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.20)
                  : Colors.black.withOpacity(0.20),
            ),
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.02),
                    ]
                  : [
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.02),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.25)
                    : Colors.white.withOpacity(0.25),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: HeatMap(
            startDate: startDate,
            endDate: DateTime.now(),
            datasets: datasets,
            colorMode: ColorMode.color,
            defaultColor: colorScheme.secondary.withOpacity(0.3),
            textColor: colorScheme.inversePrimary,
            showColorTip: false,
            showText: true,
            scrollable: true,
            size: 36,
            colorsets: {
              1: Colors.green.shade300,
              2: Colors.green.shade400,
              3: Colors.green.shade500,
              4: Colors.green.shade600,
              5: Colors.green.shade700,
              6: Colors.green.shade800,
              7: Colors.green.shade900,
            },
          ),
        ),
      ],
    );
  }
}
