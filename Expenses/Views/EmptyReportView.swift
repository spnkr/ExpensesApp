//

import UIKit
import SnapKit

class EmptyReportView: UIView {
  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    let label = UILabel()
    label.text = "No expenses found"
    label.font = .systemFont(ofSize: 16)
    label.textColor = .label
    label.sizeToFit()
    
    addSubview(label)
    
    label.snp.makeConstraints({
      $0.center.equalToSuperview()
    })
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
