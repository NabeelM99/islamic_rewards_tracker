import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import '../services/localization_service.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
    Locale('bn', 'BD'),
  ];

  // English strings
  static const Map<String, String> _en = {
    // App
    'appTitle': 'Islamic Rewards Tracker',
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'cancel': 'Cancel',
    'save': 'Save',
    'delete': 'Delete',
    'edit': 'Edit',
    'add': 'Add',
    'done': 'Done',
    'close': 'Close',
    'back': 'Back',
    'next': 'Next',
    'previous': 'Previous',
    'confirm': 'Confirm',
    'yes': 'Yes',
    'no': 'No',
    
    // Navigation
    'home': 'Home',
    'duas': 'Duas',
    'history': 'History',
    'settings': 'Settings',
    'profile': 'Profile',
    'favorites': 'Favorites',
    'prayerTracking': 'Prayer Tracking',
    'tasbihCounter': 'Tasbih Counter',
    
    // Home Screen
    'goodMorning': 'Good Morning',
    'goodAfternoon': 'Good Afternoon',
    'goodEvening': 'Good Evening',
    'peaceBeUponYou': 'Peace be upon you',
    'tasksResetAtMidnight': 'Tasks reset at midnight',
    'tasksResetForNewDay': 'Tasks reset for new day',
    'newDayStarted': 'New day started! Your tasks have been reset.',
    'customTasksPreserved': 'custom task(s) preserved.',
    'noTasksYet': 'No Tasks Yet',
    'startIslamicJourney': 'Start your Islamic journey by adding your first daily task',
    'loadingTasks': 'Loading your tasks...',
    'addTask': 'Add Task',
    'taskAddedSuccessfully': 'Task "{taskName}" added successfully!',
    'customTaskDeleted': 'Custom task deleted successfully',
    'resetTodayTasks': 'Reset Today\'s Tasks',
    'resetConfirmation': 'Are you sure you want to reset all tasks for today? This action cannot be undone.',
    'tasksResetForToday': 'Tasks reset for today',
    'markAsComplete': 'Mark as Complete',
    'completed': 'Completed',
    'carryOver': 'Carry Over',
    'custom': 'Custom',
    
    // Task Types
    'morningAdhkar': 'Morning Adhkar',
    'eveningAdhkar': 'Evening Adhkar',
    'quranRecitation': 'Qur\'an Recitation (100 verses)',
    'dailyCharity': 'Daily Charity',
    'islamicBookReading': 'Islamic Book Reading',
    'seerahStudy': 'Seerah Study',
    
    // Settings
    'language': 'Language',
    'theme': 'Theme',
    'notifications': 'Notifications',
    'arabicFont': 'Arabic Font',
    'app': 'App',
    'backupSync': 'Backup & Sync',
    'helpSupport': 'Help & Support',
    'about': 'About',
    'selectLanguage': 'Select Language',
    'languageChanged': 'Language changed to {language}',
    'themeUpdated': 'Theme updated successfully',
    'systemThemeEnabled': 'System theme enabled',
    'systemThemeDisabled': 'System theme disabled',
    'prayerNotificationsEnabled': 'Prayer notifications enabled',
    'prayerNotificationsDisabled': 'Prayer notifications disabled',
    'backupProgress': 'Backup your progress',
    'getHelpSupport': 'Get help and support',
    'appVersionInfo': 'App version and info',
    'testArabicFonts': 'Test Arabic Fonts',
    'compareDiacriticalMarks': 'Compare diacritical mark rendering',
    'currentFont': 'Current Font',
    
    // Task Management
    'addNewTask': 'Add New Task',
    'taskName': 'Task Name',
    'taskNameHint': 'Enter task name...',
    'taskDescription': 'Description (Optional)',
    'taskDescriptionHint': 'Enter description...',
    'taskType': 'Task Type',
    'targetCount': 'Target Count',
    'targetCountHint': 'Enter target count...',
    'enterValidNumber': 'Please enter a valid number greater than 0',
    'pleaseEnterTaskName': 'Please enter task name',
    'pleaseEnterTargetCount': 'Please enter target count',
    'deleteCustomTask': 'Delete Custom Task',
    'deleteTaskConfirmation': 'Are you sure you want to delete this custom task? This action cannot be undone.',
    'deleteTaskConfirmationWithName': 'Are you sure you want to delete "{taskName}"? This action cannot be undone.',
    
    // Common
    'today': 'Today',
    'yesterday': 'Yesterday',
    'tomorrow': 'Tomorrow',
    'morning': 'Morning',
    'afternoon': 'Afternoon',
    'evening': 'Evening',
    'night': 'Night',
    'midnight': 'Midnight',
    'noon': 'Noon',
    'sunrise': 'Sunrise',
    'sunset': 'Sunset',
    
    // Time
    'seconds': 'seconds',
    'minutes': 'minutes',
    'hours': 'hours',
    'days': 'days',
    'weeks': 'weeks',
    'months': 'months',
    'years': 'years',
    
    // Numbers
    'one': 'one',
    'two': 'two',
    'three': 'three',
    'four': 'four',
    'five': 'five',
    'six': 'six',
    'seven': 'seven',
    'eight': 'eight',
    'nine': 'nine',
    'ten': 'ten',
  };

  // Arabic strings
  static const Map<String, String> _ar = {
    // App
    'appTitle': 'متتبع المكافآت الإسلامية',
    'loading': 'جاري التحميل...',
    'error': 'خطأ',
    'success': 'نجح',
    'cancel': 'إلغاء',
    'save': 'حفظ',
    'delete': 'حذف',
    'edit': 'تعديل',
    'add': 'إضافة',
    'done': 'تم',
    'close': 'إغلاق',
    'back': 'رجوع',
    'next': 'التالي',
    'previous': 'السابق',
    'confirm': 'تأكيد',
    'yes': 'نعم',
    'no': 'لا',
    
    // Navigation
    'home': 'الرئيسية',
    'duas': 'الأدعية',
    'history': 'السجل',
    'settings': 'الإعدادات',
    'profile': 'الملف الشخصي',
    'favorites': 'المفضلة',
    'prayerTracking': 'تتبع الصلاة',
    'tasbihCounter': 'عداد التسبيح',
    
    // Home Screen
    'goodMorning': 'صباح الخير',
    'goodAfternoon': 'مساء الخير',
    'goodEvening': 'مساء الخير',
    'peaceBeUponYou': 'السلام عليكم',
    'tasksResetAtMidnight': 'إعادة تعيين المهام عند منتصف الليل',
    'tasksResetForNewDay': 'إعادة تعيين المهام لليوم الجديد',
    'newDayStarted': 'بدأ يوم جديد! تم إعادة تعيين مهامك.',
    'customTasksPreserved': 'مهمة مخصصة محفوظة',
    'noTasksYet': 'لا توجد مهام بعد',
    'startIslamicJourney': 'ابدأ رحلتك الإسلامية بإضافة أول مهمة يومية',
    'loadingTasks': 'جاري تحميل مهامك...',
    'addTask': 'إضافة مهمة',
    'taskAddedSuccessfully': 'تمت إضافة المهمة "{taskName}" بنجاح!',
    'customTaskDeleted': 'تم حذف المهمة المخصصة بنجاح',
    'resetTodayTasks': 'إعادة تعيين مهام اليوم',
    'resetConfirmation': 'هل أنت متأكد من أنك تريد إعادة تعيين جميع المهام لليوم؟ لا يمكن التراجع عن هذا الإجراء.',
    'tasksResetForToday': 'تم إعادة تعيين المهام لليوم',
    'markAsComplete': 'تحديد كمكتملة',
    'completed': 'مكتملة',
    'carryOver': 'نقل',
    'custom': 'مخصصة',
    
    // Task Types
    'morningAdhkar': 'أذكار الصباح',
    'eveningAdhkar': 'أذكار المساء',
    'quranRecitation': 'تلاوة القرآن (100 آية)',
    'dailyCharity': 'الصدقة اليومية',
    'islamicBookReading': 'قراءة كتاب إسلامي',
    'seerahStudy': 'دراسة السيرة النبوية',
    
    // Settings
    'language': 'اللغة',
    'theme': 'المظهر',
    'notifications': 'الإشعارات',
    'arabicFont': 'خط عربي',
    'app': 'التطبيق',
    'backupSync': 'النسخ الاحتياطي والمزامنة',
    'helpSupport': 'المساعدة والدعم',
    'about': 'حول',
    'selectLanguage': 'اختر اللغة',
    'languageChanged': 'تم تغيير اللغة إلى {language}',
    'themeUpdated': 'تم تحديث المظهر بنجاح',
    'systemThemeEnabled': 'تم تفعيل مظهر النظام',
    'systemThemeDisabled': 'تم تعطيل مظهر النظام',
    'prayerNotificationsEnabled': 'تم تفعيل إشعارات الصلاة',
    'prayerNotificationsDisabled': 'تم تعطيل إشعارات الصلاة',
    'backupProgress': 'نسخ احتياطي لتقدمك',
    'getHelpSupport': 'احصل على المساعدة والدعم',
    'appVersionInfo': 'إصدار التطبيق والمعلومات',
    'testArabicFonts': 'اختبار الخطوط العربية',
    'compareDiacriticalMarks': 'مقارنة عرض علامات التشكيل',
    'currentFont': 'الخط الحالي',
    
    // Task Management
    'addNewTask': 'إضافة مهمة جديدة',
    'taskName': 'اسم المهمة',
    'taskNameHint': 'أدخل اسم المهمة...',
    'taskDescription': 'الوصف (اختياري)',
    'taskDescriptionHint': 'أدخل الوصف...',
    'taskType': 'نوع المهمة',
    'targetCount': 'العدد المستهدف',
    'targetCountHint': 'أدخل العدد المستهدف...',
    'enterValidNumber': 'يرجى إدخال رقم صحيح أكبر من 0',
    'pleaseEnterTaskName': 'يرجى إدخال اسم المهمة',
    'pleaseEnterTargetCount': 'يرجى إدخال العدد المستهدف',
    'deleteCustomTask': 'حذف مهمة مخصصة',
    'deleteTaskConfirmation': 'هل أنت متأكد من أنك تريد حذف هذه المهمة المخصصة؟ لا يمكن التراجع عن هذا الإجراء.',
    'deleteTaskConfirmationWithName': 'هل أنت متأكد من أنك تريد حذف "{taskName}"؟ لا يمكن التراجع عن هذا الإجراء.',
    
    // Common
    'today': 'اليوم',
    'yesterday': 'أمس',
    'tomorrow': 'غداً',
    'morning': 'صباحاً',
    'afternoon': 'ظهراً',
    'evening': 'مساءً',
    'night': 'ليلاً',
    'midnight': 'منتصف الليل',
    'noon': 'ظهر',
    'sunrise': 'شروق الشمس',
    'sunset': 'غروب الشمس',
    
    // Time
    'seconds': 'ثوانٍ',
    'minutes': 'دقائق',
    'hours': 'ساعات',
    'days': 'أيام',
    'weeks': 'أسابيع',
    'months': 'أشهر',
    'years': 'سنوات',
    
    // Numbers
    'one': 'واحد',
    'two': 'اثنان',
    'three': 'ثلاثة',
    'four': 'أربعة',
    'five': 'خمسة',
    'six': 'ستة',
    'seven': 'سبعة',
    'eight': 'ثمانية',
    'nine': 'تسعة',
    'ten': 'عشرة',
  };

  // Bangla strings
  static const Map<String, String> _bn = {
    // App
    'appTitle': 'ইসলামিক রিওয়ার্ডস ট্র্যাকার',
    'loading': 'লোড হচ্ছে...',
    'error': 'ত্রুটি',
    'success': 'সফল',
    'cancel': 'বাতিল',
    'save': 'সংরক্ষণ',
    'delete': 'মুছুন',
    'edit': 'সম্পাদনা',
    'add': 'যোগ করুন',
    'done': 'সম্পন্ন',
    'close': 'বন্ধ করুন',
    'back': 'পিছনে',
    'next': 'পরবর্তী',
    'previous': 'পূর্ববর্তী',
    'confirm': 'নিশ্চিত করুন',
    'yes': 'হ্যাঁ',
    'no': 'না',
    
    // Navigation
    'home': 'হোম',
    'duas': 'দোয়া',
    'history': 'ইতিহাস',
    'settings': 'সেটিংস',
    'profile': 'প্রোফাইল',
    'favorites': 'প্রিয়',
    'prayerTracking': 'নামাজ ট্র্যাকিং',
    'tasbihCounter': 'তাসবিহ কাউন্টার',
    
    // Home Screen
    'goodMorning': 'সুপ্রভাত',
    'goodAfternoon': 'শুভ অপরাহ্ন',
    'goodEvening': 'শুভ সন্ধ্যা',
    'peaceBeUponYou': 'আসসালামু আলাইকুম',
    'tasksResetAtMidnight': 'মধ্যরাতে কাজগুলি রিসেট হয়',
    'tasksResetForNewDay': 'নতুন দিনের জন্য কাজগুলি রিসেট হয়',
    'newDayStarted': 'নতুন দিন শুরু হয়েছে! আপনার কাজগুলি রিসেট করা হয়েছে।',
    'customTasksPreserved': 'কাস্টম কাজ সংরক্ষিত',
    'noTasksYet': 'এখনও কোন কাজ নেই',
    'startIslamicJourney': 'আপনার প্রথম দৈনিক কাজ যোগ করে আপনার ইসলামিক যাত্রা শুরু করুন',
    'loadingTasks': 'আপনার কাজগুলি লোড হচ্ছে...',
    'addTask': 'কাজ যোগ করুন',
    'taskAddedSuccessfully': 'কাজ "{taskName}" সফলভাবে যোগ করা হয়েছে!',
    'customTaskDeleted': 'কাস্টম কাজ সফলভাবে মুছে ফেলা হয়েছে',
    'resetTodayTasks': 'আজকের কাজগুলি রিসেট করুন',
    'resetConfirmation': 'আপনি কি নিশ্চিত যে আপনি আজকের সব কাজ রিসেট করতে চান? এই কাজটি অপরিবর্তনীয়।',
    'tasksResetForToday': 'আজকের জন্য কাজগুলি রিসেট করা হয়েছে',
    'markAsComplete': 'সম্পূর্ণ হিসাবে চিহ্নিত করুন',
    'completed': 'সম্পন্ন',
    'carryOver': 'বহন',
    'custom': 'কাস্টম',
    
    // Task Types
    'morningAdhkar': 'সকালের জিকর',
    'eveningAdhkar': 'সন্ধ্যার জিকর',
    'quranRecitation': 'কুরআন তেলাওয়াত (১০০ আয়াত)',
    'dailyCharity': 'দৈনিক দান',
    'islamicBookReading': 'ইসলামিক বই পড়া',
    'seerahStudy': 'সীরাত অধ্যয়ন',
    
    // Settings
    'language': 'ভাষা',
    'theme': 'থিম',
    'notifications': 'বিজ্ঞপ্তি',
    'arabicFont': 'আরবি ফন্ট',
    'app': 'অ্যাপ',
    'backupSync': 'ব্যাকআপ এবং সিঙ্ক',
    'helpSupport': 'সাহায্য এবং সমর্থন',
    'about': 'সম্পর্কে',
    'selectLanguage': 'ভাষা নির্বাচন করুন',
    'languageChanged': 'ভাষা {language} এ পরিবর্তন করা হয়েছে',
    'themeUpdated': 'থিম সফলভাবে আপডেট করা হয়েছে',
    'systemThemeEnabled': 'সিস্টেম থিম সক্রিয় করা হয়েছে',
    'systemThemeDisabled': 'সিস্টেম থিম নিষ্ক্রিয় করা হয়েছে',
    'prayerNotificationsEnabled': 'নামাজের বিজ্ঞপ্তি সক্রিয় করা হয়েছে',
    'prayerNotificationsDisabled': 'নামাজের বিজ্ঞপ্তি নিষ্ক্রিয় করা হয়েছে',
    'backupProgress': 'আপনার অগ্রগতি ব্যাকআপ করুন',
    'getHelpSupport': 'সাহায্য এবং সমর্থন পান',
    'appVersionInfo': 'অ্যাপের সংস্করণ এবং তথ্য',
    'testArabicFonts': 'আরবি ফন্ট পরীক্ষা করুন',
    'compareDiacriticalMarks': 'ডায়াক্রিটিকাল মার্ক রেন্ডারিং তুলনা করুন',
    'currentFont': 'বর্তমান ফন্ট',
    
    // Task Management
    'addNewTask': 'নতুন কাজ যোগ করুন',
    'taskName': 'কাজের নাম',
    'taskNameHint': 'কাজের নাম লিখুন...',
    'taskDescription': 'বিবরণ (ঐচ্ছিক)',
    'taskDescriptionHint': 'বিবরণ লিখুন...',
    'taskType': 'কাজের ধরন',
    'targetCount': 'লক্ষ্য সংখ্যা',
    'targetCountHint': 'লক্ষ্য সংখ্যা লিখুন...',
    'enterValidNumber': 'অনুগ্রহ করে 0 এর চেয়ে বড় একটি বৈধ সংখ্যা লিখুন',
    'pleaseEnterTaskName': 'অনুগ্রহ করে কাজের নাম লিখুন',
    'pleaseEnterTargetCount': 'অনুগ্রহ করে লক্ষ্য সংখ্যা লিখুন',
    'deleteCustomTask': 'কাস্টম কাজ মুছুন',
    'deleteTaskConfirmation': 'আপনি কি নিশ্চিত যে আপনি এই কাস্টম কাজটি মুছতে চান? এই কাজটি অপরিবর্তনীয়।',
    'deleteTaskConfirmationWithName': 'আপনি কি নিশ্চিত যে আপনি "{taskName}" মুছতে চান? এই কাজটি অপরিবর্তনীয়।',
    
    // Common
    'today': 'আজ',
    'yesterday': 'গতকাল',
    'tomorrow': 'আগামীকাল',
    'morning': 'সকাল',
    'afternoon': 'দুপুর',
    'evening': 'সন্ধ্যা',
    'night': 'রাত',
    'midnight': 'মধ্যরাত',
    'noon': 'দুপুর',
    'sunrise': 'সূর্যোদয়',
    'sunset': 'সূর্যাস্ত',
    
    // Time
    'seconds': 'সেকেন্ড',
    'minutes': 'মিনিট',
    'hours': 'ঘন্টা',
    'days': 'দিন',
    'weeks': 'সপ্তাহ',
    'months': 'মাস',
    'years': 'বছর',
    
    // Numbers
    'one': 'এক',
    'two': 'দুই',
    'three': 'তিন',
    'four': 'চার',
    'five': 'পাঁচ',
    'six': 'ছয়',
    'seven': 'সাত',
    'eight': 'আট',
    'nine': 'নয়',
    'ten': 'দশ',
  };

  String _getString(String key) {
    switch (locale.languageCode) {
      case 'ar':
        return _ar[key] ?? _en[key] ?? key;
      case 'bn':
        return _bn[key] ?? _en[key] ?? key;
      default:
        return _en[key] ?? key;
    }
  }

  String tr(String key, [List<Object>? args]) {
    String value = _getString(key);
    
    if (args != null && args.isNotEmpty) {
      for (int i = 0; i < args.length; i++) {
        value = value.replaceAll('{$i}', args[i].toString());
      }
    }
    
    return value;
  }

  String trf(String key, Map<String, Object> args) {
    String value = _getString(key);
    
    args.forEach((placeholder, replacement) {
      value = value.replaceAll('{$placeholder}', replacement.toString());
    });
    
    return value;
  }

  // Convenience methods for common strings
  String get appTitle => tr('appTitle');
  String get language => tr('language');
  String get home => tr('home');
  String get duas => tr('duas');
  String get history => tr('history');
  String get settings => tr('settings');
  String get profile => tr('profile');
  String get favorites => tr('favorites');
  String get prayerTracking => tr('prayerTracking');
  String get tasbihCounter => tr('tasbihCounter');
  String get addTask => tr('addTask');
  String get loading => tr('loading');
  String get error => tr('error');
  String get success => tr('success');
  String get cancel => tr('cancel');
  String get save => tr('save');
  String get delete => tr('delete');
  String get edit => tr('edit');
  String get add => tr('add');
  String get done => tr('done');
  String get close => tr('close');
  String get back => tr('back');
  String get next => tr('next');
  String get previous => tr('previous');
  String get confirm => tr('confirm');
  String get yes => tr('yes');
  String get no => tr('no');
  
  // Home Screen
  String get goodMorning => tr('goodMorning');
  String get goodAfternoon => tr('goodAfternoon');
  String get goodEvening => tr('goodEvening');
  String get peaceBeUponYou => tr('peaceBeUponYou');
  String get tasksResetAtMidnight => tr('tasksResetAtMidnight');
  String get tasksResetForNewDay => tr('tasksResetForNewDay');
  String get newDayStarted => tr('newDayStarted');
  String get customTasksPreserved => tr('customTasksPreserved');
  String get noTasksYet => tr('noTasksYet');
  String get startIslamicJourney => tr('startIslamicJourney');
  String get loadingTasks => tr('loadingTasks');
  String get taskAddedSuccessfully => tr('taskAddedSuccessfully');
  String get customTaskDeleted => tr('customTaskDeleted');
  String get resetTodayTasks => tr('resetTodayTasks');
  String get resetConfirmation => tr('resetConfirmation');
  String get tasksResetForToday => tr('tasksResetForToday');
  String get markAsComplete => tr('markAsComplete');
  String get completed => tr('completed');
  String get carryOver => tr('carryOver');
  String get custom => tr('custom');
  
  // Task Types
  String get morningAdhkar => tr('morningAdhkar');
  String get eveningAdhkar => tr('eveningAdhkar');
  String get quranRecitation => tr('quranRecitation');
  String get dailyCharity => tr('dailyCharity');
  String get islamicBookReading => tr('islamicBookReading');
  String get seerahStudy => tr('seerahStudy');
  
  // Settings
  String get theme => tr('theme');
  String get notifications => tr('notifications');
  String get arabicFont => tr('arabicFont');
  String get app => tr('app');
  String get backupSync => tr('backupSync');
  String get helpSupport => tr('helpSupport');
  String get about => tr('about');
  String get selectLanguage => tr('selectLanguage');
  String get languageChanged => tr('languageChanged');
  String get themeUpdated => tr('themeUpdated');
  String get systemThemeEnabled => tr('systemThemeEnabled');
  String get systemThemeDisabled => tr('systemThemeDisabled');
  String get prayerNotificationsEnabled => tr('prayerNotificationsEnabled');
  String get prayerNotificationsDisabled => tr('prayerNotificationsDisabled');
  String get backupProgress => tr('backupProgress');
  String get getHelpSupport => tr('getHelpSupport');
  String get appVersionInfo => tr('appVersionInfo');
  String get testArabicFonts => tr('testArabicFonts');
  String get compareDiacriticalMarks => tr('compareDiacriticalMarks');
  String get currentFont => tr('currentFont');
  
  // Task Management
  String get addNewTask => tr('addNewTask');
  String get taskName => tr('taskName');
  String get taskNameHint => tr('taskNameHint');
  String get taskDescription => tr('taskDescription');
  String get taskDescriptionHint => tr('taskDescriptionHint');
  String get taskType => tr('taskType');
  String get targetCount => tr('targetCount');
  String get targetCountHint => tr('targetCountHint');
  String get enterValidNumber => tr('enterValidNumber');
  String get pleaseEnterTaskName => tr('pleaseEnterTaskName');
  String get pleaseEnterTargetCount => tr('pleaseEnterTargetCount');
  String get deleteCustomTask => tr('deleteCustomTask');
  String get deleteTaskConfirmation => tr('deleteTaskConfirmation');
  String get deleteTaskConfirmationWithName => tr('deleteTaskConfirmationWithName');
  
  // Common
  String get today => tr('today');
  String get yesterday => tr('yesterday');
  String get tomorrow => tr('tomorrow');
  String get morning => tr('morning');
  String get afternoon => tr('afternoon');
  String get evening => tr('evening');
  String get night => tr('night');
  String get midnight => tr('midnight');
  String get noon => tr('noon');
  String get sunrise => tr('sunrise');
  String get sunset => tr('sunset');
  
  // Time
  String get seconds => tr('seconds');
  String get minutes => tr('minutes');
  String get hours => tr('hours');
  String get days => tr('days');
  String get weeks => tr('weeks');
  String get months => tr('months');
  String get years => tr('years');
  
  // Numbers
  String get one => tr('one');
  String get two => tr('two');
  String get three => tr('three');
  String get four => tr('four');
  String get five => tr('five');
  String get six => tr('six');
  String get seven => tr('seven');
  String get eight => tr('eight');
  String get nine => tr('nine');
  String get ten => tr('ten');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'bn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
} 