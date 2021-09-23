import UIKit
import CoreData

class ReportsViewController: UITableViewController {
  var report: Report
  var emptyReportView = EmptyReportView()
  let maxDatePicker = UIDatePicker()
  let minDatePicker = UIDatePicker()
  var dateFilterView: DateFilterView?
  
  init() {
    self.report = Report(minDate: Date(), maxDate: Date())
    super.init(nibName: nil, bundle: nil)
  }
  init(report: Report) {
    self.report = report
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Reports"
    view.backgroundColor = .secondarySystemBackground
    
    view.addSubview(emptyReportView)
    emptyReportView.snp.makeConstraints({
      $0.center.equalToSuperview()
    })
    emptyReportView.isHidden = true
    
    maxDatePicker.preferredDatePickerStyle = .compact
    maxDatePicker.datePickerMode = .date
    maxDatePicker.date = report.maxDate
    maxDatePicker.addTarget(self, action: #selector(maxDatePickerChanged(_:)), for: .valueChanged)
    
    
    minDatePicker.preferredDatePickerStyle = .compact
    minDatePicker.datePickerMode = .date
    minDatePicker.date = report.minDate
    minDatePicker.addTarget(self, action: #selector(minDatePickerChanged(_:)), for: .valueChanged)
    
    dateFilterView = DateFilterView(minDatePicker: minDatePicker, maxDatePicker: maxDatePicker)
    
    report = Report(minDate: minDatePicker.date, maxDate: maxDatePicker.date)
    
    report.refreshCalculations()
    refreshTable()
  }
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    dateFilterView
  }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return dateFilterView?.fixedHeight ?? 0
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    report.refreshCalculations()
    refreshTable()
  }
  
  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    report.numberOfRows
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
    
    cell.textLabel?.text = report.categoryName(row: indexPath.row)
    cell.textLabel?.numberOfLines = 0
    cell.detailTextLabel?.text = report.amountFormatted(row: indexPath.row)
    
    return cell
  }
  
  // MARK: - Actions
  @objc func minDatePickerChanged(_ datePicker: UIDatePicker) {
    report.change(minDate: datePicker.date)
    refreshTable()
  }
  @objc func maxDatePickerChanged(_ datePicker: UIDatePicker) {
    report.change(maxDate: datePicker.date)
    refreshTable()
  }
  
  // MARK: - Private
  private func refreshTable() {
    tableView.reloadData()
    showEmptyStateIfNeeded()
  }
  private func showEmptyStateIfNeeded() {
    emptyReportView.isHidden = report.numberOfRows > 0
  }
}
