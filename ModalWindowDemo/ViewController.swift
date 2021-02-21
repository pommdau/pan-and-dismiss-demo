//
//  ViewController.swift
//  ModalWindowDemo
//
//  Created by ForAppleStoreAccount on 2021/02/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
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
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
//        let controller = DetailImagePageViewController()
        let controller = SimpleViewController()
//        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
//        controller.modalPresentationStyle = .custom
//        controller.transitioningDelegate = self
        self.present(controller, animated: true, completion: nil)
//        self.navigationController?.view.mask = UIView(frame: self.view.frame)
//        self.navigationController?.view.mask?.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
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
