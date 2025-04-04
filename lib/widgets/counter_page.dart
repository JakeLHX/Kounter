import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../states/counter_state.dart';
import '../states/theme_state.dart';
import 'app_logo.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var counterState = context.watch<CounterState>();
    var themeState = context.watch<ThemeState>();

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        counterState.increment();
      },
      onLongPress: () {
        HapticFeedback.heavyImpact();
        counterState.reset();
      },
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLogo(size: 80),
                    const SizedBox(height: 40),
                    Text(
                      '${counterState.count}',
                      style: TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 48,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    themeState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    themeState.toggleTheme();
                  },
                ),
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: kIsWeb
                      ? InkWell(
                          onTap: () async {
                            final Uri url = Uri.parse('https://qbitservices.com');
                            try {
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  webOnlyWindowName: '_blank',
                                );
                              }
                            } catch (e) {
                              // Handle any errors silently
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withAlpha(25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onSurface.withAlpha(77),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '©2025 QBitServices',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.open_in_new,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Text(
                          '©2025 QBitServices',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                            fontSize: 12,
                          ),
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