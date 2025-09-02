# Smooth Animations Guide

## Overview
The Islamic Rewards Tracker app now features a comprehensive smooth animation system that provides consistent, delightful user interactions throughout the entire application.

## 🎯 **Animation Philosophy**
- **Consistent Timing**: All animations use standardized durations (200ms, 300ms, 500ms)
- **Natural Motion**: Smooth curves (easeInOutCubic) for organic feel
- **Haptic Feedback**: Tactile responses for all interactions
- **Performance Optimized**: Efficient animations that don't impact app performance

## 📱 **Page Transitions**

### **Smooth Page Transitions**
- **Slide + Fade**: New screens slide in from right with fade effect
- **Duration**: 300ms with easeInOutCubic curve
- **Reverse**: Smooth slide out when going back

### **Navigation Types**
```dart
// Regular navigation
context.smoothPushNamed('/route-name');

// Replace current screen
context.smoothPushReplacementNamed('/route-name');

// Clear stack and navigate
context.smoothPushNamedAndRemoveUntil('/route-name', predicate);
```

## 🎨 **Interactive Elements**

### **Smooth Buttons**
- **Scale Animation**: Buttons scale down to 95% when pressed
- **Elevation Change**: Subtle shadow reduction for depth
- **Haptic Feedback**: Light impact on tap, medium on long press
- **Ripple Effect**: Custom splash colors matching theme

#### **Button Types**
```dart
// Elevated button
SmoothElevatedButton(
  onPressed: () => print('Pressed!'),
  child: Text('Click Me'),
)

// Outlined button
SmoothOutlinedButton(
  onPressed: () => print('Pressed!'),
  child: Text('Click Me'),
)

// Icon button
SmoothIconButton(
  onPressed: () => print('Pressed!'),
  icon: Icons.favorite,
)
```

### **Smooth Cards**
- **Scale Animation**: Cards scale to 98% when tapped
- **Elevation Animation**: Dynamic shadow changes
- **Ripple Effect**: Custom splash and highlight colors
- **Consistent Styling**: Rounded corners and proper spacing

```dart
SmoothCard(
  onTap: () => print('Card tapped!'),
  child: Text('Card Content'),
)
```

### **Smooth List Tiles**
- **Scale Animation**: Subtle scale effect on tap
- **Color Transition**: Background color animation
- **Consistent Layout**: Proper spacing and alignment

```dart
SmoothListTile(
  onTap: () => print('Tile tapped!'),
  title: Text('Title'),
  subtitle: Text('Subtitle'),
  trailing: Icon(Icons.arrow_forward),
)
```

## 🧭 **Navigation Bar**

### **Enhanced Footer Navigation**
- **Scale Animation**: Items scale to 90% when pressed
- **Color Transition**: Smooth color changes for selection
- **Haptic Feedback**: Light impact on navigation
- **Smooth Transitions**: Fade + scale for screen changes

### **Navigation Item States**
- **Selected**: Primary color with scale animation
- **Unselected**: Muted color with normal scale
- **Pressed**: Scale down with haptic feedback

## 🎭 **Modal Dialogs & Sheets**

### **Smooth Dialogs**
- **Fade + Scale**: Dialogs fade in with scale animation
- **Duration**: 300ms with smooth curve
- **Backdrop**: Semi-transparent overlay with fade

```dart
context.smoothShowDialog(
  builder: (context) => AlertDialog(
    title: Text('Title'),
    content: Text('Content'),
  ),
);
```

### **Smooth Bottom Sheets**
- **Slide Up**: Sheets slide up from bottom
- **Duration**: 300ms with smooth curve
- **Drag Support**: Smooth drag-to-dismiss

```dart
context.smoothShowBottomSheet(
  builder: (context) => Container(
    child: Text('Bottom Sheet Content'),
  ),
);
```

## ⚙️ **Theme Configuration**

### **Animation Constants**
```dart
// Durations
static const Duration fastAnimation = Duration(milliseconds: 200);
static const Duration normalAnimation = Duration(milliseconds: 300);
static const Duration slowAnimation = Duration(milliseconds: 500);

// Curves
static const Curve smoothCurve = Curves.easeInOutCubic;
static const Curve bounceCurve = Curves.elasticOut;
static const Curve slideCurve = Curves.easeOutQuart;
```

### **Enhanced Theme**
- **Button Theme**: Consistent elevation and animation duration
- **Card Theme**: Standardized elevation and border radius
- **Page Transitions**: Custom transition builders for all platforms

## 🎪 **Special Animations**

### **Dua Swipe Animations**
- **Directional**: Screen slides match swipe direction
- **Smooth Transitions**: 300ms with easeInOutCubic
- **Haptic Feedback**: Light impact on swipe
- **Completion Celebration**: Success dialog with animations

