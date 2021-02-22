//
//  PhotoViewController.swift
//  ModalWindowDemo
//
//  Created by ForAppleStoreAccount on 2021/02/21.
//

import UIKit

protocol PhotoViewControllerDelegate: class {
    func photoViewController(_ photoViewController: PhotoViewController, didUpdateBackgroundOpacity opacity: CGFloat)
}

class PhotoViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: PhotoViewControllerDelegate?
    
    private var dismissStyle = SlideAnimationController.SlideAnimationStyle.down
    private let initialBackgroundOpacity = CGFloat(1.0)
    
    private var sampleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .blue
        
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleViewPanned(sender: UIPanGestureRecognizer) {
        
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
                            self.delegate?.photoViewController(self, didUpdateBackgroundOpacity: (self.initialBackgroundOpacity - progress))
                           })
        case .cancelled:
            self.delegate?.photoViewController(self, didUpdateBackgroundOpacity: (initialBackgroundOpacity))
            
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
                        self.delegate?.photoViewController(self, didUpdateBackgroundOpacity: self.initialBackgroundOpacity)
                    })
            }
        default:
            break
        }
    }
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.transitioningDelegate = self
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleViewPanned)))
        view.addSubview(sampleImageView)
        sampleImageView.centerY(inView: view)
        sampleImageView.setSizeAspect(widthRatio: 1.0, heightRatio: 1.0)
        sampleImageView.anchor(left: view.leftAnchor, right: view.rightAnchor,
                               paddingLeft: 50, paddingRight: 50)
        sampleImageView.image = UIImage(named: "zoom_saga")
    }
    
}

extension PhotoViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimationController(slideAnimationStyle: dismissStyle)
    }
}
