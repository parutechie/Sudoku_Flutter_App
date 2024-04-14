import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/Services/game_state_manager.dart';
import 'package:sudoku/Widgets/theme/theme_provider.dart';
import 'package:unicons/unicons.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isGameSoundEnabled = true;
  bool _isDarkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadDarModeSettings();
  }

  Future<void> _loadSettings() async {
    final isGameSoundEnabled = await GameStateManager.loadGameSound();
    setState(() {
      _isGameSoundEnabled = isGameSoundEnabled;
    });
  }

  Future<void> _loadDarModeSettings() async {
    final isDarkModeEnabled = await GameStateManager.loadDarkModeState();
    setState(() {
      _isDarkModeEnabled = isDarkModeEnabled;
    });
  }

  void _toggleGameSound(bool newValue) async {
    setState(() {
      _isGameSoundEnabled = newValue;
    });
    await GameStateManager.saveGameSound(newValue);
  }

  void _toggleDarkMode(bool newValue) async {
    setState(() {
      _isDarkModeEnabled = newValue;
      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
    });

    await GameStateManager.saveDarkModeState(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                  const Text(
                    'Game Settings',
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsCard(
                      icon: Iconsax.audio_square4,
                      text: 'Game Sound',
                      defaultValue: _isGameSoundEnabled,
                      onChanged: _toggleGameSound,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              UniconsLine.moon,
                              color: Theme.of(context).primaryColor,
                              size: 32,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Dark',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54.withOpacity(.8),
                              ),
                            ),
                            Expanded(child: Container()),
                            Switch(
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                              activeTrackColor:
                                  Theme.of(context).colorScheme.primary,
                              inactiveTrackColor: Theme.of(context).hintColor,
                              inactiveThumbColor:
                                  Theme.of(context).colorScheme.onSurface,
                              value: _isDarkModeEnabled,
                              onChanged: _toggleDarkMode,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsCard extends StatefulWidget {
  const SettingsCard({
    super.key,
    required this.text,
    required this.icon,
    required this.defaultValue,
    required this.onChanged,
  });

  final String text;
  final IconData icon;
  final bool defaultValue;
  final ValueChanged<bool> onChanged;

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  @override
  Widget build(BuildContext context) {
    bool value = widget.defaultValue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: Theme.of(context).primaryColor,
              size: 32,
            ),
            const SizedBox(width: 15),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black54.withOpacity(.8),
              ),
            ),
            Expanded(child: Container()),
            Switch(
              activeColor: Theme.of(context).colorScheme.secondary,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Theme.of(context).hintColor,
              inactiveThumbColor: Theme.of(context).colorScheme.onSurface,
              value: value,
              onChanged: widget.onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