### **Tasbih Counter**
- **Scale Animation**: Circle scales on tap
- **Pulse Effect**: Subtle pulse when counting
- **Progress Animation**: Smooth progress bar updates
- **Completion Effects**: Visual feedback when target reached

### **Task Interactions**
- **Checkbox Animation**: Smooth check/uncheck transitions
- **Counter Animation**: Smooth increment/decrement
- **Card Animations**: Scale and elevation changes
- **Progress Updates**: Animated progress indicators

## 🎨 **Visual Effects**

### **Shadows & Elevation**
- **Dynamic Shadows**: Elevation changes with interactions
- **Consistent Colors**: Theme-based shadow colors
- **Smooth Transitions**: Elevation animates with scale

### **Color Transitions**
- **Primary Colors**: Smooth transitions to primary color
- **Alpha Changes**: Subtle opacity animations
- **Theme Consistency**: All colors match app theme

### **Ripple Effects**
- **Custom Colors**: Theme-based splash and highlight colors
- **Consistent Behavior**: Same ripple across all interactive elements
- **Performance Optimized**: Efficient ripple rendering

## 📊 **Performance Optimizations**

### **Animation Efficiency**
- **SingleTickerProviderStateMixin**: Efficient animation controllers
- **Proper Disposal**: Animation controllers disposed correctly
- **Minimal Rebuilds**: Optimized widget rebuilds
- **Hardware Acceleration**: Leverages GPU for smooth animations

### **Memory Management**
- **Controller Disposal**: All controllers properly disposed
- **Widget Cleanup**: Proper state management
- **Efficient Builders**: Optimized AnimatedBuilder usage

## 🚀 **Usage Examples**

### **Basic Navigation**
```dart
// Navigate to a screen
context.smoothPushNamed('/dua-detail-screen', arguments: duaData);

// Replace current screen
context.smoothPushReplacementNamed('/home-screen');

// Show dialog
context.smoothShowDialog(
  builder: (context) => AlertDialog(
    title: Text('Success!'),
    content: Text('Operation completed successfully.'),
  ),
);
```

### **Interactive Elements**
```dart
// Smooth button
SmoothElevatedButton(
  onPressed: () => handleAction(),
  child: Text('Perform Action'),
)

// Smooth card
SmoothCard(
  onTap: () => navigateToDetail(),
  child: Column(
    children: [
      Text('Card Title'),
      Text('Card Description'),
    ],
  ),
)

// Smooth list tile
SmoothListTile(
  onTap: () => selectItem(),
  title: Text('Item Title'),
  subtitle: Text('Item Description'),
  trailing: Icon(Icons.arrow_forward),
)
```

## 🎯 **Best Practices**

### **When to Use Each Animation**
- **Fast Animation (200ms)**: Quick feedback, button presses
- **Normal Animation (300ms)**: Page transitions, card interactions
- **Slow Animation (500ms)**: Important state changes, celebrations

### **Haptic Feedback Guidelines**
- **Light Impact**: Regular interactions, button presses
- **Medium Impact**: Important actions, long presses
- **Heavy Impact**: Destructive actions, errors

### **Performance Tips**
- **Use AnimatedBuilder**: For complex animations
- **Dispose Controllers**: Always dispose animation controllers
- **Minimize Rebuilds**: Use efficient state management
- **Optimize Curves**: Use appropriate curves for each animation

## 🔧 **Customization**

### **Custom Animation Durations**
```dart
SmoothButton(
  animationDuration: Duration(milliseconds: 400),
  onPressed: () => print('Custom duration!'),
  child: Text('Custom Button'),
)
```

### **Custom Animation Curves**
```dart
SmoothCard(
  animationCurve: Curves.elasticOut,
  onTap: () => print('Bouncy animation!'),
  child: Text('Bouncy Card'),
)
```

### **Custom Colors**
```dart
SmoothIconButton(
  color: Colors.red,
  onPressed: () => print('Red button!'),
  icon: Icons.favorite,
)
```

## 📈 **Benefits**

### **User Experience**
- **Delightful Interactions**: Smooth, responsive feel
- **Visual Feedback**: Clear indication of user actions
- **Consistent Behavior**: Predictable interactions throughout app
- **Professional Feel**: Polished, modern app experience

### **Accessibility**
- **Haptic Feedback**: Tactile responses for all interactions
- **Visual Clarity**: Clear visual feedback for all actions
- **Consistent Timing**: Predictable animation durations
- **Smooth Motion**: Reduces motion sickness for sensitive users

### **Performance**
- **Optimized Animations**: Efficient GPU-accelerated animations
- **Minimal Impact**: Animations don't affect app performance
- **Memory Efficient**: Proper resource management
- **Smooth 60fps**: Consistent frame rates across devices

This comprehensive animation system ensures that every interaction in the Islamic Rewards Tracker app feels smooth, responsive, and delightful, providing users with a premium experience that encourages engagement and daily use. 