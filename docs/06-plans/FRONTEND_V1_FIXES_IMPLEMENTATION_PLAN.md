# Frontend V1 Fixes Implementation Plan

**Created:** 2026-01-30
**Status:** Ready for Implementation
**Priority:** High
**Estimated Effort:** 3-4 days

## Executive Summary

This plan addresses issues identified during comprehensive browser testing of the VividWalls Multi-Agent System frontend_v1 application. The testing covered navigation, interactive components, and responsive behavior across desktop, tablet, and mobile viewports.

---

## Issues Overview

| # | Issue | Severity | Effort | Priority |
|---|-------|----------|--------|----------|
| 1 | Mobile Responsive - Sidebar Overlap | HIGH | 4-6 hours | P0 |
| 2 | Search Bar Non-Functional | MEDIUM | 3-4 hours | P1 |
| 3 | Notification Bell No Dropdown | MEDIUM | 2-3 hours | P1 |
| 4 | Quick Actions Not Wired | LOW | 2-3 hours | P2 |
| 5 | Agent Status Data Inconsistency | LOW | 1-2 hours | P2 |

---

## Issue 1: Mobile Responsive - Sidebar Overlap

### Problem Description
At mobile viewport (375px width), the sidebar navigation overlaps with the main content area, making the dashboard unusable on mobile devices.

### Root Cause
The sidebar is fixed-width and doesn't collapse or transform into a mobile-friendly navigation pattern at smaller breakpoints.

### Solution Architecture

```
┌─────────────────────────────────────────────────────────┐
│  DESKTOP (>1024px)     │  TABLET (768-1024px)           │
│  ┌────┬────────────┐   │  ┌────┬──────────┐             │
│  │Side│  Content   │   │  │Side│ Content  │             │
│  │bar │            │   │  │bar │          │             │
│  └────┴────────────┘   │  └────┴──────────┘             │
├─────────────────────────────────────────────────────────┤
│  MOBILE (<768px)                                        │
│  ┌──────────────────┐  ┌──────────────────┐            │
│  │ ☰ VividWalls     │  │ ☰ VividWalls   X │            │
│  ├──────────────────┤  ├──────────────────┤            │
│  │    Content       │  │ • Executive      │            │
│  │                  │  │ • Marketing      │            │
│  │                  │  │ • Sales          │            │
│  └──────────────────┘  └──────────────────┘            │
│     (Collapsed)           (Expanded Overlay)            │
└─────────────────────────────────────────────────────────┘
```

### Implementation Steps

#### Step 1.1: Create Mobile Navigation State (1 hour)

**File:** `frontend_v1/components/sidebar.tsx` (or equivalent)

```typescript
// Add state for mobile menu toggle
const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

// Add media query hook
const isMobile = useMediaQuery('(max-width: 767px)');
```

#### Step 1.2: Create Hamburger Menu Component (1 hour)

**File:** `frontend_v1/components/hamburger-menu.tsx`

```typescript
interface HamburgerMenuProps {
  isOpen: boolean;
  onToggle: () => void;
}

export function HamburgerMenu({ isOpen, onToggle }: HamburgerMenuProps) {
  return (
    <button
      className="md:hidden p-2 rounded-lg hover:bg-gray-100"
      onClick={onToggle}
      aria-label={isOpen ? 'Close menu' : 'Open menu'}
    >
      {isOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
    </button>
  );
}
```

#### Step 1.3: Update Sidebar Component (2 hours)

**File:** `frontend_v1/components/sidebar.tsx`

