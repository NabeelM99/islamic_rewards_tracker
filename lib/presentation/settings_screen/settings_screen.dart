import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/services/localization_service.dart';
import '../../core/localization/app_localizations.dart';
import './widgets/confirmation_dialog_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/theme_toggle_widget.dart';
import './widgets/font_test_widget.dart';
import './widgets/notification_settings_widget.dart';
import '../../widgets/footer_navigation_widget.dart';
import '../../routes/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isSystemTheme = true;
  bool _dailyReminders = true;
  bool _prayerAlerts = false;
  bool _completionCelebrations = true;
  bool _hijriCalendar = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  int _versionTapCount = 0;

  final String _appVersion = "1.0.0";
  final String _buildNumber = "1";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _isSystemTheme = prefs.getBool('isSystemTheme') ?? true;
      _dailyReminders = prefs.getBool('dailyReminders') ?? true;
      _prayerAlerts = prefs.getBool('prayerAlerts') ?? false;
      _completionCelebrations = prefs.getBool('completionCelebrations') ?? true;
      _hijriCalendar = prefs.getBool('hijriCalendar') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setBool('isSystemTheme', _isSystemTheme);
    await prefs.setBool('dailyReminders', _dailyReminders);
    await prefs.setBool('prayerAlerts', _prayerAlerts);
    await prefs.setBool('completionCelebrations', _completionCelebrations);
    await prefs.setBool('hijriCalendar', _hijriCalendar);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setString('selectedLanguage', _selectedLanguage);
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
      _isSystemTheme = false;
    });
    _saveSettings();
    _showToast('Theme updated successfully');
  }

  void _toggleSystemTheme(bool useSystem) {
    setState(() {
      _isSystemTheme = useSystem;
      if (useSystem) {
        _isDarkMode =
            MediaQuery.of(context).platformBrightness == Brightness.dark;
      }
    });
    _saveSettings();
    _showToast('System theme ${useSystem ? 'enabled' : 'disabled'}');
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    _saveSettings();
    _showToast('Prayer notifications ${value ? 'enabled' : 'disabled'}');
  }

  void _toggleNotificationSetting(String setting, bool value) {
    setState(() {
      switch (setting) {
        case 'daily':
          _dailyReminders = value;
          break;
        case 'prayer':
          _prayerAlerts = value;
          break;
        case 'celebration':
          _completionCelebrations = value;
          break;
      }
    });
    _saveSettings();
    _showToast('Notification setting updated');
  }

  void _toggleHijriCalendar(bool value) {
    setState(() {
      _hijriCalendar = value;
    });
    _saveSettings();
    _showToast('Calendar preference updated');
  }

  void _showReminderSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Reminders'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Daily Reminders'),
              subtitle: const Text('Remind me daily to complete tasks'),
              value: _dailyReminders,
              onChanged: (value) {
                setState(() {
                  _dailyReminders = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('Prayer Alerts'),
              subtitle: const Text('Alert for prayer times'),
              value: _prayerAlerts,
              onChanged: (value) {
                setState(() {
                  _prayerAlerts = value;
                });
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('Completion Celebrations'),
              subtitle: const Text('Celebrate when tasks are completed'),
              value: _completionCelebrations,
              onChanged: (value) {
                setState(() {
                  _completionCelebrations = value;
                });
                _saveSettings();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSettings() {
    final languages = LocalizationService.supportedLanguages.keys.toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).selectLanguage),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (value) async {
                  if (value != null) {
                    final localizationService = LocalizationService();
                    await localizationService.changeLanguage(value);
                    setState(() {
                      _selectedLanguage = value;
                    });
                    _saveSettings();
                    Navigator.of(context).pop();
                    _showToast(AppLocalizations.of(context).trf('languageChanged', {'language': value}));
                  }
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancel),
          ),
        ],
      ),
    );
  }

  void _showBackupSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup & Sync'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Manage your data backup and synchronization settings.'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.backup_rounded),
              title: const Text('Create Backup'),
              subtitle: const Text('Save your progress to device'),
              onTap: () {
                Navigator.of(context).pop();
                _backupData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore_rounded),
              title: const Text('Restore Data'),
              subtitle: const Text('Restore from previous backup'),
              onTap: () {
                Navigator.of(context).pop();
                _restoreData();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpScreen() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How to use Islamic Rewards Tracker:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text('• Add daily Islamic tasks and prayers'),
              const Text('• Track your progress over time'),
              const Text('• View your completion history'),
              const Text('• Set reminders for prayers and tasks'),
              const Text('• Customize themes and notifications'),
              const SizedBox(height: 16),
              const Text(
                'Need more help?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Contact us at: support@islamicrewards.com'),
              const Text('Visit: www.islamicrewards.com/help'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Islamic Rewards Tracker'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _handleVersionTap,
              child: Text('Version: $_appVersion'),
            ),
            Text('Build: $_buildNumber'),
            const SizedBox(height: 16),
            const Text(
              'Islamic Rewards Tracker helps Muslims track their daily religious activities and build consistent spiritual habits.',
            ),
            const SizedBox(height: 16),
            const Text(
              '© 2024 Islamic Rewards Tracker\nAll rights reserved.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation() {
    ConfirmationDialogWidget.show(
      context: context,
      title: 'Reset All Settings',
      content:
          'This will reset all app settings to their default values. Your task data will not be affected.',
      confirmText: 'Reset Settings',
      cancelText: 'Cancel',
      isDestructive: true,
      onConfirm: _resetAllSettings,
    );
  }

  void _showClearDataConfirmation() {
    ConfirmationDialogWidget.show(
      context: context,
      title: 'Clear All Data',
      content:
          'This will permanently delete ALL your data including tasks, history, and settings. This action cannot be undone.',
      confirmText: 'Clear All Data',
      cancelText: 'Cancel',
      isDestructive: true,
      onConfirm: _clearAllData,
    );
  }

  Future<void> _resetAllSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Reset all settings to defaults
      setState(() {
        _isDarkMode = false;
        _isSystemTheme = true;
        _dailyReminders = true;
        _prayerAlerts = false;
        _completionCelebrations = true;
        _hijriCalendar = false;
        _notificationsEnabled = true;
        _selectedLanguage = 'English';
      });

      // Clear all settings from storage
      final settingsKeys = [
        'isDarkMode',
        'isSystemTheme',
        'dailyReminders',
        'prayerAlerts',
        'completionCelebrations',
        'hijriCalendar',
        'notificationsEnabled',
        'selectedLanguage',
      ];

      for (String key in settingsKeys) {
        await prefs.remove(key);
      }

      _showToast('All settings have been reset');
    } catch (e) {
      _showToast('Failed to reset settings');
    }
  }

  Future<void> _clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear all data
      await prefs.clear();

      // Reset state to defaults
      setState(() {
        _isDarkMode = false;
        _isSystemTheme = true;
        _dailyReminders = true;
        _prayerAlerts = false;
        _completionCelebrations = true;
        _hijriCalendar = false;
        _notificationsEnabled = true;
        _selectedLanguage = 'English';
      });

      _showToast('All data has been cleared');
    } catch (e) {
      _showToast('Failed to clear data');
    }
  }

  Future<void> _backupData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allData = <String, dynamic>{};

      for (String key in prefs.getKeys()) {
        final value = prefs.get(key);
        allData[key] = value;
      }

      // In a real implementation, this would save to file or cloud
      _showToast('Backup created successfully');
    } catch (e) {
      _showToast('Backup failed');
    }
  }

  Future<void> _restoreData() async {
    try {
      // In a real implementation, this would restore from file or cloud
      _showToast('Restore functionality coming soon');
    } catch (e) {
      _showToast('Restore failed');
    }
  }

  void _handleVersionTap() {
    _versionTapCount++;
    if (_versionTapCount >= 7) {
      _showDebugInfo();
      _versionTapCount = 0;
    }
  }

  void _showDebugInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Version: $_appVersion'),
            Text('Build Number: $_buildNumber'),
            Text('Flutter Version: 3.16.0'),
            Text('Dart Version: 3.2.0'),
            Text('Platform: ${Theme.of(context).platform.name}'),
            Text('Dark Mode: $_isDarkMode'),
            Text('System Theme: $_isSystemTheme'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFontTest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FontTestWidget(),
      ),
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.surface,
      textColor: Theme.of(context).colorScheme.onSurface,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    Text(
                      'Settings',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.settings_rounded,
                      size: 7.w,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),

              // Settings Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                        // Theme Settings
                        SettingsSectionWidget(
                          title: 'Theme',
                          children: [
                            ThemeToggleWidget(
                              isDarkMode: _isDarkMode,
                              onChanged: _toggleTheme,
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        // Notification Settings
                        const NotificationSettingsWidget(),

                        SizedBox(height: 2.h),

                        // Language Settings
                        SettingsSectionWidget(
                          title: AppLocalizations.of(context).language,
                          children: [
                            SettingsItemWidget(
                              title: AppLocalizations.of(context).language,
                              subtitle: _selectedLanguage,
                              leading: Icon(Icons.language_rounded),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 6.w,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              onTap: _showLanguageSettings,
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        // Font Settings
                        SettingsSectionWidget(
                          title: 'Arabic Font',
                          children: [
                            SettingsItemWidget(
                              title: 'Test Arabic Fonts',
                              subtitle: 'Compare diacritical mark rendering',
                              leading: Icon(Icons.font_download_rounded),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 6.w,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              onTap: _showFontTest,
                            ),
                            SettingsItemWidget(
                              title: 'Current Font',
                              subtitle: IndoPakFonts.currentFont,
                              leading: Icon(Icons.text_fields_rounded),
                              trailing: Icon(
                                Icons.info_outline_rounded,
                                size: 6.w,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        // App Settings
                        SettingsSectionWidget(
                          title: 'App',
                          children: [
                            SettingsItemWidget(
                              title: 'Backup & Sync',
                              subtitle: 'Backup your progress',
                              leading: Icon(Icons.backup_rounded),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 6.w,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              onTap: _showBackupSettings,
                            ),
                            SettingsItemWidget(
                              title: 'Help & Support',
                              subtitle: 'Get help and support',
                              leading: Icon(Icons.help_outline_rounded),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 6.w,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              onTap: _showHelpScreen,
                            ),
                            SettingsItemWidget(
                              title: 'About',
                              subtitle: 'App version and info',
                              leading: Icon(Icons.info_outline_rounded),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 6.w,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              onTap: _showAboutDialog,
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        // Reset Settings
                        SettingsSectionWidget(
                          title: 'Reset',
                          children: [
                            SettingsItemWidget(
                              title: 'Reset All Settings',
                              subtitle: 'Reset app to default settings',
                              leading: Icon(Icons.refresh_rounded),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 6.w,
                                color: theme.colorScheme.error,
                              ),
                              onTap: _showResetConfirmation,
                            ),
                            SettingsItemWidget(
                              title: 'Clear All Data',
                              subtitle: 'Delete all app data permanently',
                              leading: Icon(Icons.delete_forever_rounded),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 6.w,
                                color: theme.colorScheme.error,
                              ),
                              onTap: _showClearDataConfirmation,
                            ),
                          ],
                        ),

                        // Bottom padding for navigation bar
                        SizedBox(height: 12.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FooterNavigationWidget(
        currentRoute: AppRoutes.settings,
      ),
    );
  }
}
