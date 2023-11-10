//
//  MBHUDTool.swift
//  Occlusion
//
//  Created by spec on 2021/12/25.
//

import Foundation
import UIKit

#if canImport(MBProgressHUD)
import MBProgressHUD
class MBHUDTool {
    var hud: MBProgressHUD?
    //    var viewToPresentOn: UIView?
}

extension MBHUDTool: ProgressHUD {
    func showErr(onView view: UIView? = nil, title: String? = nil, subTitle: String? = nil) {
        if let hud = hud {
            hud.hide(animated: true)
        }
        hud = nil
        let view: UIView? = view ?? MainApp.keyWindow
        if let view = view {
            let h = MBProgressHUD.showAdded(to: view, animated: true)
            h.mode = .customView
            h.update(blurEffect: HUD.blurEffectStyle)
            let image = UIImage(named: "infomation")!
            image.withRenderingMode(.alwaysTemplate)
            h.customView = UIImageView(image: image)
            h.label.text = title
            h.label.numberOfLines = 5
            h.detailsLabel.text = subTitle
            hud = h
        }
    }
    
    public func dismiss() {
        guard let hud = hud else { return }
        hud.hide(animated: true)
    }
    
    func showLoading(onView view: UIView? = nil, title: String? = nil, subTitle: String? = nil) {
        if let hud = hud {
            hud.hide(animated: true)
        }
        hud = nil
        let view: UIView? = view ?? MainApp.keyWindow
        if let view = view {
            let h = MBProgressHUD.showAdded(to: view, animated: true)
            h.mode = .indeterminate
            h.update(blurEffect: HUD.blurEffectStyle)
            h.label.text = title
            h.detailsLabel.text = subTitle
            hud = h
        }
    }
    
    func showMumuLoading(onView view: UIView?) {
        if let hud = hud {
            hud.hide(animated: true)
        }
        hud = nil
        let view: UIView? = view ?? MainApp.keyWindow
        if let view = view {
            let h = MBProgressHUD.showAdded(to: view, animated: true)
            h.mode = .customView
//            h.update(blurEffect: HUD.blurEffectStyle)
            let imv = ArtisseLoadingView(frame: .zero)
            imv.startAnimating()
            h.customView = imv
            h.clearBackgroundColor()
            hud = h
        }
    }
    
    func showSuccess(onView view: UIView? = nil, title: String? = nil, subTitle: String? = nil) {
        if let hud = hud {
            hud.hide(animated: true)
        }
        hud = nil
        let view: UIView? = view ?? MainApp.keyWindow
        if let view = view {
            let h = MBProgressHUD.showAdded(to: view, animated: true)
            h.mode = .customView
            h.update(blurEffect: HUD.blurEffectStyle)
            let image = UIImage(named: "Checkmark")!
            image.withRenderingMode(.alwaysTemplate)
            h.customView = UIImageView(image: image)
            h.label.text = title
            h.label.numberOfLines = 5
            h.detailsLabel.text = subTitle
            hud = h
        }
    }
    
    func showInfo(onView view: UIView? = nil, title: String? = nil, subTitle: String? = nil) {
        if let hud = hud {
            hud.hide(animated: true)
        }
        hud = nil
        let view: UIView? = view ?? MainApp.keyWindow
        if let view = view {
            let h = MBProgressHUD.showAdded(to: view, animated: true)
            h.mode = .customView
            h.update(blurEffect: HUD.blurEffectStyle)
            let image = UIImage(named: "infomation")!
            image.withRenderingMode(.alwaysTemplate)
            h.customView = UIImageView(image: image)
            h.label.text = title
            h.label.numberOfLines = 5
            h.detailsLabel.text = subTitle
            hud = h
        }
    }
}

extension MBProgressHUD {
    
    func update(blurEffect style: UIBlurEffect.Style) {
        bezelView.blurEffectStyle = HUD.blurEffectStyle
        if HUD.blurEffectStyle == .light {
            contentColor = UIColor(hexadecimal: 0x222222)
        }
    }
    
    func update(backgroundColor: UIColor) {
        bezelView.style = .solidColor
        bezelView.backgroundColor = HUD.backgroundColor
    }
    
    func clearBackgroundColor() {
        bezelView.style = .solidColor
        bezelView.backgroundColor = .clear
    }
}

class ArtisseLoadingView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        let (images, duration) = getArtisseGifImage()
        animationImages = images
        animationDuration = duration
        animationImages = images
    }
    
    override var intrinsicContentSize: CGSize {
        // 返回你视图的最适合的大小
        return CGSize(width: 106, height: 80)
    }
    
    func getArtisseGifImage() -> ([UIImage]?, TimeInterval) {
        // 加载Gif图片, 并且转成Data类型,"my.gif就是gif图片"
        guard let path = Bundle.main.path(forResource: "ArtisseLoading", ofType: "gif") else { return (nil, 0) }
        guard let data = NSData(contentsOfFile: path) else { return (nil, 0) }
        
        // 从data中读取数据: 将data转成CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else { return (nil, 0) }
        let imageCount = CGImageSourceGetCount(imageSource)
        
        // 便利所有的图片
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<imageCount {
            // .取出图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            
            // 取出持续的时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else { continue }
            guard let gifDict = (properties as NSDictionary)[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        return (images, totalDuration)
    }
}
#endif
