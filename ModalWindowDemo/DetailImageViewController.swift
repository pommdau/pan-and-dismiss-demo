//
//  DetailImageViewController.swift
//  ModalWindowDemo
//
//  Created by ForAppleStoreAccount on 2021/02/21.
//

import UIKit

protocol DetailImageViewControllerDelegate: class {
    func viewPannBegan()
    func viewPannChanged(currentPosition: CGPoint, progress: CGFloat)
    func viewPannComplated(destinationPoint: CGPoint)
    func viewPannCanceled()
    func viewIsZoomed(isZooming: Bool)
}

class DetailImageViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: DetailImageViewControllerDelegate?
    
    var selectedImageIndex = 0
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .blue
        return iv
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate                       = self
        scrollView.minimumZoomScale               = 0.1
        scrollView.maximumZoomScale               = 5
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator = false
        
        // ダブルタップされたときのイベントハンドリングを設定
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapSubScrollView(_:)))
        doubleTap.delegate = self  // UIGestureRecognizerDelegateを呼び出すのに必要。変にハマった。
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(didPanSubScrollView(_:)))
        viewPan.delegate = self
        scrollView.addGestureRecognizer(viewPan)
        scrollView.isUserInteractionEnabled = true
        
        return scrollView
    }()
    
    // MARK: - Lifecycle
    
    init(atSelectedImageIndex selectedImageIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.selectedImageIndex = selectedImageIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.layoutScrollView()
    }
    
    // MARK: - Selectors
    
    /// サブスクロールビューがダブルタップされた時
    @objc private func didDoubleTapSubScrollView(_ gesture: UITapGestureRecognizer) {
        guard let scrollView = gesture.view as? UIScrollView else { return }
        if scrollView.minimumZoomScale < scrollView.zoomScale {
            // 拡大されている場合は初期のサイズに戻す
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            // タップされた場所を中心に拡大する
            var tapPoint = gesture.location(in: gesture.view)
            tapPoint.x /= scrollView.zoomScale
            tapPoint.y /= scrollView.zoomScale
            
            let newScale:CGFloat = scrollView.zoomScale * 5
            let zoomRect:CGRect = zoomRectForScale(scale: newScale, center: tapPoint)
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    /// ビューが上下にスワイプされた場合
    // 拡大表示中はスワイプを無効にする
    @objc private func didPanSubScrollView(_ sender: UIPanGestureRecognizer) {
        // 拡大中はパンを無効にする
        guard let scrollView = sender.view as? UIScrollView ,
              scrollView.zoomScale <= scrollView.minimumZoomScale else { return }
        
        let translation = sender.translation(in: nil)
        
        // transitionがどこまで進んだのかのprogessを計算。
        // 上スワイプしても閉じれるようにしたいから、absを使う
        let progress = abs(translation.y / 2) / scrollView.frame.height
        
        switch sender.state {
        case .began:
            delegate?.viewPannBegan()
            print("DEBUG: began")
        case .changed:
            let currentPosition = CGPoint(x: scrollView.center.x, y: translation.y + scrollView.center.y)
            delegate?.viewPannChanged(currentPosition: currentPosition, progress: progress)
        case .ended:
            
            let velocity = sender.velocity(in: nil).y
            
            if progress + abs(velocity) / view.bounds.height > 0.5 {
                let destinationY: CGFloat = {
                    return velocity >= 0 ?
                        view.bounds.height + scrollView.bounds.size.height / 2 :
                        -scrollView.bounds.size.height / 2
                }()
                
                let destinationPos = CGPoint(x: scrollView.center.x, y: destinationY)
                delegate?.viewPannComplated(destinationPoint: destinationPos)
            } else {
                delegate?.viewPannCanceled()
            }
            
            print("DEBUG: .ended")
        case .cancelled:
            print("DEBUG: .cancelled")
            sender.state = .began
            delegate?.viewPannCanceled()
        case .possible:
            print("DEBUG: .possible")
        case .failed:
            print("DEBUG: .failed")
            
            break
        @unknown default:
            print("DEBUG: Error in \(#function)")
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.scrollView.addSubview(self.imageView)
        self.view.addSubview(self.scrollView)
        
        imageView.image = UIImage(named: "zoom_saga")
    }
    
    private func layoutScrollView() {
        guard let image = imageView.image else { return }
        self.scrollView.frame = CGRect(origin: .zero, size: self.view.bounds.size)
        self.imageView.frame.size = imageSizeForAspectFit(WithImageSize: imageView.image?.size ?? .zero)
        self.scrollView.contentSize = self.imageView.bounds.size
        let widthScale = self.scrollView.bounds.width / image.size.width
        let heightScale = self.scrollView.bounds.height / image.size.height
        let scale = min(1.0, min(widthScale, heightScale))
        self.scrollView.minimumZoomScale = scale
        self.scrollView.maximumZoomScale = scale * 5
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale
        
        // サイズが大きい写真の場合、原寸画像の3倍まで表示する？
//            if min(widthScale, heightScale) != 0,
//               min(widthScale, heightScale) < 1.0 {
//                self.scrollView.maximumZoomScale = 1 / min(widthScale, heightScale) * 3
//            } else {
//                self.scrollView.maximumZoomScale = scale * 3
//            }
        
        self.updateContentInset()
    }
    
    private func updateContentInset() {
        let widthInset = max((scrollView.frame.width - imageView.frame.width) / 2, 0)
        let heightInset = max((scrollView.frame.height - imageView.frame.height) / 2, 0)
        scrollView.contentInset = .init(top: heightInset,
                                        left: widthInset,
                                        bottom: heightInset,
                                        right: widthInset)
    }
    
    /// ズーム時の矩形を求める
    /// - parameter scale: 拡大率
    /// - parameter center: 中央の座標
    /// - returns: ズーム後の表示エリア
    private func zoomRectForScale(scale:CGFloat, center: CGPoint) -> CGRect{
        
        var zoomRect: CGRect = CGRect()
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.size.width  = scrollView.frame.size.width  / scale
        zoomRect.origin.x    = center.x - zoomRect.size.width  / 2.0
        zoomRect.origin.y    = center.y - zoomRect.size.height / 2.0
        
        return zoomRect
    }
    
    private func imageSizeForAspectFit(WithImageSize imageSize: CGSize) -> CGSize {
        guard 0 < imageSize.width, 0 < imageSize.height else { return .zero }
        
        let widthScale = view.frame.size.width / imageSize.width
        let heightScale = view.frame.size.height / imageSize.height
        let scale = min(widthScale, heightScale)
        
        // 画像がviewに収まる場合
        if 1.0 <= scale {
            return imageSize
        }
        
        // 画像のほうが大きい場合... 0.3等
        // scaleが小さい方（長辺）に合わせる
        return CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
    }
    
}

// MARK: - UIScrollViewDelegate

extension DetailImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateContentInset()
        delegate?.viewIsZoomed(isZooming: (scrollView.minimumZoomScale < scrollView.zoomScale))
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DetailImageViewController: UIGestureRecognizerDelegate {
    // 複数のジェスチャーを有効にする
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
