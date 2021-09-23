import Foundation

struct DraftExpense {
  var name: String?
  var amount: Decimal = 0.0
  var date: Date?
  var category: ExpenseCategory?
  
  func isValid() -> Bool {
    return amount > 0.0 && date != nil
  }
  @discardableResult func savePermanently() -> Expense {
    let db = DataStore.shared.db
    
    let newExpense = Expense.init(context: db)
    newExpense.name = name
    newExpense.amount = NSDecimalNumber(decimal: amount)
    newExpense.date = date ?? Date()
    newExpense.category = category
    
    try! db.save()
    
    return newExpense
  }
}
