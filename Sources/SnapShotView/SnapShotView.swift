//
//  ScreenShotScrollView.swift
//  daymoji
//
//  Created by neo su on 2020/10/15.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
typealias ScreenShotScrollViewStyle = (_ uiScrollView: UIScrollView) -> Void

@available(iOS 13.0, macOS 10.15, *)
struct ScreenShotScrollView<Content: View>: UIViewRepresentable {
    
    let content: Content
    
    let scrollView: UIScrollView
    
    private var styleAction: ScreenShotScrollViewStyle? = nil
    
    init(scrollView: UIScrollView, ViewBuilder builder: () -> Content) {
        self.content = builder()
        self.scrollView = scrollView
    }
    
    func setStyle(action: @escaping ScreenShotScrollViewStyle = { _ in }) -> Self{
        var copy = self
        copy.styleAction = action
        return copy
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        scrollView.alwaysBounceVertical = true
        let screenWidth = UIScreen.main.bounds.size.width
        let uiHosting = UIHostingController(rootView: content)
        let size = uiHosting.view.sizeThatFits(CGSize(width: screenWidth, height: CGFloat.greatestFiniteMagnitude))
        uiHosting.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: size.height)
        scrollView.contentSize = CGSize(width: screenWidth, height: size.height)
        
        if let callback = styleAction{
            callback(scrollView)
        }
        
        scrollView.addSubview(uiHosting.view)
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
    }
    
}

extension UIScrollView {
    func saveImage() -> UIImage {
        return screenshot()
    }
    
    func screenshot() -> UIImage {
        
        let savedContentOffset = contentOffset
        let savedFrame = frame
        let savedSuperView = self.superview
        
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        //a bug
        self.removeFromSuperview()
        
        contentOffset = .zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        contentOffset = savedContentOffset
        frame = savedFrame
        
        savedSuperView?.addSubview(self)
        
        return image ?? UIImage()
        
    }
}
