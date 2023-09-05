//
//  CustomSlider.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 20.06.2023.
//

import UIKit

class CustomSlider: UISlider {
    
    private lazy var thumbView: UIView = UIView()
    
    @IBInspectable var trackHeight: CGFloat = 5
    @IBInspectable var thumbRadius: CGFloat = 20
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let thumb = thumbImage(radius: 0)
        setThumbImage(thumb, for: .normal)
        setThumbImage(thumb, for: .highlighted)
    }
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        // Set proper frame
        // y: radius / 2 will correctly offset the thumb
        
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        
        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Set custom track height
        // As seen here: https://stackoverflow.com/a/49428606/7235585
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
}

