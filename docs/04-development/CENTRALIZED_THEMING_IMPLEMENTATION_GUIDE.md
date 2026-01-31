# VividWalls MAS Centralized Theming System Implementation Guide

## Overview

This guide provides step-by-step instructions for implementing the centralized CSS theming system across all VividWalls MAS frontend applications. The system provides unified theme management, visual CSS editing, and dynamic theme application for all shadcn/ui components.

## Architecture

```
shared/
├── theme/
│   ├── theme-config.ts          # Master theme configuration
│   ├── theme-tokens.css         # Master CSS variables
│   └── theme-presets.ts         # Predefined themes
├── utils/
│   └── theme-utils.ts           # Theme manipulation utilities
├── hooks/
│   └── useThemeManager.ts       # Theme management hook
├── providers/
│   └── UnifiedThemeProvider.tsx # Centralized theme provider
├── components/theme-editor/
│   ├── ThemeEditor.tsx          # Main editor interface
│   ├── ColorPicker.tsx          # Color selection component
│   ├── TokenEditor.tsx          # Token editing interface
│   └── PreviewPanel.tsx         # Real-time preview
└── tailwind/
    └── unified-config.js        # Shared Tailwind config
```

## Implementation Steps

### Phase 1: Install Dependencies

For each frontend application, install required dependencies:

```bash
# Navigate to each frontend directory
cd services/vivid_mas_dashboard
# or cd frontend_v1
# or cd temp_frontend

# Install dependencies (if not already installed)
npm install @tailwindcss/forms @tailwindcss/typography
```

### Phase 2: Update Tailwind Configuration

Replace existing `tailwind.config.js/ts` files with the unified configuration:

#### For services/vivid_mas_dashboard/tailwind.config.js:
```javascript
const unifiedConfig = require('../../shared/tailwind/unified-config.js');

module.exports = {
  ...unifiedConfig,
  content: [
    './index.html',
    './src/**/*.{js,ts,jsx,tsx}',
    // Include shared components
    '../shared/**/*.{js,ts,jsx,tsx}',
  ],
};
```

#### For frontend_v1/tailwind.config.ts:
```typescript
import type { Config } from "tailwindcss";
const unifiedConfig = require('../shared/tailwind/unified-config.js');

const config: Config = {
  ...unifiedConfig,
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "*.{js,ts,jsx,tsx,mdx}",
    // Include shared components
    "../shared/**/*.{js,ts,jsx,tsx}",
  ],
};

export default config;
```

### Phase 3: Update CSS Files

Replace existing global CSS files with imports to the master theme tokens:

#### For services/vivid_mas_dashboard/src/index.css:
```css
/* Import master theme tokens */
@import '../../shared/theme/theme-tokens.css';

/* Application-specific styles can be added here */
```

#### For frontend_v1/app/globals.css:
```css
/* Import master theme tokens */
@import '../shared/theme/theme-tokens.css';

/* Application-specific styles */
body {
  font-family: var(--font-family-base);
}

@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}
```

### Phase 4: Update Theme Providers

Replace existing theme providers with the unified system:

#### For services/vivid_mas_dashboard/src/App.tsx:
```typescript
import { UnifiedThemeProvider } from '../../shared/providers/UnifiedThemeProvider';
// Remove old ThemeProvider import

function App() {
  return (
    <UnifiedThemeProvider 
      defaultTheme="vividwalls-default"
      registerPresets={true}
      debug={process.env.NODE_ENV === 'development'}
    >
      {/* Your existing app content */}
    </UnifiedThemeProvider>
  );
}
```

#### For frontend_v1/app/layout.tsx:
```typescript
import { UnifiedThemeProvider } from '../shared/providers/UnifiedThemeProvider';

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body>
        <UnifiedThemeProvider 
          defaultTheme="vividwalls-default"
          registerPresets={true}
        >
          {children}
        </UnifiedThemeProvider>
      </body>
    </html>
  );
}
```

### Phase 5: Add Theme Editor Integration

Add the theme editor to your applications:

#### Create a Theme Settings Page:
```typescript
// services/vivid_mas_dashboard/src/pages/ThemeSettings.tsx
import React from 'react';
import { ThemeEditor } from '../../../shared/components/theme-editor';

const ThemeSettings: React.FC = () => {
  return (
    <div className="h-screen">
      <ThemeEditor />
    </div>
  );
};

export default ThemeSettings;
```

