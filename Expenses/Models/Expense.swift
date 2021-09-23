//

import UIKit
import CoreData

extension Expense {
  var amountFormatted: String {
    get {
      let currencyFormatter = NumberFormatter()
      currencyFormatter.usesGroupingSeparator = true
      currencyFormatter.numberStyle = .currency
      currencyFormatter.locale = Locale.current
      
      return currencyFormatter.string(from: amount)!
    }
  }
  
  var dateFormatted: String {
    get {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEEE, MMM d, yyyy"
      return formatter.string(from: date)
    }
  }
  
  var textSummary: String {
    get {
      var array = ["\(dateFormatted)"]
      
      let hasCategory = category != nil && category!.name != nil
      let hasName = name != nil
      let needsLineBreak = hasName || hasCategory
      
      if needsLineBreak {
        array.append("\n")
      }
      
      if hasCategory {
        array.append("\(category!.name!)")
      }
      
      if hasCategory && hasName {
        array.append(": \(name!)")
      }
      
      if !hasCategory && hasName {
        array.append(name!)
      }
      
      return array.joined()
    }
  }
  
  func destroy() {
    let db = DataStore.shared.db
    
    db.delete(self)
    try! db.save()
  }
}
