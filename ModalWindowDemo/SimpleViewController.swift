//
//  SimpleViewController.swift
//  ModalWindowDemo
//
//  Created by ForAppleStoreAccount on 2021/02/21.
//

import UIKit

protocol SimpleViewControllerDelegate: class {
    func simpleViewController(_ simpleViewController: SimpleViewController, backgroundOpacity opacity: CGFloat)
}


class SimpleViewController: UIViewController {

    // MARK: - Enum
    
    enum AnimationStyle {
        case up
        case down
    }
    
    // MARK: - Properties
    
    var viewTranslation = CGPoint(x: 0, y: 0)

    var dismissStyle = AnimationStyle.down
    
    weak var delegate: SimpleViewControllerDelegate?
    
    private var sampleImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .blue
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let progress = abs(translation.y) / view.frame.height
        
        switch sender.state {
            case .changed:
                UIView.animate(withDuration: 0.0,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                                self.sampleImageView.transform = CGAffineTransform(translationX: 0, y: translation.y)
                                self.delegate?.simpleViewController(self, backgroundOpacity: (0.85 - progress))
                               })
            case .ended:
                let velocity = sender.velocity(in: view).y
                dismissStyle = velocity >= 0 ? .down : .up
                
                if progress + abs(velocity) / view.bounds.height > 0.5 {
                    dismiss(animated: true, completion: nil)
                } else {
                    UIView.animate(
                        withDuration: 0.0,
                        delay: 0,
                        usingSpringWithDamping: 0.7,
                        initialSpringVelocity: 1,
                        options: .curveEaseOut,
                        animations: {
                            self.sampleImageView.transform = .identity
                            self.delegate?.simpleViewController(self, backgroundOpacity: (0.85 - progress))
                        })
                }
        default:
            break
        }
    }

    
    // MARK: - Helpers
    
    private func configureUI() {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        view.addSubview(sampleImageView)
        view.addSubview(sampleImageView)
        sampleImageView.centerY(inView: view)
        sampleImageView.setSizeAspect(widthRatio: 1.0, heightRatio: 1.0)
        sampleImageView.anchor(left: view.leftAnchor, right: view.rightAnchor,
                               paddingLeft: 12, paddingRight: 12)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }

}

extension SimpleViewController: UIViewControllerTransitioningDelegate {
    
    // 遷移時にアニメーションを使用する設定
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideUpAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissStyle {
        case .up:
            return SlideUpAnimationController()
        case .down:
            return SlideDownAnimationController()
        }
        
    }
}
