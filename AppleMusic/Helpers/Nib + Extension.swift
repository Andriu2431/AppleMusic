//
//  Nib + Extension.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 05.09.2023.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil)?.first as! T
    }
}
