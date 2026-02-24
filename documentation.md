# QRify - UI Documentation

## Overview
**QRify** is a Flutter-based QR code generator application with a modern, minimalist design. It allows users to instantly generate QR codes from URLs or text input with a clean, intuitive interface.

---

## Design System

### Color Palette

| Color Name | Hex Value | RGB Value | Usage |
|---|---|---|---|
| **Background** | `#FFFFFF` | `(255, 255, 255)` | Main app background (warm cream) |
| **Surface** | `#FAF7F2` | Lighter warm tone | Card surfaces, input fields, buttons |
| **Border** | `#E2D9CC` | Muted warm brown | Dividers, borders, accents |
| **Primary Accent** | `#7C6A52` | Deep warm brown | Active buttons, icons, highlights |
| **Accent Soft** | `#B5A48E` | Light warm brown | Disabled states, secondary text |
| **Text Primary** | `#3A2E22` | Deep warm brown | Main headings, primary text |
| **Text Secondary** | `#8C7D6B` | Muted warm brown | Body text, descriptions |
| **Error** | `#C0392B` | Bright red | Error messages, warnings |

### Design Philosophy
- **Warm, earthy color scheme** with browns and creams
- **Minimal and clean** aesthetic
- **High contrast** for readability
- **Consistent spacing** and rounded corners (8-16px radius)

---

## UI Components & Features

### 1. **Header Section**
Located at the top of the screen with spacing of 36px from top.

**Elements:**
- **App Logo**: 40×40px container with warm brown background (`_accent`), containing a QR code icon (22px) in white
- **App Title**: "QRify" text
  - Font: 26px, weight: 700 (bold)
  - Color: Deep warm brown (`_textPrimary`)
  - Letter spacing: -0.3px
- **Clear Button** (conditional, appears when QR is generated):
  - Floating action button on the right
  - Padding: 14px horizontal, 7px vertical
  - Background: Light surface color with border
  - Text: "Clear" in secondary grey
  - Border radius: 20px (pill-shaped)

**Subtitle:**
- Text: "Generate QR codes instantly"
- Font size: 13px
- Color: Secondary text
- Spacing: 6px below logo

---

### 2. **Input Section**

#### Input Label
- Text: "URL OR TEXT" (all caps)
- Font size: 11px, weight: 600
- Letter spacing: 0.8px
- Color: Secondary text
- Margin bottom: 8px

#### Text Input Field
**Container Properties:**
- Background: Light surface (`_surface`)
- Border: 1px solid muted warm border (`_border`)
- Border radius: 12px
- Padding: 14px (all sides)

**TextField Properties:**
- Min lines: 1
- Max lines: 3
- Font size: 15px
- Line height: 1.5
- Color: Primary text
- Placeholder text: "https://example.com or any text…"
- Placeholder color: Soft accent (`_accentSoft`)
- Cursor color: Primary accent (`_accent`)
- Clear button: Small 'X' icon appears when field is not empty

---

### 3. **Error Message Display**
Appears conditionally below the input field when validation fails.

**Properties:**
- Icon: Info outline (15px) in error red
- Font size: 13px
- Color: Error red (`#C0392B`)
- Spacing above: 10px
- Layout: Row with icon + expandable text

**Error Messages:**
- "Please enter some text or a URL."
- "Request timed out. Please try again."
- "Server error (XXX)." (Status code included)
- "Network error. Check your connection."
- "Failed to generate QR code."
- "An unexpected error occurred."

---

### 4. **Generate Button**
**Location:** Below error message, with 18px spacing above

**Properties:**
- Width: 100% (full width)
- Height: 52px
- Background color: Primary accent (`_accent`)
- Disabled background: Soft accent (`_accentSoft`)
- Border radius: 12px
- Elevation: 0 (flat)

**Button States:**

| State | Content | Color |
|---|---|---|
| **Loading** | Circular progress indicator (20×20px) | White |
| **Active** | Icon + Text | White |
| **Disabled** | Icon + Text (faded) | White |

**Content:**
- Icon: QR code icon (19px) + 8px spacing
- Text: "Generate QR Code"
- Font size: 15px, weight: 600

---

