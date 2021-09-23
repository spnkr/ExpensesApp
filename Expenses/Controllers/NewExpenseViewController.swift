import UIKit
import CoreData
import SnapKit


class NewExpenseViewController: UITableViewController, UITextViewDelegate, ExpenseCategoryCreationDelegate {
  
  var expense: DraftExpense = DraftExpense(name: nil, amount: 0.0, date: Date(), category: nil)
  var categories: [ExpenseCategory] = []
  
  // MARK: - Initialization
  override init(style: UITableView.Style) {
    super.init(style: .insetGrouped)
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  // MARK: - View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .secondarySystemBackground
    title = "New Expense"
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { _ in
      self.dismiss(animated: true)
    }))
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save, primaryAction: UIAction(handler: { _ in
      self.saveAndDismiss()
    }))
    
    reloadCategories()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    reloadCategories()
  }
  
  // MARK: - UITableViewDelegate
  override func numberOfSections(in tableView: UITableView) -> Int {
    4
  }
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
      case 0:
        return "Name"
      case 1:
        return "Amount"
      case 2:
        return "Date"
      case 3:
        return "Category"
      default:
        return ""
    }
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 3 {
      return categories.count + 1
    }
    
    return 1
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      return nameCell(forRowAt: indexPath)
    } else if indexPath.section == 1 {
      return amountCell(forRowAt: indexPath)
    } else if indexPath.section == 2 {
      return dateCell(forRowAt: indexPath)
    } else if indexPath.section == 3 {
      return categoryCell(forRowAt: indexPath)
    }
    
    return UITableViewCell()
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if indexPath.section == 3 {
      if indexPath.row == categories.count {
        let controller = NewExpenseCategoryViewController()
        controller.expenseCategoryCreationDelegate = self
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
      } else {
        let category = categories[indexPath.row]
        
        toggleAssignExpenseCategory(category)
      }
    }
  }
  
  
  // MARK: - cellForRowAt
  func nameCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "")
    
    let textInput = UITextField()
    textInput.tag = 1
    textInput.text = expense.name
    textInput.placeholder = "Description"
    textInput.font = .preferredFont(forTextStyle: .body)
    textInput.textAlignment = .natural
    textInput.keyboardType = .default
    textInput.adjustsFontSizeToFitWidth = false
    textInput.adjustsFontForContentSizeCategory = true
    textInput.clearButtonMode = .whileEditing
    
    textInput.addTarget(self, action: #selector(nameDidChange(_:)), for: .allEvents)
    cell.contentView.addSubview(textInput)
    textInput.snp.makeConstraints({
      $0.top.equalToSuperview().offset(10)
      $0.left.equalToSuperview().offset(10)
      $0.right.equalToSuperview().inset(10)
      $0.bottom.equalToSuperview().offset(10)
      $0.height.equalToSuperview().inset(10)
    })
    
    return cell
  }
  func amountCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "")
    
    let textInput = UITextField()
    textInput.tag = 2
    
    if expense.amount != 0.0 {
      textInput.text = expense.amount.description
    }
    
    textInput.placeholder = "Amount (required)"
    textInput.textAlignment = .natural
    textInput.keyboardType = .decimalPad
    textInput.adjustsFontSizeToFitWidth = false
    textInput.adjustsFontForContentSizeCategory = true
    textInput.clearButtonMode = .whileEditing
    textInput.font = .preferredFont(forTextStyle: .body)
    textInput.addTarget(self, action: #selector(amountDidChange(_:)), for: .allEvents)
    
    cell.contentView.addSubview(textInput)
    
    textInput.snp.makeConstraints({
      $0.top.equalToSuperview().offset(10)
      $0.left.equalToSuperview().offset(10)
      $0.right.equalToSuperview().inset(10)
      $0.bottom.equalToSuperview().offset(10)
      $0.height.equalToSuperview().inset(10)
    })
    
    return cell
  }
  func dateCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
    let picker = UIDatePicker()
    picker.datePickerMode = .date
    picker.preferredDatePickerStyle = .inline
    picker.addTarget(self, action: #selector(dateDidChange(_:)), for: .valueChanged)
    let cell = UITableViewCell()
    
    cell.contentView.addSubview(picker)
    
    picker.snp.makeConstraints({
      $0.top.equalToSuperview().offset(10)
      $0.left.equalToSuperview().offset(10)
      $0.right.equalToSuperview().inset(10)
      $0.bottom.equalToSuperview().offset(10)
      $0.height.equalToSuperview().inset(10)
    })
    
    return cell
  }
  func categoryCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == categories.count {
      let cell = UITableViewCell()
      cell.textLabel?.text = "Add category..."
      cell.imageView?.image = UIImage(systemName: "plus.circle")
      return cell
    } else {
      let category = categories[indexPath.row]
      let cell = UITableViewCell()
      cell.textLabel?.text = category.name
      if expense.category == category {
        cell.accessoryType = .checkmark
      } else {
        cell.accessoryType = .none
      }
      return cell
    }
  }
  
  // MARK: - ExpenseCategoryCreationDelegate
  func expenseCategoryAdded(_ category: ExpenseCategory) {
    toggleAssignExpenseCategory(category)
  }
  
  // MARK: - Actions
  func toggleAssignExpenseCategory(_ category: ExpenseCategory) {
    if expense.category == category {
      expense.category = nil
    } else {
      expense.category = category
    }
    
    reloadCategorySection()
  }
  @objc func nameDidChange(_ textField: UITextField) {
    expense.name = textField.text
  }
  @objc func amountDidChange(_ textField: UITextField) {
    let amount = NSDecimalNumber(string: textField.text, locale: Locale.current) 
    expense.amount = amount as Decimal
    //    } else {
    //      expense.amount = 0.0
    //    }
  }
  @objc func dateDidChange(_ sender: UIDatePicker) {
    expense.date = sender.date
  }
  func saveAndDismiss() {
    if save() == true {
      self.dismiss(animated: true)
    }
  }

  // MARK: - Private
  private func save() -> Bool {
    guard expense.isValid() else {
      showSaveError()
      return false
    }
    
    expense.savePermanently()
    
    return true
  }
  private func reloadCategories() {
    let db = DataStore.shared.db
    
    let fetchRequest = ExpenseCategory.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    do {
      self.categories = try db.fetch(fetchRequest)
      reloadCategorySection()
    } catch {
      NSLog("Could not refresh categories") // log to a logging framework here
    }
  }
  private func showSaveError() {
    let alert = UIAlertController(title: "Could not save", message: "Did you enter an amount?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { _ in }))
    self.present(alert, animated: true)
  }
  private func reloadCategorySection() {
    tableView.reloadSections(IndexSet(integer: 3), with: .none)
  }
  
}
