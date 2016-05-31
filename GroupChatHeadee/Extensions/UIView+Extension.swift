import UIKit

extension UIView {
    
    func addCircularShadow() {
        let path = UIBezierPath(roundedRect: self.frame, cornerRadius: self.bounds.width / 2)
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.shadowRadius = 7
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowOpacity = 0.4
        layer.fillColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        layer.zPosition = -1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        if let superView = self.superview {
            superView.layer.addSublayer(layer)
        }
    }
    
    func addShadow(shadowColor: UIColor, opacity: Float, shadowRadius: Float, shadowOffset: CGSize ) {
        let path = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: self.bounds.size), cornerRadius: self.layer.cornerRadius)
        let layer = self.layer
        layer.shadowPath = path.CGPath
        layer.shadowColor = shadowColor.CGColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = CGFloat(shadowRadius)
        layer.shadowOffset = shadowOffset
    }
    
}