```typescript
export function Sidebar({ children }: SidebarProps) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      {/* Mobile Header */}
      <div className="md:hidden fixed top-0 left-0 right-0 h-16 bg-white border-b z-50 flex items-center px-4">
        <HamburgerMenu isOpen={isOpen} onToggle={() => setIsOpen(!isOpen)} />
        <span className="ml-3 font-semibold">VividWalls</span>
      </div>

      {/* Sidebar - Desktop: always visible, Mobile: overlay */}
      <aside className={cn(
        "fixed top-0 left-0 h-full bg-white border-r z-40 transition-transform duration-300",
        "w-64",
        // Desktop: always visible
        "md:translate-x-0",
        // Mobile: slide in/out
        isOpen ? "translate-x-0" : "-translate-x-full md:translate-x-0"
      )}>
        {/* Mobile close button */}
        <div className="md:hidden flex justify-end p-4">
          <button onClick={() => setIsOpen(false)}>
            <X className="h-6 w-6" />
          </button>
        </div>

        {children}
      </aside>

      {/* Mobile overlay backdrop */}
      {isOpen && (
        <div
          className="md:hidden fixed inset-0 bg-black/50 z-30"
          onClick={() => setIsOpen(false)}
        />
      )}
    </>
  );
}
```

#### Step 1.4: Update Main Layout (1 hour)

**File:** `frontend_v1/app/layout.tsx` or `frontend_v1/components/layout.tsx`

```typescript
export function Layout({ children }: LayoutProps) {
  return (
    <div className="min-h-screen">
      <Sidebar>
        <NavigationItems />
        <SystemStatus />
        <BusinessManagerChat />
      </Sidebar>

      {/* Main content - add padding for mobile header */}
      <main className="md:ml-64 pt-16 md:pt-0">
        {children}
      </main>
    </div>
  );
}
```

#### Step 1.5: Add useMediaQuery Hook (30 min)

**File:** `frontend_v1/hooks/use-media-query.ts`

```typescript
import { useState, useEffect } from 'react';

export function useMediaQuery(query: string): boolean {
  const [matches, setMatches] = useState(false);

  useEffect(() => {
    const media = window.matchMedia(query);
    if (media.matches !== matches) {
      setMatches(media.matches);
    }

    const listener = () => setMatches(media.matches);
    media.addEventListener('change', listener);
    return () => media.removeEventListener('change', listener);
  }, [matches, query]);

  return matches;
}
```

### Testing Checklist
- [ ] Menu collapses at 767px and below
- [ ] Hamburger icon appears on mobile
- [ ] Clicking hamburger opens sidebar overlay
- [ ] Clicking outside sidebar closes it
- [ ] Navigation items work when sidebar is open
- [ ] Sidebar closes after navigation on mobile
- [ ] No content overlap at any viewport size

---

## Issue 2: Search Bar Non-Functional

### Problem Description
The search input accepts text but doesn't provide autocomplete suggestions or filter results.

### Solution Architecture

```
┌─────────────────────────────────────────┐
│ 🔍 marketing                          X │
├─────────────────────────────────────────┤
│ AGENTS                                  │
│ ┌─────────────────────────────────────┐ │
│ │ 🤖 Marketing Director               │ │
│ │    CAC/LTV Optimization             │ │
│ └─────────────────────────────────────┘ │
│ ┌─────────────────────────────────────┐ │
│ │ 🤖 Email Marketing Agent            │ │
│ │    Marketing Department             │ │
│ └─────────────────────────────────────┘ │
├─────────────────────────────────────────┤
│ WORKFLOWS                               │
│ ┌─────────────────────────────────────┐ │
│ │ ⚡ Marketing Campaign Workflow      │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

### Implementation Steps

#### Step 2.1: Create Search Data Types (30 min)

**File:** `frontend_v1/types/search.ts`

```typescript
export interface SearchResult {
  id: string;
  type: 'agent' | 'workflow' | 'department';
  title: string;
  subtitle?: string;
  icon?: string;
  href: string;
}

export interface SearchState {
  query: string;
  results: SearchResult[];
  isLoading: boolean;
  isOpen: boolean;
}
```

#### Step 2.2: Create Search Data Index (1 hour)

**File:** `frontend_v1/lib/search-index.ts`

```typescript
import { agents, workflows, departments } from '@/data';

export const searchIndex: SearchResult[] = [
  // Agents
  ...agents.map(agent => ({
    id: agent.id,
    type: 'agent' as const,
    title: agent.name,
    subtitle: agent.department,
    href: `/agents/${agent.id}`,
  })),

  // Workflows
  ...workflows.map(workflow => ({
    id: workflow.id,
    type: 'workflow' as const,
    title: workflow.name,
    subtitle: workflow.status,
    href: `/workflows/${workflow.id}`,
  })),

  // Departments
  ...departments.map(dept => ({
    id: dept.id,
    type: 'department' as const,
    title: dept.name,
    subtitle: `${dept.agentCount} agents`,
    href: `/${dept.slug}`,
  })),
];

