# Lab 4 – Flutter UI Fundamentals

Run the app from `lib/main.dart`. The home screen opens all five exercises.

## Exercise 5 fixes

- A `ListView` inside a `Column` needs a bounded height. The example uses `Expanded` inside a fixed-height section so the list can scroll.
- `SingleChildScrollView` lets the page scroll when the controls do not fit on a small screen.
- The counter changes inside `setState()`, which rebuilds the displayed value.
- The DatePicker is opened from the screen's valid `BuildContext`. After it closes, the selected date is saved only if the screen is still mounted.
