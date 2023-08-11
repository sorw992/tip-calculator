//
//  UIResponder+Extension.swift
//  tip-calculator
//
//  Created by Soroush on 8/11/23.
//

import UIKit

extension UIResponder {
    
    // get parent viewcontroller for uiview itlself
    var parentViewController: UIViewController? {
        // problem
        return next as? UIViewController ?? next?.parentViewController
    }
}
