import UIKit
import CoreData
import SnapKit

class NewExpenseCategoryViewController: UITableViewController {
  
  var textInput = TextFieldWithPadding()
  var expenseCategoryCreationDelegate: ExpenseCategoryCreationDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textInput.placeholder = "Category name"
    textInput.backgroundColor = .quaternarySystemFill
    textInput.layer.cornerRadius = 12
    textInput.font = .preferredFont(forTextStyle: .body)
    
    textInput.addTarget(self, action: #selector(nameDidChange(_:)), for: .allEvents)
    
    view.addSubview(textInput)
    textInput.snp.makeConstraints({
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
      $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
      $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(15)
    })
    
    view.backgroundColor = .secondarySystemBackground
    
    title = "New Category"
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { _ in
      self.dismiss(animated: true)
    }))
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save, primaryAction: UIAction(handler: { _ in
      self.save()
      self.dismiss(animated: true)
    }))
    navigationItem.rightBarButtonItem?.isEnabled = false
  }
  @objc func nameDidChange(_ textField: UITextField) {
    navigationItem.rightBarButtonItem?.isEnabled = ExpenseCategory.isNameValid(textField.text)
  }
  func save() {
    let result = ExpenseCategory.create(name: textInput.text!)
    expenseCategoryCreationDelegate?.expenseCategoryAdded(result)
  }
}

