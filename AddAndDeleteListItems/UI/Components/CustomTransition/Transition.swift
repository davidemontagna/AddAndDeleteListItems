//
//  Transition.swift
//  AddAndDeleteListItems
//
//  Created by Davide Montagna on 05/10/22.
//

import UIKit

class Transition: NSObject, UIViewControllerAnimatedTransitioning {
        
    // MARK: - Properties
    
    let duration = 0.5
    var presenting = true
    var originFrame = CGRect.zero
    
    // MARK: - Public methods
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        toView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        UIView.animate(
            withDuration: duration,
            animations: {
                toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
}
