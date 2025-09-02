# Dua Swipe Feature

## Overview
The Dua Detail Screen now includes a swipe functionality similar to the tasbih counter, allowing users to navigate through Morning Adhkar duas by swiping left or right.

## Features

### 1. Swipe Navigation
- **Swipe Left**: Move to the next dua in the Morning Adhkar sequence
- **Swipe Right**: Move to the previous dua in the Morning Adhkar sequence
- **Haptic Feedback**: Provides tactile feedback when swiping
- **Directional Animation**: Screen slides in the same direction as the swipe gesture

### 2. Progress Counter
- **Progress Bar**: Shows current position in the dua sequence (e.g., 15/34)
- **Visual Progress**: Linear progress bar that fills as you progress through the duas
- **Completion Indicator**: Shows "✓ Completed!" when all 34 Morning Adhkar are finished

### 3. Visual Indicators
- **Page Dots**: Small dots at the bottom show current position in the sequence
- **Swipe Instructions**: Text guidance for new users
- **Recitation Count**: Shows how many times to recite each dua (e.g., "1x", "3x", "100x") in the top-right corner

### 4. Completion Celebration
- **Success Dialog**: Appears when reaching the 34th dua
- **Reset Option**: Allows users to start over from the first dua
- **Success Color**: Progress bar turns green when completed

### 5. Clean Interface
- **No Arrow Indicators**: Clean, minimal design without visual clutter
- **Action Buttons**: Standard bookmark, share, and copy functionality at the bottom

## Technical Implementation

### Key Components
- `GestureDetector`: Handles swipe gestures
- `SlideTransition`: Provides smooth animation between duas with correct direction
- `AnimationController`: Manages slide animations
- `LinearProgressIndicator`: Shows progress through the sequence

### State Management
- `currentDuaIndex`: Tracks current position in the dua array
- `currentCount`: Current dua number (1-based)
- `targetCount`: Total number of Morning Adhkar (34)
- `isCounting`: Tracks if user has started swiping
- `isSlidingLeft`: Tracks animation direction for proper visual feedback

### Animation Direction
- **Swipe Left (Next)**: Screen slides from right to left
- **Swipe Right (Previous)**: Screen slides from left to right
- **Smooth Transitions**: 300ms duration with easeInOut curve

### Data Structure
- Loads all Morning Adhkar duas from `DuasRepository`
- Maintains original dua content (Arabic text, transliteration, translation)
- Preserves all existing functionality (bookmark, share, copy)

## Usage

1. **Navigate to Dua Detail**: Open any Morning Adhkar dua from the main duas screen
2. **Swipe Left**: Move to the next dua in the sequence (screen slides left)
3. **Swipe Right**: Move to the previous dua in the sequence (screen slides right)
4. **Monitor Progress**: Watch the progress bar and counter at the top
5. **Check Recitation Count**: Look at the top-right corner for times to recite (e.g., "3x")
6. **Complete**: Reach the 34th dua to see the completion celebration

## Limitations

- **Morning Adhkar Only**: Swipe functionality is currently limited to Morning Adhkar category
- **Single Category**: Other dua categories show a single dua without swipe functionality
- **No Persistence**: Progress is not saved between app sessions

## Future Enhancements

- Add swipe functionality to other dua categories
- Implement progress persistence
- Add audio recitation support
- Include bookmarking functionality
- Add completion statistics 