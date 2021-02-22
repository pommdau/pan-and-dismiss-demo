//
//  ViewController.swift
//  ModalWindowDemo
//
//  Created by ForAppleStoreAccount on 2021/02/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    var photoViewController: PhotoViewController?
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.backgroundColor = .blue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoImageTapped))
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
    
    @objc func handlePhotoImageTapped() {
        photoViewController = PhotoViewController()
        guard let photoViewController = photoViewController else {
            return
        }
        
        photoViewController.modalPresentationStyle = .custom
        photoViewController.transitioningDelegate  = self
        self.present(photoViewController, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func initializeUI() {
        view.addSubview(imageView)
        imageView.setSizeAspect(widthRatio: 1.0, heightRatio: 1.0)
        imageView.setDimensions(width: 200, height: 200)
        imageView.center(inView: view)
        
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
        photoViewController?.delegate = dimmingPresentationController
        
        return dimmingPresentationController
    }

}
