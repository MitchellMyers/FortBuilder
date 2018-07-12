//
//  UserLocationAnnotationView.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 7/11/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class UserLocationAnnotationView: MKAnnotationView {
    
    var arrowImageView: UIImageView!
    
    private var kvoContext: UInt8 = 13
    
    override public init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        arrowImageView = UIImageView(image: UIImage(named: "art.scnassets/wooden_texture.png"))
        addSubview(arrowImageView)
        setupObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        arrowImageView = UIImageView(image: UIImage(named: "art.scnassets/wooden_texture.png"))
        addSubview(arrowImageView)
        setupObserver()
    }
    
    func setupObserver() {
        (annotation as? UserLocationAnnotation)?.addObserver(self, forKeyPath: "heading", options: [.initial, .new], context: &kvoContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &kvoContext {
            let userLocationAnnotation = annotation as! UserLocationAnnotation
            UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(userLocationAnnotation.heading / 180 * Double.pi))
            })
        }
    }
    
    deinit {
        (annotation as? UserLocationAnnotation)?.removeObserver(self, forKeyPath: "heading")
    }
}