export function searchItems(query: string): SearchResult[] {
  if (!query || query.length < 2) return [];

  const lowerQuery = query.toLowerCase();

  return searchIndex
    .filter(item =>
      item.title.toLowerCase().includes(lowerQuery) ||
      item.subtitle?.toLowerCase().includes(lowerQuery)
    )
    .slice(0, 10); // Limit to 10 results
}
```

#### Step 2.3: Create Search Command Component (1.5 hours)

**File:** `frontend_v1/components/search-command.tsx`

```typescript
'use client';

import { useState, useEffect, useRef } from 'react';
import { Search, X, Bot, Zap, Building2 } from 'lucide-react';
import { useRouter } from 'next/navigation';
import { searchItems, SearchResult } from '@/lib/search-index';
import { cn } from '@/lib/utils';

export function SearchCommand() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<SearchResult[]>([]);
  const [isOpen, setIsOpen] = useState(false);
  const [selectedIndex, setSelectedIndex] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);
  const router = useRouter();

  // Search when query changes
  useEffect(() => {
    const searchResults = searchItems(query);
    setResults(searchResults);
    setSelectedIndex(0);
    setIsOpen(query.length >= 2 && searchResults.length > 0);
  }, [query]);

  // Keyboard navigation
  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (!isOpen) return;

    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault();
        setSelectedIndex(i => Math.min(i + 1, results.length - 1));
        break;
      case 'ArrowUp':
        e.preventDefault();
        setSelectedIndex(i => Math.max(i - 1, 0));
        break;
      case 'Enter':
        e.preventDefault();
        if (results[selectedIndex]) {
          router.push(results[selectedIndex].href);
          setQuery('');
          setIsOpen(false);
        }
        break;
      case 'Escape':
        setIsOpen(false);
        break;
    }
  };

  const getIcon = (type: SearchResult['type']) => {
    switch (type) {
      case 'agent': return <Bot className="h-4 w-4" />;
      case 'workflow': return <Zap className="h-4 w-4" />;
      case 'department': return <Building2 className="h-4 w-4" />;
    }
  };

  return (
    <div className="relative">
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
        <input
          ref={inputRef}
          type="text"
          placeholder="Search agents, workflows..."
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          onKeyDown={handleKeyDown}
          onFocus={() => query.length >= 2 && setIsOpen(true)}
          className="w-full pl-10 pr-10 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
        />
        {query && (
          <button
            onClick={() => { setQuery(''); setIsOpen(false); }}
            className="absolute right-3 top-1/2 -translate-y-1/2"
          >
            <X className="h-4 w-4 text-gray-400" />
          </button>
        )}
      </div>

      {/* Results Dropdown */}
      {isOpen && (
        <div className="absolute top-full left-0 right-0 mt-1 bg-white border rounded-lg shadow-lg z-50 max-h-80 overflow-y-auto">
          {/* Group by type */}
          {['agent', 'workflow', 'department'].map(type => {
            const typeResults = results.filter(r => r.type === type);
            if (typeResults.length === 0) return null;

            return (
              <div key={type}>
                <div className="px-3 py-2 text-xs font-semibold text-gray-500 uppercase bg-gray-50">
                  {type}s
                </div>
                {typeResults.map((result, idx) => {
                  const globalIdx = results.indexOf(result);
                  return (
                    <button
                      key={result.id}
                      onClick={() => {
                        router.push(result.href);
                        setQuery('');
                        setIsOpen(false);
                      }}
                      className={cn(
                        "w-full flex items-center gap-3 px-3 py-2 text-left hover:bg-gray-100",
                        globalIdx === selectedIndex && "bg-gray-100"
                      )}
                    >
                      {getIcon(result.type)}
                      <div>
                        <div className="font-medium">{result.title}</div>
                        {result.subtitle && (
                          <div className="text-sm text-gray-500">{result.subtitle}</div>
                        )}
                      </div>
                    </button>
                  );
                })}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
```

#### Step 2.4: Add Keyboard Shortcut (30 min)

```typescript
// Add to SearchCommand component
useEffect(() => {
  const handleGlobalKeyDown = (e: KeyboardEvent) => {
    // Cmd+K or Ctrl+K to focus search
    if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
      e.preventDefault();
      inputRef.current?.focus();
    }
  };

  document.addEventListener('keydown', handleGlobalKeyDown);
  return () => document.removeEventListener('keydown', handleGlobalKeyDown);
}, []);
```

### Testing Checklist
- [ ] Typing shows relevant results after 2+ characters
- [ ] Results grouped by type (Agents, Workflows, Departments)
- [ ] Arrow keys navigate through results
- [ ] Enter selects and navigates to result
- [ ] Escape closes dropdown
- [ ] Clicking result navigates correctly
- [ ] Cmd/Ctrl+K focuses search input
- [ ] Clear button (X) works

---

## Issue 3: Notification Bell No Dropdown

### Problem Description
The notification bell icon shows a badge but clicking it doesn't open a notifications panel.

### Solution Architecture

```
┌────────────────────────────────────┐
│ 🔔 Notifications              Mark │
│                              all   │
├────────────────────────────────────┤
│ 🔴 LinkedIn scraping agent offline │
│    1 hour ago                      │
├────────────────────────────────────┤
│ 🟡 Marketing ROI below target      │
│    2 min ago                       │
├────────────────────────────────────┤
│ 🟢 Email list reached 2,847        │
│    15 min ago                      │
├────────────────────────────────────┤
│ 🔵 New lead: Marriott Hotels       │
│    2 hours ago                     │
├────────────────────────────────────┤
│         View All Notifications     │
└────────────────────────────────────┘
```

### Implementation Steps

#### Step 3.1: Create Notification Types (20 min)

**File:** `frontend_v1/types/notifications.ts`

```typescript
export type NotificationPriority = 'critical' | 'high' | 'medium' | 'low';

export interface Notification {
  id: string;
  title: string;
  message?: string;
  priority: NotificationPriority;
  timestamp: Date;
  read: boolean;
  href?: string;
}
```

#### Step 3.2: Create Notifications Store (30 min)

**File:** `frontend_v1/stores/notifications.ts`

```typescript
import { create } from 'zustand';
import { Notification } from '@/types/notifications';

interface NotificationsStore {
  notifications: Notification[];
  unreadCount: number;
  markAsRead: (id: string) => void;
  markAllAsRead: () => void;
  addNotification: (notification: Omit<Notification, 'id' | 'read'>) => void;
}

export const useNotifications = create<NotificationsStore>((set, get) => ({
  notifications: [
    {
      id: '1',
      title: 'LinkedIn scraping agent offline',
      priority: 'critical',
      timestamp: new Date(Date.now() - 3600000),
      read: false,
    },
    {
      id: '2',
      title: 'Marketing ROI below target (12x vs 15x)',
      priority: 'high',
      timestamp: new Date(Date.now() - 120000),
      read: false,
    },
    // ... more notifications
  ],

  unreadCount: computed(() => get().notifications.filter(n => !n.read).length),

  markAsRead: (id) => set((state) => ({
    notifications: state.notifications.map(n =>
      n.id === id ? { ...n, read: true } : n
    ),
  })),

  markAllAsRead: () => set((state) => ({
    notifications: state.notifications.map(n => ({ ...n, read: true })),
  })),

  addNotification: (notification) => set((state) => ({
    notifications: [
      { ...notification, id: crypto.randomUUID(), read: false },
      ...state.notifications,
    ],
  })),
}));
```

#### Step 3.3: Create Notification Dropdown Component (1.5 hours)

**File:** `frontend_v1/components/notification-dropdown.tsx`

```typescript
'use client';

import { useState, useRef, useEffect } from 'react';
import { Bell, X } from 'lucide-react';
import { formatDistanceToNow } from 'date-fns';
import { useNotifications } from '@/stores/notifications';
import { cn } from '@/lib/utils';

const priorityColors = {
  critical: 'bg-red-500',
  high: 'bg-orange-500',
  medium: 'bg-green-500',
  low: 'bg-blue-500',
};

export function NotificationDropdown() {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const { notifications, unreadCount, markAsRead, markAllAsRead } = useNotifications();

  // Close on click outside
  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bell Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="relative p-2 rounded-lg hover:bg-gray-100"
        aria-label="Notifications"
      >
        <Bell className="h-5 w-5" />
        {unreadCount > 0 && (
          <span className="absolute -top-1 -right-1 h-5 w-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center">
            {unreadCount > 9 ? '9+' : unreadCount}
          </span>
        )}
      </button>

      {/* Dropdown Panel */}
      {isOpen && (
        <div className="absolute right-0 top-full mt-2 w-80 bg-white border rounded-lg shadow-lg z-50">
          {/* Header */}
          <div className="flex items-center justify-between px-4 py-3 border-b">
            <h3 className="font-semibold">Notifications</h3>
            {unreadCount > 0 && (
              <button
                onClick={markAllAsRead}
                className="text-sm text-primary hover:underline"
              >
                Mark all read
              </button>
            )}
          </div>

          {/* Notifications List */}
          <div className="max-h-80 overflow-y-auto">
            {notifications.length === 0 ? (
              <div className="p-4 text-center text-gray-500">
                No notifications
              </div>
            ) : (
              notifications.slice(0, 5).map((notification) => (
                <div
                  key={notification.id}
                  onClick={() => markAsRead(notification.id)}
                  className={cn(
                    "flex items-start gap-3 px-4 py-3 hover:bg-gray-50 cursor-pointer border-b last:border-b-0",
                    !notification.read && "bg-blue-50"
                  )}
                >
                  <span className={cn(
                    "h-2 w-2 rounded-full mt-2 flex-shrink-0",
                    priorityColors[notification.priority]
                  )} />
                  <div className="flex-1 min-w-0">
                    <p className={cn(
                      "text-sm",
                      !notification.read && "font-medium"
                    )}>
                      {notification.title}
                    </p>
                    <p className="text-xs text-gray-500 mt-1">
                      {formatDistanceToNow(notification.timestamp, { addSuffix: true })}
                    </p>
                  </div>
                </div>
              ))
            )}
          </div>

          {/* Footer */}
          <div className="border-t px-4 py-3">
            <button className="w-full text-sm text-primary hover:underline">
              View All Notifications
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
```

### Testing Checklist
- [ ] Bell icon shows unread count badge
- [ ] Clicking bell opens dropdown
- [ ] Notifications show with correct priority colors
- [ ] Timestamps display relative time
- [ ] Clicking notification marks as read
- [ ] "Mark all read" clears unread count
- [ ] Clicking outside closes dropdown
- [ ] Unread notifications have different background

---

## Issue 4: Quick Actions Not Wired

### Problem Description
Quick Action buttons (Launch Marketing Campaign, Deploy Sales Persona, Create Workflow, View Reports) are clickable but don't trigger any actions.

### Solution Architecture

Each Quick Action should open a modal dialog for the respective action.

### Implementation Steps

#### Step 4.1: Create Action Modals (2 hours)

**File:** `frontend_v1/components/quick-actions/launch-campaign-modal.tsx`

```typescript
'use client';

import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select } from '@/components/ui/select';
import { useState } from 'react';

interface LaunchCampaignModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export function LaunchCampaignModal({ isOpen, onClose }: LaunchCampaignModalProps) {
  const [campaignName, setCampaignName] = useState('');
  const [campaignType, setCampaignType] = useState('');

  const handleSubmit = async () => {
    // TODO: Integrate with backend/n8n workflow
    console.log('Launching campaign:', { campaignName, campaignType });
    onClose();
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Launch Marketing Campaign</DialogTitle>
        </DialogHeader>

        <div className="space-y-4 py-4">
          <div className="space-y-2">
            <Label htmlFor="name">Campaign Name</Label>
            <Input
              id="name"
              placeholder="Q1 Product Launch"
              value={campaignName}
              onChange={(e) => setCampaignName(e.target.value)}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="type">Campaign Type</Label>
            <Select value={campaignType} onValueChange={setCampaignType}>
              <option value="">Select type...</option>
              <option value="email">Email Campaign</option>
              <option value="social">Social Media</option>
              <option value="content">Content Marketing</option>
              <option value="ppc">PPC Advertising</option>
            </Select>
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button onClick={handleSubmit} disabled={!campaignName || !campaignType}>
            Launch Campaign
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
```

#### Step 4.2: Create Quick Actions Context (1 hour)

**File:** `frontend_v1/contexts/quick-actions-context.tsx`

```typescript
'use client';

import { createContext, useContext, useState, ReactNode } from 'react';

type QuickActionType = 'launch-campaign' | 'deploy-persona' | 'create-workflow' | 'view-reports' | null;

interface QuickActionsContextType {
  activeAction: QuickActionType;
  openAction: (action: QuickActionType) => void;
  closeAction: () => void;
}

const QuickActionsContext = createContext<QuickActionsContextType | undefined>(undefined);

export function QuickActionsProvider({ children }: { children: ReactNode }) {
  const [activeAction, setActiveAction] = useState<QuickActionType>(null);

  return (
    <QuickActionsContext.Provider
      value={{
        activeAction,
        openAction: setActiveAction,
        closeAction: () => setActiveAction(null),
      }}
    >
      {children}

      {/* Render modals */}
      <LaunchCampaignModal
        isOpen={activeAction === 'launch-campaign'}
        onClose={() => setActiveAction(null)}
      />
      <DeployPersonaModal
        isOpen={activeAction === 'deploy-persona'}
        onClose={() => setActiveAction(null)}
      />
      <CreateWorkflowModal
        isOpen={activeAction === 'create-workflow'}
        onClose={() => setActiveAction(null)}
      />
      <ViewReportsModal
        isOpen={activeAction === 'view-reports'}
        onClose={() => setActiveAction(null)}
      />
    </QuickActionsContext.Provider>
  );
}

export const useQuickActions = () => {
  const context = useContext(QuickActionsContext);
  if (!context) throw new Error('useQuickActions must be used within QuickActionsProvider');
  return context;
};
```

#### Step 4.3: Update Quick Actions Component (30 min)

**File:** `frontend_v1/components/quick-actions.tsx`

```typescript
'use client';

import { Monitor, Users, Workflow, FileBarChart } from 'lucide-react';
import { useQuickActions } from '@/contexts/quick-actions-context';

const actions = [
  { id: 'launch-campaign', label: 'Launch Marketing Campaign', icon: Monitor },
  { id: 'deploy-persona', label: 'Deploy Sales Persona', icon: Users },
  { id: 'create-workflow', label: 'Create Workflow', icon: Workflow },
  { id: 'view-reports', label: 'View Reports', icon: FileBarChart },
] as const;

export function QuickActions() {
  const { openAction } = useQuickActions();

  return (
    <div className="space-y-2">
      <h3 className="font-semibold flex items-center gap-2">
        <Zap className="h-5 w-5" />
        Quick Actions
      </h3>

      <div className="space-y-1">
        {actions.map(({ id, label, icon: Icon }) => (
          <button
            key={id}
            onClick={() => openAction(id)}
            className="w-full flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-gray-100 text-left"
          >
            <Icon className="h-4 w-4" />
            <span>{label}</span>
          </button>
        ))}
      </div>
    </div>
  );
}
```

### Testing Checklist
- [ ] Each Quick Action button opens appropriate modal
- [ ] Modals can be closed via X button or clicking outside
- [ ] Form validation works (required fields)
- [ ] Submit button disabled when form incomplete
- [ ] Cancel button closes modal without action

---

## Issue 5: Agent Status Data Inconsistency

### Problem Description
Agent status badges (Active/Idle/Error) change inconsistently when navigating between views. For example, Data Insights Agent showed "Error" then "Active" on subsequent views.

### Root Cause Analysis
1. Status data may be randomly generated on each render
2. No centralized state management for agent data
3. Possible race conditions in data fetching

### Solution

#### Step 5.1: Create Centralized Agent Store (1 hour)

**File:** `frontend_v1/stores/agents.ts`

```typescript
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

export type AgentStatus = 'active' | 'idle' | 'error';

export interface Agent {
  id: string;
  name: string;
  department: string;
  status: AgentStatus;
  workflows: Workflow[];
  tools: string[];
}

interface AgentsStore {
  agents: Agent[];
  isLoading: boolean;
  error: string | null;
  fetchAgents: () => Promise<void>;
  updateAgentStatus: (id: string, status: AgentStatus) => void;
  getAgentsByDepartment: (department: string) => Agent[];
  getStatusCounts: () => { active: number; idle: number; error: number };
}

export const useAgents = create<AgentsStore>()(
  persist(
    (set, get) => ({
      agents: [],
      isLoading: false,
      error: null,

      fetchAgents: async () => {
        set({ isLoading: true, error: null });
        try {
          // TODO: Replace with actual API call
          const response = await fetch('/api/agents');
          const agents = await response.json();
          set({ agents, isLoading: false });
        } catch (error) {
          set({ error: 'Failed to fetch agents', isLoading: false });
        }
      },

      updateAgentStatus: (id, status) => {
        set((state) => ({
          agents: state.agents.map((agent) =>
            agent.id === id ? { ...agent, status } : agent
          ),
        }));
      },

      getAgentsByDepartment: (department) => {
        return get().agents.filter((agent) => agent.department === department);
      },

      getStatusCounts: () => {
        const agents = get().agents;
        return {
          active: agents.filter((a) => a.status === 'active').length,
          idle: agents.filter((a) => a.status === 'idle').length,
          error: agents.filter((a) => a.status === 'error').length,
        };
      },
    }),
    {
      name: 'agents-storage',
      partialize: (state) => ({ agents: state.agents }),
    }
  )
);
```

#### Step 5.2: Update Components to Use Store (30 min)

Update all components that display agent data to use `useAgents()` store instead of local state or prop-drilled data.

### Testing Checklist
- [ ] Agent status persists across page navigation
- [ ] System Status counts match actual agent statuses
- [ ] Refreshing page maintains consistent state
- [ ] All views show same status for same agent

---

## Implementation Timeline

### Day 1: Mobile Responsive (P0)
- [ ] Morning: Steps 1.1-1.3 (Mobile navigation state, hamburger, sidebar)
- [ ] Afternoon: Steps 1.4-1.5 (Layout updates, hooks)
- [ ] Testing and refinement

### Day 2: Search & Notifications (P1)
- [ ] Morning: Issue 2 - Search functionality
- [ ] Afternoon: Issue 3 - Notification dropdown
- [ ] Testing both features

### Day 3: Quick Actions & Data Consistency (P2)
- [ ] Morning: Issue 4 - Quick Actions modals
- [ ] Afternoon: Issue 5 - Agent data store
- [ ] Integration testing

### Day 4: Polish & QA
- [ ] Cross-browser testing
- [ ] Accessibility review
- [ ] Performance optimization
- [ ] Documentation updates

---

## Dependencies

### New Packages Required

```bash
# State management
pnpm add zustand

# Date formatting (if not present)
pnpm add date-fns

# Dialog components (if not using shadcn)
pnpm add @radix-ui/react-dialog
```

### Existing Dependencies Used
- Next.js 15
- React 19
- Tailwind CSS
- Radix UI (shadcn/ui)
- Lucide React icons

---

## Success Criteria

| Metric | Target |
|--------|--------|
| Mobile Lighthouse Score | > 90 |
| Desktop Lighthouse Score | > 95 |
| Time to Interactive (Mobile) | < 3s |
| Search Response Time | < 100ms |
| Zero Layout Shift on Mobile | CLS < 0.1 |

---

## Post-Implementation

1. **Update Test Suite**: Add unit tests for new components
2. **Update Documentation**: Document new features in user guide
3. **Monitor**: Track usage analytics for new features
4. **Iterate**: Gather feedback and refine UX

---

*Last Updated: 2026-01-30*
*Author: Claude Code*