#### Add Route (for React Router):
```typescript
// In your router configuration
import ThemeSettings from './pages/ThemeSettings';

// Add route
<Route path="/theme-settings" element={<ThemeSettings />} />
```

### Phase 6: Update Existing Components

Update existing components to use the unified theme system:

#### Remove old theme hooks:
```typescript
// Replace this:
import { useTheme } from './old-theme-provider';

// With this:
import { useTheme } from '../../shared/providers/UnifiedThemeProvider';
```

#### Update component styling:
```typescript
// Components automatically inherit the new theming
// No changes needed for shadcn/ui components
// They will automatically use the CSS variables
```

## Usage Examples

### Basic Theme Usage

```typescript
import { useTheme } from '../shared/providers/UnifiedThemeProvider';

function MyComponent() {
  const { theme, mode, setMode, isDark } = useTheme();
  
  return (
    <div className="bg-background text-foreground">
      <h1>Current theme: {theme.displayName}</h1>
      <button 
        onClick={() => setMode(isDark ? 'light' : 'dark')}
        className="bg-primary text-primary-foreground px-4 py-2 rounded"
      >
        Toggle {isDark ? 'Light' : 'Dark'} Mode
      </button>
    </div>
  );
}
```

### Advanced Theme Management

```typescript
import { useThemeManager } from '../shared/hooks/useThemeManager';

function ThemeControls() {
  const { 
    availableThemes, 
    setTheme, 
    exportCurrentTheme,
    importTheme 
  } = useThemeManager();
  
  return (
    <div>
      <select onChange={(e) => {
        const theme = availableThemes.find(t => t.name === e.target.value);
        if (theme) setTheme(theme);
      }}>
        {availableThemes.map(theme => (
          <option key={theme.name} value={theme.name}>
            {theme.displayName}
          </option>
        ))}
      </select>
      
      <button onClick={() => {
        const json = exportCurrentTheme();
        console.log('Theme JSON:', json);
      }}>
        Export Theme
      </button>
    </div>
  );
}
```

### Custom Theme Creation

```typescript
import { ThemeConfig } from '../shared/theme/theme-config';
import { useThemeManager } from '../shared/hooks/useThemeManager';

function CreateCustomTheme() {
  const { registerTheme, setTheme } = useThemeManager();
  
  const createMyTheme = () => {
    const customTheme: ThemeConfig = {
      name: 'my-custom-theme',
      displayName: 'My Custom Theme',
      description: 'A custom theme for my application',
      // ... theme configuration
    };
    
    registerTheme(customTheme);
    setTheme(customTheme);
  };
  
  return (
    <button onClick={createMyTheme}>
      Create Custom Theme
    </button>
  );
}
```

## Features

### ✅ Single CSS File Management
- Master `theme-tokens.css` contains all design tokens
- Automatic CSS variable generation
- Real-time theme updates

### ✅ Visual CSS Editor Interface
- Color picker with HSL support
- Typography, spacing, and shadow editors
- Real-time preview panel
- Preset theme selection

### ✅ Dynamic Theme Application
- Runtime theme switching without rebuilds
- CSS custom properties for instant updates
- Smooth transitions between themes

### ✅ Integration Requirements
- Seamless Tailwind CSS integration
- Full shadcn/ui component compatibility
- Light/dark mode support
- Theme backup and restoration

## Troubleshooting

### CSS Variables Not Working
- Ensure `theme-tokens.css` is imported in your main CSS file
- Check that the UnifiedThemeProvider wraps your app
- Verify Tailwind config includes the shared directory

### Theme Changes Not Applying
- Check browser console for JavaScript errors
- Ensure theme provider is properly initialized
- Verify CSS custom properties are being set on `:root`

### Import/Export Issues
- Validate JSON format when importing themes
- Check file permissions for theme exports
- Ensure theme structure matches ThemeConfig interface

## Next Steps

1. **Test Integration**: Verify all applications work with the new theming system
2. **Create Custom Themes**: Use the theme editor to create brand-specific themes
3. **Performance Optimization**: Monitor theme switching performance
4. **Documentation**: Create user guides for theme customization
5. **Advanced Features**: Consider adding theme scheduling, user preferences, etc.

## Support

For issues or questions about the theming system:
1. Check the browser console for errors
2. Verify all integration steps were followed
3. Test with the default theme first
4. Check that all dependencies are installed correctly
