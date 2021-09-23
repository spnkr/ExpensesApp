import UIKit
import CoreData

class Report {
  var data: [String: NSDecimalNumber] = [:]
  var minDate: Date
  var maxDate: Date
  
  var numberOfRows: Int {
    get {
      data.keys.count
    }
  }
  func categoryName(row: Int) -> String {
    Array(data.keys)[row]
  }
  func amount(row: Int) -> NSDecimalNumber {
    let key = categoryName(row: row)
    return data[key] ?? NSDecimalNumber(decimal: 0.0)
  }
  func amountFormatted(row: Int) -> String {
    let amount = amount(row: row)
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    
    return currencyFormatter.string(from: amount) ?? "Unknown"
  }
  
  init(minDate: Date, maxDate: Date) {
    self.minDate = minDate
    self.maxDate = maxDate
    refreshCalculations()
  }
  
  func change(minDate: Date) {
    self.minDate = minDate
    refreshCalculations()
  }
  func change(maxDate: Date) {
    self.maxDate = maxDate
    refreshCalculations()
  }
  
  func refreshCalculations() {
    let db = DataStore.shared.db
    
    let minDateParameter = Calendar.current.startOfDay(for: minDate)
    
    var maxDateParameter = Calendar.current.date(byAdding: .day, value: 1, to: maxDate)
    maxDateParameter = Calendar.current.startOfDay(for: maxDateParameter!)
    
    let expression = NSExpression(forKeyPath: "@sum.amount")
    
    let countDesc = NSExpressionDescription()
    countDesc.expression = expression
    countDesc.name = "sumAmount"
    countDesc.expressionResultType = .decimalAttributeType
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
    request.returnsObjectsAsFaults = false
    request.propertiesToGroupBy = ["category.name"]
    request.propertiesToFetch = ["category.name", countDesc]
    request.resultType = .dictionaryResultType
    
    request.sortDescriptors = [NSSortDescriptor(key: "category.name", ascending: true)]
    
    request.predicate = NSPredicate(format: "date >= %@ and date <= %@", argumentArray: [minDateParameter as NSDate, maxDateParameter! as NSDate])
    
    let result = try! db.fetch(request)
    let resultsDict = result as! [[String: Any]]
    
    self.data = [:]
    
    for item in resultsDict {
      if let sum = (item["sumAmount"] as? NSDecimalNumber) {
        data[(item["category.name"] as? String) ?? "Uncategorized"] = sum
      }
    }
    
  }
}