### 5. **Divider Section**
- Height: 1px
- Color: Border color (`_border`)
- Vertical margin: 32px above, 28px below

---

### 6. **QR Result Display** (Conditional)

#### Header Status
When QR is generated, shows:
- Small dot indicator (6×6px) in primary color
- Text: "QR CODE READY" (all caps)
- Font size: 11px, weight: 600
- Letter spacing: 0.8px
- Spacing below: 18px

#### QR Container
**Properties:**
- Background: Light surface (`_surface`)
- Border: 1px solid muted border
- Border radius: 16px
- Padding: 24px (all sides)
- Margin below: 40px

**Contents:**

##### QR Image
- Displayed in white frame container
- Inner padding: 14px
- Border radius: 10px
- Size: 210×210px
- Border: 1px light border
- Gapless playback enabled

##### Data Preview Section
Located 18px below QR image

**Properties:**
- Full width
- Padding: 12px horizontal, 10px vertical
- Background: Main background color
- Border: 1px muted border
- Border radius: 8px
- Layout: Horizontal row

**Content:**
- Left side: Generated text/URL (monospace font, 12px)
  - Max lines: 2
  - Overflow: Ellipsis
- 8px spacing
- Copy button (right side):
  - Size: 6×6px padding
  - Icon: Copy icon (15px) in secondary color
  - Background: Light surface
  - Border: 1px border
  - Border radius: 6px

---

### 7. **Empty State Display** (When no QR generated)

**Layout:** Centered column

**Elements:**
- Icon container (72×72px)
  - Background: Light surface
  - Border: 1px muted border
  - Border radius: 16px
  - Icon: QR code 2 (36px) in muted border color
- Spacing: 14px
- Text: "Your QR code will appear here"
  - Font size: 13px
  - Color: Soft accent (muted)
- Bottom spacing: 40px

---

## Layout & Spacing

### Safe Area & Padding
- Horizontal padding: 24px (left & right)
- Vertical spacing from top: 36px initial

### Standard Spacings Used
- Extra large: 40px
- Large: 36px, 32px
- Medium: 28px, 18px
- Standard: 14px, 12px
- Small: 10px, 8px, 6px

---

## Typography

### Font Weights
- **Bold (700)**: App title, button text, labels
- **Semi-bold (600)**: Section headings, status text
- **Regular (400)**: Body text, error messages, hints

### Font Sizes
| Size | Usage |
|---|---|
| 26px | App title |
| 15px | Input text, button text |
| 13px | Descriptions, error messages, empty state |
| 12px | Data preview, monospace text |
| 11px | Labels, status indicators |

---

## Interactions & States

### TextField States
- **Empty**: Shows placeholder text and hint
- **Focused**: Cursor visible, text input active
- **Filled**: Display input text, show close button
- **Error**: Display error message below, text remains visible

### Button States
- **Active**: Full opacity, click enabled
- **Loading**: Shows spinner, clicks disabled
- **Disabled**: Reduced opacity, clicks disabled

### Snackbar (Copy Confirmation)
- Background: Light surface
- Text color: Primary text
- Duration: 2 seconds
- Position: Floating
- Border radius: 10px
- Border: 1px muted border
- Elevation: 2

---

## Technical Details

### Framework
- **Flutter** with Material Design 3

### HTTP Client
- **Dio** for API requests
- Base URL: `http://147.93.19.205:3000/api`
- Endpoint: `/qr/generate` (POST)
- Request timeout: 15 seconds (both connect & receive)

### Data Flow
1. User enters text/URL in input field
2. Click "Generate QR Code" button
3. Loading spinner appears
4. API request sent with data
5. Response received as bytes (image)
6. QR display renders with preview
7. User can copy original data or clear

---

## Responsive Design
- **Scroll support**: `SingleChildScrollView` for vertical overflow
- **Full-width elements**: Buttons and containers use `double.infinity`
- **Fixed dimensions**: QR image (210×210px), icons (20-36px)

---

## Accessibility Features
- Clear visual hierarchy with size and color
- High contrast text against light backgrounds
- Icon + text labels on buttons
- Error messages with icons
- Focus node management for keyboard interaction

