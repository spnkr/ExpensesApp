
## Screenshots
- In repo: AppDemo.mp4
- In repo: New expense screen - dark mode and dynamic type size.png
- In repo: New expense screen.png

## Features

- View list of expenses
- Add new expense
- Add new category
- Remove an expense (swipe to delete)
- View total expenses by category for a date range
- Expenses without a category are listed as uncategorized
- Empty state screens for reports and list of expenses
- Two unit tests, covering a few basic cases for the expense reports
- Supports dark mode, iPhone, iPad
- Dynamic type size support (variable text size)

## Notes

- Stores expenses and categories in Core Data
- Calculates report via a Core Data query
- Categories are unique by name - if you try to add a new category with a name already used, that's ok. It doesn't add a duplicate.
- New expenses default to the current date, unless you pick another date
- Hot code reloading (InjectionIII) is commented out


## Future improvements

- Filtering or searching on list of expenses. e.g. only show expenses in category 'Travel'
- Break up list of expenses screen UI. e.g. group list of expenses by date
- Allow viewing reports by 'last 30d', 'this quarter', and other pre-made date ranges
- Use a coordinator pattern to handle navigation between screens. For speed the view controllers handle this here. e.g. `self.navigator.open(.newExpense)`
- Additional test coverage
- Format amount text field as currency on New Expense screen
- Documentation (add inline function comments, and then run swift-doc)
