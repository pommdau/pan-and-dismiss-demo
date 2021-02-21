//
//  ViewController.swift
//  ModalWindowDemo
//
//  Created by ForAppleStoreAccount on 2021/02/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    var simpleViewController: SimpleViewController?
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
//        iv.setDimensions(width: 36, height: 36)
        iv.layer.cornerRadius = 20
        iv.backgroundColor = .blue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        initializeUI()
        configureUI()
        
        handleProfileImageTapped()
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        simpleViewController = SimpleViewController()
        guard let simpleViewController = simpleViewController else {
            return
        }
        
        simpleViewController.modalPresentationStyle = .custom
        simpleViewController.transitioningDelegate  = self
        self.present(simpleViewController, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func initializeUI() {
        view.addSubview(imageView)
        imageView.centerY(inView: view)
        imageView.setSizeAspect(widthRatio: 1.0, heightRatio: 1.0)
        imageView.anchor(left: view.leftAnchor, right: view.rightAnchor,
                         paddingLeft: 12, paddingRight: 12)
    }
    
    private func configureUI() {
        imageView.image = UIImage(named: "zoom_saga")
    }

}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        let dimmingPresentationController = DimmingPresentationController(presentedViewController: presented,
                                                                          presenting: presenting)
        simpleViewController?.delegate = dimmingPresentationController
        
        return dimmingPresentationController
    }

}
