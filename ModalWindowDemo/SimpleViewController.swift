//
//  SimpleViewController.swift
//  ModalWindowDemo
//
//  Created by ForAppleStoreAccount on 2021/02/21.
//

import UIKit

class SimpleViewController: UIViewController {

    // MARK: - Properties
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
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
        switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                                self.sampleImageView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                               })
            case .ended:
                if viewTranslation.y < 200 {
                    UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 1,
                                   options: .curveEaseOut,
                                   animations: {
                                    self.sampleImageView.transform = .identity
                                   })
                } else {
                    dismiss(animated: true, completion: nil)
                }
            default:
                break
            }
    }

    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemOrange
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        view.addSubview(sampleImageView)
        view.addSubview(sampleImageView)
        sampleImageView.centerY(inView: view)
        sampleImageView.setSizeAspect(widthRatio: 1.0, heightRatio: 1.0)
        sampleImageView.anchor(left: view.leftAnchor, right: view.rightAnchor,
                               paddingLeft: 12, paddingRight: 12)
    }

}
