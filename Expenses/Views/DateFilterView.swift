//

import UIKit
import SnapKit

class DateFilterView: UIView {
  let fixedHeight: CGFloat = 80
  
  init(minDatePicker: UIDatePicker, maxDatePicker: UIDatePicker) {
    super.init(frame: CGRect(x: 0, y: 0, width: 300, height: fixedHeight))
    backgroundColor = .secondarySystemBackground
    
    let header = UIView(frame: CGRect(x: 15, y: 15, width: 300, height: fixedHeight))
    header.backgroundColor = .quaternarySystemFill
    header.layer.cornerRadius = 12
    
    let minLabel = UILabel()
    minLabel.text = "Min date"
    minLabel.font = .systemFont(ofSize: 12)
    minLabel.sizeToFit()
    
    header.addSubview(minLabel)
    minLabel.snp.makeConstraints({
      $0.top.equalToSuperview().offset(10)
      $0.left.equalToSuperview().offset(15)
    })
    
    header.addSubview(minDatePicker)
    minDatePicker.snp.makeConstraints({
      $0.left.equalToSuperview().offset(15)
      $0.top.equalTo(minLabel.snp.bottom).offset(4)
    })
    
    let maxLabel = UILabel()
    maxLabel.text = "Max date"
    maxLabel.font = .systemFont(ofSize: 12)
    maxLabel.sizeToFit()
    
    header.addSubview(maxLabel)
    maxLabel.snp.makeConstraints({
      $0.top.equalToSuperview().offset(10)
      $0.left.equalTo(minDatePicker.snp.right).offset(20)
    })
    
    header.addSubview(maxDatePicker)
    maxDatePicker.snp.makeConstraints({
      $0.left.equalTo(minDatePicker.snp.right).offset(20)
      $0.top.equalTo(maxLabel.snp.bottom).offset(4)
    })
    
    addSubview(header)
    header.snp.makeConstraints({
      $0.left.equalToSuperview().offset(15)
      $0.right.equalToSuperview().inset(15)
      $0.top.equalToSuperview().offset(5)
      $0.bottom.equalToSuperview().inset(5)
    })
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
