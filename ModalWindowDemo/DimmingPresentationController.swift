//
//  DimmingPresentationController.swift
//  ModalWindowDemo
//
//  Created by ForAppleStoreAccount on 2021/02/22.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    // The presentationTransitionWillBegin() method is invoked when the new view controller is about to be shown on the screen.
    // containerView:=SearchViewControllerのトップに位置するView
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        containerView!.insertSubview(dimmingView, at: 0)
        
        // Animate background gradient view(fade in)
        dimmingView.alpha = 0
        if let corrdinator = presentedViewController.transitionCoordinator {
            // all of your animations should be done in a closure passed to animateAlongsideTransition to keep the transition smooth.
            corrdinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            // fade outのアニメーション
            coordinator.animate(alongsideTransition: {_ in
                self.dimmingView.alpha = 0
            }, completion: nil)
        }
    }
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
}

class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        // SuperViewの大きさに合わせる設定。
        // AutoLayoutの前身の制約。協力ではないが簡単。
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // 呼ばれないがサブクラスで実装が必須なinitメソッド
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func draw(_ rect: CGRect) {
        // The first color (0, 0, 0, 0.3) is a black color that is mostly transparent.
        // The second color (0, 0, 0, 0.7) is also black but much less transparent and sits at location 1
        let components: [CGFloat] = [ 0, 0, 0, 0.3, 0, 0, 0, 0.7 ]
        let locations : [CGFloat] = [ 0, 1 ]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient   = CGGradient(colorSpace: colorSpace,
                                    colorComponents: components,
                                    locations: locations,
                                    count: 2)
        let x = bounds.midX
        let y = bounds.midY
        let centerPoint = CGPoint(x: x, y : y)
        let radius = max(x, y)

        let context = UIGraphicsGetCurrentContext()
        context?.drawRadialGradient(gradient!,
                                    startCenter: centerPoint,
                                    startRadius: 0,
                                    endCenter: centerPoint,
                                    endRadius: radius,
                                    options: .drawsAfterEndLocation)
    }
    
}
