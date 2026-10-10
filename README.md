# ShareLiving3

ShareLiving3 is the Assignment 3 continuation of the original **ShareLiving** project.

This repository was created as a **new Xcode project** for Assignment 3. It keeps the original ShareLiving concept while extending it with persistent storage, a clearer domain architecture, system extensions, additional business logic, and expanded unit testing.

> For the original project concept, earlier design decisions, and previous implementation, see the previous ShareLiving repository:  
> **[ShareLiving – Previous Project](https://github.com/Trodean/SharedLiving)**


## Overview

ShareLiving is designed to help people living in the same household coordinate everyday responsibilities.

The app focuses on:

- Shared expenses
- Chores
- Grocery items
- Household members
- Household communication

Assignment 3 expands the previous version with Core Data persistence, repository-based data access, domain Use Cases, monthly settlement logic, WidgetKit, a Share Extension, App Group communication, deep linking, and additional unit testing.

## Main Features

### Shared Expenses

Users can record shared household expenses with:
- Title
- Amount
- Category
- Payer
- Participating housemates
- Share portions
- Date

The application combines all relevant expenses for the month into each housemate's **net balance** and generates a simplified repayment plan.

Example:

```text
Jason → Yang   $10.00
```

The Expenses screen also shows the current user's balance as:

- **You owe**
- **You are owed**
- **You're settled**

### Chores

Users can assign chores to household members and mark them as completed.

Chores are organised into:

- Overdue
- Today
- Upcoming
- All Chores

A predicate-based Core Data query retrieves incomplete chores due by a specified date.

### Grocery List

The Grocery section provides a simple shared shopping list grouped into:

- Urgent
- Non-urgent

Each item displays its quantity and assigned household member.

### Household Members

The current demonstration household includes 6 different people.

These members use fixed UUID values so persisted Core Data records continue to refer to the same people after the app restarts.

## Household Board

Assignment 3 introduces a new **Household Board** for lightweight household notices shared from other apps through the Share Extension.

A board post can include:

- Optional note
- Source text
- Web URL
- Category
- Created date
- Open / resolved status

Available categories:

- Notice
- Shopping
- Reminder
- Bill
- Other

Users can view, resolve, reopen, and delete posts.

The Household Board is an app-local feature. App Group storage is used to pass board-post data between the Share Extension and the main ShareLiving app.


## Core Data Persistence

ShareLiving3 uses **Core Data** as its primary persistence layer.

The data model includes related entities such as:

- `HouseholdEntity`
- `HousemateEntity`
- `SharedExpensesEntity`
- `ExpenseShareEntity`
- `ChoreEntity`
- `MonthlySettlementEntity`

Relationships connect households, members, expenses, shares, payers, chores, and assignees.

Expenses and chores persist between app launches.


## Architecture

ShareLiving3 separates the UI, business logic, and persistence layers.

```text
SwiftUI View
    ↓
ViewModel
    ↓
Use Case
    ↓
Repository Protocol
    ↓
Core Data Repository
    ↓
Core Data
```

### Views

SwiftUI Views display information, receive user interaction, and present navigation and sheets.

Views do not directly access Core Data.

### ViewModels

ViewModels prepare data for the UI and call the required Use Cases.

Examples include:

- `EViewModel`
- `ChoreViewModel`

### Use Cases

Use Cases contain domain-level business operations such as:

- Recording an expense
- Calculating a settlement plan
- Finalising a month
- Assigning a chore
- Completing a chore
- Retrieving due chores

### Repository Layer

Repository protocols separate the domain layer from Core Data.

Production repositories use Core Data, while unit tests use in-memory repository implementations. This keeps business logic testable without requiring the production database.


## Business Rules

Assignment 3 includes domain-level rules such as:

- Expense amount must be greater than zero
- An expense must contain at least one share
- All share portions must be greater than zero
- A finalised month cannot be finalised again
- An expense cannot be added to a finalised month
- Monthly expenses must be combined into net balances before repayments are generated

Typed errors are used to represent these failures.


## Monthly Repayment Plan

For each monthly expense:

1. The payer receives credit for the total amount paid.
2. Each participating housemate is assigned their portion of the expense.
3. Their portion is subtracted from their balance.
4. The process is repeated for all expenses in the month.
5. Final net balances are calculated.
6. A simplified set of repayment transfers is generated.

Example:

```text
Expense 1:
Yang pays $60
Yang and Jason split equally

Expense 2:
Jason pays $40
Yang and Jason split equally

Final result:
Jason → Yang   $10.00
```

---

## WidgetKit Extension

ShareLiving3 includes three WidgetKit configurations.

### Chores Due

**Family:** Small

Displays the current number of due chores.

Tapping the widget opens the Chores section.

```text
shareliving3://chores
```

### Repayments

**Family:** Small

Displays the current number of repayment transfers.

Tapping the widget opens the Expenses section.

```text
shareliving3://expenses
```

### Household Summary

**Family:** Medium

Displays both:

- Chores due
- Repayment count

Each area opens the relevant section of the main app.

### Widget Data Sharing

The main app and Widget Extension communicate through an **App Group**.

The main app writes shared values for:

- Due chore count
- Repayment count

When relevant data changes, the application requests WidgetKit to reload its timelines.


## Share Extension

ShareLiving3 includes a system Share Extension.

The extension allows content from apps such as Safari to be sent into ShareLiving.

Supported shared content includes:

- Text
- Web URLs

Before posting, the user can:

- Add an optional note
- Select a Household Board category

The extension saves the post to the shared App Group container, and the main app reads the same data into the Household Board.


## App Group

The main app, Widget Extension, and Share Extension use an App Group to exchange small amounts of shared data.

The App Group is used for:

- Widget summary data
- Household Board posts from the Share Extension

Core Data remains the primary persistence layer for the main application.


## Testing

Assignment 3 includes unit tests focused on business logic and repository behaviour.

Tests use in-memory repositories instead of the production Core Data store.

Test coverage includes:

- Incomplete chores due today
- Completed chores being excluded
- Future chores being excluded
- Monthly finalisation
- Prevention of duplicate monthly finalisation
- Repository settlement status
- Prevention of expenses being added to a finalised month
- Repayment plan calculation
- Balanced repayment scenarios


## How to Run

1. Clone this repository.
2. Open the ShareLiving3 Xcode project.
3. Select the **ShareLiving3** scheme.
4. Choose an iPhone Simulator.
5. Run the project.


## How to Test the Widgets

1. Launch ShareLiving3.
2. Create relevant expense or chore data.
3. Return to the Simulator Home Screen.
4. Enter Home Screen edit mode.
5. Add a ShareLiving widget.
6. Choose one of the available configurations:
   - Chores Due
   - Repayments
   - Household Summary

The widget should update when the corresponding app data changes.


## How to Test the Share Extension

1. Run ShareLiving3 at least once.
2. Open Safari in the Simulator.
3. Open a webpage.
4. Tap the system Share button.
5. Select ShareLiving.
6. Add an optional note.
7. Choose a category if required.
8. Post the content.
9. Open ShareLiving.
10. Open the Household Board.

The shared content should appear as a Household Board post.


## Assignment 3 Improvements

Compared with the previous ShareLiving version, ShareLiving3 introduces:

- A new Xcode project and GitHub repository
- Core Data persistence
- Related Core Data entities
- Repository protocols
- Core Data repository implementations
- Domain Use Cases
- Typed domain errors
- Business rule validation
- Predicate-based chore queries
- Monthly settlement finalisation
- Net-balance repayment planning
- WidgetKit extension
- Small and Medium widgets
- Widget deep linking
- Share Extension
- Household Board
- App Group communication
- Expanded unit testing
- UI polished
- Custom app icon support

> **[ShareLiving – Previous Project](https://github.com/Trodean/SharedLiving)**
