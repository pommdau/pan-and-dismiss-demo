//
//  ViewController.swift
//  ModalWindowDemo
//
//  Created by ForAppleStoreAccount on 2021/02/21.
//
/*
 [A Simple Drag Dismiss on Presented ViewController Tutorial \| by Diego Bustamante \| Better Programming \| Medium](https://medium.com/better-programming/simple-drag-dismiss-on-presented-view-controller-tutorial-5f2f44f86f7b)
 [Heroを使ったmodal viewcontrollerをドラッグ閉じるの実装 \- your3i’s blog](https://your3i.hatenablog.jp/entry/2018/04/30/145307)
 [iOS\_Apprentice\_V8\.2\.1/Practice/StoreSearch/StoreSearch/DetailViewController\.swift](https://github.com/pommdau/iOS_Apprentice_V8.2.1/blob/e5758a95fcaa5ed94bfe7bc54fe52fd62ef6ab5d/Practice/StoreSearch/StoreSearch/DetailViewController.swift)
 [【Swift】UIPresentationControllerを使ってモーダルビューを表示する](https://qiita.com/wai21/items/9b40192eb3ee07375016)
 */

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
        imageView.setSizeAspect(widthRatio: 1.0, heightRatio: 1.0)
        imageView.setDimensions(width: 100, height: 100)
        imageView.centerX(inView: view)
        imageView.anchor(top: view.topAnchor, paddingTop: 100)
        
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
