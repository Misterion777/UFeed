//
//  Extension.swift
//  UFeed
//
//  Created by Ilya on 3/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit


//extension UITextView {
//    
//    /*
//    Calls provided `test` block if point is in gliph range and there is no link detected at this point.
//    Will pass in to `test` a character index that corresponds to `point`.
//    Return `self` in `test` if text view should intercept the touch event or `nil` otherwise.
//    */
//    public func hitTest(pointInGliphRange:event:test:) -> UIView? {
//        
//    }
//    
//    /*
//    Returns true if point is in text bounding rect adjusted with padding.
//    Bounding rect will be enlarged with positive padding values and decreased with negative values.
//    */
//    public func pointIsInTextRange(point:range:padding:) -> Bool
//    
//    /*
//    Returns index of character for glyph at provided point. Returns `nil` if point is out of any glyph.
//    */
//    public func charIndexForPointInGlyphRect(point:) -> Int?
//    
//}
//
//extension NSLayoutManager {
//    
//    /*
//    Returns characters range that completely fits into container.
//    */
//    public func characterRangeThatFits(textContainer:) -> NSRange
//    
//    /**
//     Returns bounding rect in provided container for characters in provided range.
//     */
//    public func boundingRectForCharacterRange(range:inTextContainer:) -> CGRect
//    
//}

extension UIView {
    
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
            
            print("Top: \(topInset)")
            print("bottom: \(bottomInset)")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
    }
    
}





