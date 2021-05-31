//
//  UIBottonExtension.swift
//  cl2_quiroz
//
//  Created by DARK NOISE on 31/05/21.
//

import UIKit

extension UIButton {
    
    func redondeado (){
        
        layer.cornerRadius = bounds.height/2
        
        clipsToBounds = true
        
    }
    
    func saltoAnimacion (){
        
        UIView.animate(withDuration: 0.1, animations: {self.transform=CGAffineTransform.init(scaleX: 1.1, y: 1.1)}) { (completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = .identity
            })
        }
        
    }
    
}
