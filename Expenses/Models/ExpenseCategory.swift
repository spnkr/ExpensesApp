//

import UIKit
import CoreData

extension ExpenseCategory {
  @discardableResult class func create(name: String) -> ExpenseCategory {
    let db = DataStore.shared.db
    
    let newCategory = ExpenseCategory.init(context: db)
    newCategory.name = name
    
    try! db.save()
    
    return newCategory
  }
  
  class func isNameValid(_ name: String?) -> Bool {
    name != nil && name!.count > 0
  }
}
