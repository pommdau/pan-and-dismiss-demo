//
//  FadeOutAnimationController.swift
//  ModalWindowDemo
//
//  Created by ForAppleStoreAccount on 2021/02/21.
//

import UIKit

class SlideAnimationController: NSObject {
        
    // MARK: - Enum
    
    enum SlideAnimationStyle {
        case up
        case down
    }
    
    // MARK: - Properties
    
    private var slideAnimationStyle: SlideAnimationStyle = .down
    
    // MARK: - Lifecycle
    
    convenience init(slideAnimationStyle: SlideAnimationStyle) {
        self.init()
        self.slideAnimationStyle = slideAnimationStyle
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning

extension SlideAnimationController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    // 実行するアニメーション
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
            
            let containerView = transitionContext.containerView
            let time = transitionDuration(using: transitionContext)
            
            UIView.animate(withDuration: time, animations: {
                switch self.slideAnimationStyle {
                case .up:
                    fromView.center.y -= containerView.bounds.size.height
                case .down:
                    fromView.center.y += containerView.bounds.size.height
                }
//                fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)  // up to you
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
}
