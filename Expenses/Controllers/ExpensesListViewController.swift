import UIKit
import CoreData

class ExpensesListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  var fetchedResultsController:NSFetchedResultsController<Expense>?
  var emptyListView = EmptyExpenseListView()
  
  // MARK: - View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Expenses"
    
    view.backgroundColor = .secondarySystemBackground
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { _ in
      self.addNewExpense()
    }))
    
    view.addSubview(emptyListView)
    emptyListView.snp.makeConstraints({
      $0.center.equalToSuperview()
    })
    emptyListView.isHidden = true
    
    setUpDataSource()
  }
  
  // MARK: - UITableViewDelegate
  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController?.sections?.count ?? 0
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    fetchedResultsController?.sections?[section].numberOfObjects ?? 0
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let expense = fetchedResultsController?.object(at: indexPath)
    
    let cell = UITableViewCell(style: .value1, reuseIdentifier: "reuse")
    cell.textLabel?.text = expense?.textSummary
    cell.textLabel?.numberOfLines = 0
    cell.detailTextLabel?.text = expense?.amountFormatted
    
    return cell
  }
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let row = indexPath.row
    
    let config = UISwipeActionsConfiguration(actions: [
      UIContextualAction(style: .destructive, title: "Remove", handler: { _, _, _ in
        if let expense = self.fetchedResultsController?.fetchedObjects?[row] {
          expense.destroy()
        }
      })
    ])
    
    return config
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  // MARK: - NSFetchedResultsControllerDelegate
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    // future improvement: only reload changed rows. using the type parameter, or a diffable data source.
    refreshTable()
  }
  
  // MARK: - Actions
  func addNewExpense() {
    let entry = UINavigationController(rootViewController: NewExpenseViewController())
    entry.modalPresentationStyle = .fullScreen
    
    self.present(entry, animated: true)
  }
  
  // MARK: - Private
  private func setUpDataSource() {
    DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
      let db = DataStore.shared.db
      
      let request = Expense.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
      
      self?.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: db, sectionNameKeyPath: nil, cacheName: nil)
      self?.fetchedResultsController?.delegate = self
      
      try! self?.fetchedResultsController?.performFetch()
      
      self?.refreshTable()
    })
  }
  private func refreshTable() {
    tableView.reloadData()
    showEmptyStateIfNeeded()
  }
  private func showEmptyStateIfNeeded() {
    emptyListView.isHidden = (fetchedResultsController?.fetchedObjects?.count ?? 0) > 0
  }
}
