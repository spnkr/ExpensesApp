import XCTest
@testable import Expenses

class ExpensesTests: XCTestCase {
  
  override func setUpWithError() throws {
    let db = DataStore.shared.db
    
    db.reset()
    try! db.save()
  }
  
  /**
   Example test for reports #1. Making sure # of rows in the report is accurate.
   
   Only covers a couple use cases. In a production app, I would add coverage around dates. For example, making sure that expenses with date 1/2/2021 10:10:00 UTC are included when minDate = maxDate = 1/2/2021.
   */
  func testNumberOfRows() throws {
    let db = DataStore.shared.db
    let expectation = XCTestExpectation()
    
    db.perform {
      
      let startDate = Date().addingTimeInterval(TimeInterval(-1 * 60 * 60 * 24 * 5))
      let endDate = Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * 5))
      let now = Date()
      
      let report = Report(minDate: startDate, maxDate: endDate)
      
      XCTAssertEqual(report.numberOfRows, 0, "Nothing in the report")
      
      let travel = ExpenseCategory.create(name: "Travel")
      
      let expense = DraftExpense(name: "plane tickets", amount: 500.01, date: now, category: travel)
      expense.savePermanently()
      
      report.refreshCalculations()
      
      XCTAssertEqual(report.numberOfRows, 1)
      
      let expense2 = DraftExpense(name: "boat tickets", amount: 0.99, date: now, category: travel)
      expense2.savePermanently()
      
      report.refreshCalculations()
      
      XCTAssertEqual(report.numberOfRows, 1)
      XCTAssertEqual(report.amount(row: 0), 501)
      
      let meals = ExpenseCategory.create(name: "Meals")
      
      let expense3 = DraftExpense(name: "helicopter lunch", amount: 1.00, date: now, category: meals)
      let expense3Handle = expense3.savePermanently()
      
      report.refreshCalculations()
      
      XCTAssertEqual(report.numberOfRows, 2)
      
      expense3Handle.destroy()
      report.refreshCalculations()
      
      XCTAssertEqual(report.numberOfRows, 1)
      
      expectation.fulfill()
    }
    
  }
  
  /**
   Example test for reports #1. Making sure totals in the report are accurate.
   
   Only covers a couple use cases. In a production app, I would add coverage around dates, similar to the comment for `testNumberOfRows`.
   */
  func testAmountRows() throws {
    let db = DataStore.shared.db
    let expectation = XCTestExpectation()
    
    db.perform {
      let startDate = Date().addingTimeInterval(TimeInterval(-1 * 60 * 60 * 24 * 5))
      let endDate = Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * 5))
      let now = Date()
      
      let report = Report(minDate: startDate, maxDate: endDate)
      
      let travel = ExpenseCategory.create(name: "Travel")
      
      let expense = DraftExpense(name: "plane tickets", amount: 500.01, date: now, category: travel)
      expense.savePermanently()
      
      report.refreshCalculations()
      
      XCTAssertEqual(report.amount(row: 0), 500.01)
      
      let expense2 = DraftExpense(name: "boat tickets", amount: 0.99, date: now, category: travel)
      expense2.savePermanently()
      
      report.refreshCalculations()
      
      XCTAssertEqual(report.amount(row: 0), 501)
      
      let meals = ExpenseCategory.create(name: "Meals")
      
      let expense3 = DraftExpense(name: "helicopter lunch", amount: 1.00, date: now, category: meals)
      let expense3Handle = expense3.savePermanently()
      
      report.refreshCalculations()
      
      let total = report.amount(row: 0).adding(report.amount(row: 1))
      XCTAssertEqual(total, NSDecimalNumber(integerLiteral: 502))
      
      expense3Handle.destroy()
      report.refreshCalculations()
      
      XCTAssertEqual(report.amount(row: 0), 501)
      
      expectation.fulfill()
    }
    
  }
  
}

