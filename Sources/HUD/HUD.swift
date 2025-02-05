//
//  HUD.swift
//  Occlusion
//
//  Created by spec on 2021/12/25.
//

import UIKit

public class HUD: NSObject {
    static var shared = HUD(hud: MBHUDTool())

    public static func setup(hud: ProgressHUD) {
        shared = HUD(hud: hud)
    }
    
    static var backgroundColor: UIColor = UIColor(red: 77, green: 77, blue: 77, alpha: 1)

    static var blurEffectStyle: UIBlurEffect.Style = .dark
    
    private var tool: ProgressHUD

    private init(hud: ProgressHUD) {
        tool = hud
        super.init()
    }
    
    static func config(backgroundColor: UIColor) {
        HUD.backgroundColor = backgroundColor
    }
    
    public static func config(blurEffect style: UIBlurEffect.Style) {
        blurEffectStyle = style
    }

    public static func show(_ message: String? = nil, subMessage: String? = nil, type: HUDType, onView: UIView? = nil, time: TimeInterval = 1, callBack: (() -> Void)? = nil) {
        shared.show(message, subMessage: subMessage, type: type, onView: onView, time: time, callBack: callBack)
    }

    public static func hide() {
        shared.tool.dismiss()
    }
}

extension HUD {
    public enum HUDType {
        case error, info, success, loading, mumuLoading
    }

    func show(_ message: String? = nil, subMessage: String? = nil, type: HUDType, onView: UIView? = nil, time: TimeInterval = 1, callBack: (() -> Void)?) {
        DispatchQueue.main.async { [unowned self] in
            switch type {
            case .error:
                tool.showErr(onView: onView, title: message, subTitle: subMessage)
            case .info:
                tool.showInfo(onView: onView, title: message, subTitle: subMessage)
            case .success:
                tool.showSuccess(onView: onView, title: message, subTitle: subMessage)
            case .loading:
                tool.showLoading(onView: onView, title: message, subTitle: subMessage)
            case .mumuLoading:
                tool.showMumuLoading(onView: onView)
            }

            if type != .loading && type != .mumuLoading {
                _ = delay(time, task: {
                    self.tool.dismiss()
                    callBack?()
                })
            }
        }
    }
}
