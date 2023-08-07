
import Foundation
import UIKit

extension UIView{
    func fillToSuperView(margin: UIEdgeInsets = UIEdgeInsets.zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let viewSuperView = self.superview{
            if #available(iOS 9.0, *){
                self.topAnchor.constraint(equalTo: viewSuperView.topAnchor, constant: margin.top).isActive = true
                self.bottomAnchor.constraint(equalTo: viewSuperView.bottomAnchor, constant: margin.bottom).isActive = true
                self.leadingAnchor.constraint(equalTo: viewSuperView.leadingAnchor, constant: margin.left).isActive = true
                self.trailingAnchor.constraint(equalTo: viewSuperView.trailingAnchor, constant: -margin.right).isActive = true
            }
        }
    }
    
    func fixConstraintsInView(_ container: UIView) {
        
        NSLayoutConstraint.init(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint.init(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint.init(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
