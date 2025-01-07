# Auto Confirm Customer Changes

Functionality to automatically confirm customer changes on sales documents with proper validation.

## Process Flow

```mermaid
flowchart TD
    A[User Changes Customer] --> B{Document Status?}
    B -->|Released/Pending| C[Show Message to Reopen]
    B -->|Open| D{Has Warehouse Shipments?}
    D -->|Yes| E[Show Error Message]
    D -->|No| F{Has Sales Lines?}
    F -->|Yes| G{Auto Confirm Enabled?}
    F -->|No| H{Auto Confirm Enabled?}
    G -->|Yes| I[Show Line Delete Warning]
    G -->|No| J[Show Standard Confirm]
    H -->|Yes| K[Change Customer]
    H -->|No| L[Show Standard Confirm]
    I -->|User Confirms| K
    I -->|User Cancels| M[Cancel Change]
    J -->|User Confirms| K
    J -->|User Cancels| M
    L -->|User Confirms| K
    L -->|User Cancels| M
```

## Setup

1. Open Sales & Receivables Setup
2. Enable "Auto Confirm Customer Change" toggle

## Validations

- Document must be in Open status
- No warehouse shipments can exist
- Sales line deletion warning if lines exist

## Error Messages

- Status error: "Document must be in Open status to modify..."
- Warehouse error: "Cannot change customer when warehouse shipments exist..."
- Line deletion warning: "If you change Sell-to Customer, the existing sales lines..."
