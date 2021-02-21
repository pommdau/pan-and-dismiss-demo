//
//  DetailImagePageViewController.swift
//  ModalWindowDemo
//
//  Created by ForAppleStoreAccount on 2021/02/21.
//

import UIKit

class DetailImagePageViewController: UIPageViewController {

    // MARK: - Properties

    // MARK: - Lifecycle

    init() {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: [UIPageViewController.OptionsKey.interPageSpacing : 10])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self

        configureUI()
        configureViewControllers()
    }

    // MARK: - Selectors

    // MARK: - Helpers

    private func configureUI() {
        // ViewControllers側に設定してもうまく動作しないので、仕方なくこのビューに対してhero.idを設定する
        configureViewControllers()
    }

    private func configureViewControllers() {
        let viewController = DetailImageViewController(atSelectedImageIndex: 0)
        viewController.delegate  = self
        let viewControllers = [viewController]

        setViewControllers(viewControllers,
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }
}

// MARK:- UIPageViewControllerDataSource Methods

extension DetailImagePageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController)
    -> UIViewController? {
        if let viewController = viewController as? DetailImageViewController,
           viewController.selectedImageIndex > 0 {
            let newViewController = DetailImageViewController(atSelectedImageIndex: (viewController.selectedImageIndex - 1))
            newViewController.delegate = self
            return newViewController
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? DetailImageViewController,
           (viewController.selectedImageIndex + 1) < 4 ?? 0 {
            let newViewController = DetailImageViewController(atSelectedImageIndex: (viewController.selectedImageIndex + 1))
            newViewController.delegate = self
            return newViewController
        }

        return nil
    }
}

// MARK:- DetailImageViewControllerDelegate Methods

extension DetailImagePageViewController: DetailImageViewControllerDelegate {

    func viewPannBegan() {
        
    }

    func viewPannChanged(currentPosition: CGPoint, progress: CGFloat) {

    }

    func viewPannComplated(destinationPoint: CGPoint) {
        print("DEBUG: viewPannComplated")
        dismiss(animated: true, completion: nil)
    }

    func viewPannCanceled() {
        print("DEBUG: viewPannCanceled")
    }

    func viewIsZoomed(isZooming: Bool) {
        print("viewiszoomed")
    }

}