---

## Application Structure

### Main Classes

#### QRifyApp
- Root widget of the application
- Configures Material Design 3 theme
- Sets color scheme with primary accent and surface colors

#### QRGeneratorScreen
- Main stateful widget container
- Manages the overall layout and navigation

#### _QRGeneratorScreenState
- Contains all state management logic
- Handles QR generation, error handling, and clipboard operations

### State Variables
- `_controller`: TextEditingController for managing input text
- `_focusNode`: FocusNode for controlling keyboard focus
- `_qrImageBytes`: Stores the generated QR code as bytes
- `_isLoading`: Tracks API request state
- `_errorMessage`: Stores error messages for display
- `_lastGeneratedData`: Prevents duplicate API calls

### Core Methods

#### _generateQR()
Handles QR code generation:
- Validates input is not empty
- Prevents duplicate generations
- Makes API request with Dio
- Handles various error scenarios
- Updates state with response image

#### _clearAll()
Resets all state to initial values:
- Clears text input
- Removes QR image
- Clears error messages
- Resets last generated data

#### _copyToClipboard()
Copies input text to clipboard:
- Retrieves current input text
- Sets clipboard data
- Shows confirmation snackbar

---

## Error Handling

The app implements comprehensive error handling:

### Input Validation
- Checks for empty input
- Prevents duplicate API calls for same data

### Network Error Handling
- **Connection Timeout**: "Request timed out. Please try again."
- **Receive Timeout**: "Request timed out. Please try again."
- **Server Errors**: "Server error (XXX)." with status code
- **Connection Issues**: "Network error. Check your connection."

### Response Handling
- Validates HTTP 200 status code
- Checks for null response data
- Gracefully handles unexpected errors

---

## Dependencies

### Core Flutter
- `flutter/material.dart`: Material Design components
- `flutter/services.dart`: Clipboard functionality

### External Packages
- **dio**: HTTP client for API communication
- **dart/typed_data**: For Uint8List data handling

---

## API Integration

### Endpoint Details
- **Method**: POST
- **URL**: `http://147.93.19.205:3000/api/qr/generate`
- **Request Body**: `{ "data": "<user_input>" }`
- **Content-Type**: `application/json`
- **Response Type**: Bytes (image/png)

### Timeouts
- Connect Timeout: 15 seconds
- Receive Timeout: 15 seconds

---

## User Workflows

### Primary Workflow: Generate QR Code
1. User opens the app
2. Enters text or URL in the input field
3. Taps "Generate QR Code" button
4. Loading spinner appears briefly
5. QR code image appears with data preview
6. User can copy data or clear to start over

### Secondary Workflow: Copy to Clipboard
1. After generating QR code (or any time)
2. User taps the copy icon in the data preview
3. Snackbar confirms "Copied to clipboard"
4. Text remains selected for reference

### Recovery Workflow: Handle Errors
1. User sees error message displayed below input
2. Can retry generation with same or different input
3. Clear button clears the error on input change

---

## Future Enhancement Suggestions

### Potential Features
- Share QR code image
- Download QR code as PNG/PDF
- Customize QR code colors and size
- History of generated QR codes
- Batch QR generation
- Custom branding on QR codes
- Dark mode support

### Performance Improvements
- Cache generated QR codes
- Implement compression for large images
- Add local caching of API responses
- Optimize image memory usage

---

## Testing Recommendations

### Manual Testing Checklist
- [ ] Generate QR from short text
- [ ] Generate QR from long URL
- [ ] Error handling with no internet
- [ ] Copy functionality with various text lengths
- [ ] Clear button functionality
- [ ] Keyboard behavior (focus, submit)
- [ ] Responsive layout on various screen sizes
- [ ] Dark theme compatibility (if implemented)

### Unit Tests
- Input validation logic
- Error message generation
- State management transitions

### Widget Tests
- UI rendering with different states
- User interactions (tap, input)
- Layout and spacing accuracy

---

## Conclusion

QRify is a streamlined, user-friendly QR code generator that combines clean design with practical functionality. The warm, earthy color scheme creates an inviting interface, while the minimalist layout ensures focus on the core task of QR generation.
