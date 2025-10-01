# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Run Commands

### Building the Project
```bash
xcodebuild -project Photos.xcodeproj -scheme Photos -destination 'platform=iOS Simulator,name=iPhone 16' build
```

### Running Tests
```bash
xcodebuild -project Photos.xcodeproj -scheme Photos -destination 'platform=iOS Simulator,name=iPhone 16' test
```

### Clean Build
```bash
xcodebuild -project Photos.xcodeproj -scheme Photos clean build
```

## Architecture Overview

### Landmarks-Based Architecture
This project follows Apple's Landmarks sample app architecture pattern:

1. **@Observable Pattern**: Uses iOS 17+ `@Observable` macro instead of `ObservableObject`
   - `ModelData` is the single source of truth for app state
   - Injected via `.environment()` at app root
   - Views access via `@Environment(ModelData.self)`

2. **Navigation Architecture**:
   - **Root**: `PhotosSplitView` (NavigationSplitView for iPad/iPhone adaptation)
   - **iPad**: Sidebar navigation with detail view
   - **iPhone**: Compact mode with `PhotosMainView` as detail
   - **TabView**: `PhotosMainView` contains TabView for Library/Albums switching
   - **Navigation Stack**: Uses `NavigationPath` for type-safe navigation

3. **Data Flow**:
   ```
   PhotosApp (root)
   └── ModelData (@Observable, injected via .environment)
       └── PhotosSplitView (NavigationSplitView)
           ├── Sidebar: List with NavigationOptions
           └── Detail: NavigationStack
               └── PhotosMainView (TabView)
                   ├── Tab 1: PhotosGridView (Library)
                   └── Tab 2: AlbumsGridView (Albums)
   ```

### Key Architectural Patterns

#### NavigationOptions Enum
- Defines all navigation destinations (photos, years, months, all)
- Each case returns its corresponding view via `viewForPage()`
- Used in sidebar List for navigation links

#### Constants
- Centralized app-wide constants (spacing, sizing, grid configuration)
- Device-specific values using `@MainActor` for UI thread safety
- Responsive values based on device type (iPad vs iPhone)

#### Responsive Grid Layout
- Uses `@Environment(\.horizontalSizeClass)` for device detection
- Grid columns: iPad (6), iPhone large (4), iPhone (3)
- `LazyVGrid` with `GridItem(.flexible())` for performance

### iOS 18 Liquid Glass Design
- Uses `.toolbar` API for NavigationBar buttons (system auto-applies glass effect)
- TabView automatically applies `.ultraThinMaterial` glass effect
- Photo detail page uses `.toolbarBackground(.hidden)` for transparent toolbar
- Glass buttons use `Circle().fill(.ultraThinMaterial)` pattern

## Critical Architecture Rules

1. **State Management**:
   - ALL app-level state goes in `ModelData`
   - Use `@Observable` macro, NOT `@Published`
   - Access via `@Environment(ModelData.self)`, NOT `@EnvironmentObject`

2. **Navigation**:
   - PhotosSplitView manages the NavigationSplitView container
   - PhotosMainView manages TabView for Library/Albums
   - Use `modelData.path` (NavigationPath) for programmatic navigation
   - Navigation destinations use `.navigationDestination(for: MediaItem.self)`

3. **View Hierarchy**:
   - Root: PhotosApp → PhotosSplitView
   - Detail: PhotosMainView → PhotosGridView/AlbumsGridView
   - Never bypass PhotosSplitView for navigation

4. **Geometry Tracking**:
   - Window size tracked via `.onGeometryChange` at app root
   - Stored in `modelData.windowSize`
   - Used for responsive layout decisions

## Code Style Conventions

- **Chinese Comments**: All comments and documentation in Chinese
- **File Headers**: Each file has header comment explaining purpose and architecture reference
- **MARK Comments**: Use `// MARK: - Section Name` for organization
- **Preview Macros**: Use `@Previewable @State` for SwiftUI previews
- **MainActor**: Mark UI-related properties/functions with `@MainActor`

## Common Development Patterns

### Adding New Navigation View
1. Add case to `NavigationOptions` enum
2. Add icon name in `symbolName` computed property
3. Implement `viewForPage()` switch case
4. Add to `mainPages` static array if needed in sidebar
5. Create corresponding view file in `Views/` directory

### Adding New Tab to PhotosMainView
1. Add case to `PhotosTab` enum in PhotosMainView.swift
2. Add TabView entry with `.tabItem` and `.tag`
3. Create corresponding view file
4. Use SF Symbols for tab icons

### Creating Responsive Grid View
```swift
private var gridColumns: [GridItem] {
    let count: Int
    if horizontalSizeClass == .regular {
        count = 6 // iPad
    } else {
        let width = UIScreen.main.bounds.width
        count = width > 600 ? 4 : 3 // iPhone
    }
    return Array(repeating: GridItem(.flexible(), spacing: Constants.photoGridSpacing), count: count)
}
```

## Important Notes

- **iOS Target**: 18.0+ (uses iOS 18 APIs like `.onGeometryChange`)
- **Xcode Version**: 16.0+ required
- **Swift Version**: 5.10+ for @Observable macro support
- **No Storyboards**: Pure SwiftUI project, no UIKit/Storyboard files
- **No CocoaPods/SPM**: Currently no external dependencies
