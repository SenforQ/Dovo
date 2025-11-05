
//: Declare String Begin

/*: "init(coder:) has not been implemented" :*/
fileprivate let data_decideStr:[UInt8] = [0x5a,0x5f,0x5a,0x65,0x19,0x54,0x60,0x55,0x56,0x63,0x2b,0x1a,0x11,0x59,0x52,0x64,0x11,0x5f,0x60,0x65,0x11,0x53,0x56,0x56,0x5f,0x11,0x5a,0x5e,0x61,0x5d,0x56,0x5e,0x56,0x5f,0x65,0x56,0x55]

fileprivate func tagContact(presentation num: UInt8) -> UInt8 {
    let value = Int(num) + 15
    if value > 255 {
        return UInt8(value - 256)
    } else {
        return UInt8(value)
    }
}

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  InsideUnknownProgressHUD.swift
//  AbroadTalking
//
//  Created by Joeyoung on 2022/9/1.
//

//: import UIKit
import UIKit

//: let kProgressHUD_W            = 80.0
let k_versionUrl = 80.0
//: let kProgressHUD_cornerRadius = 14.0
let show_forgetMsg = 14.0
//: let kProgressHUD_alpha        = 0.9
let mainFastContent = 0.9
//: let kBackgroundView_alpha     = 0.6
let kLengthContent = 0.6
//: let kAnimationInterval        = 0.2
let notiMicMsg = 0.2
//: let kTransformScale           = 0.9
let user_appName = 0.9

//: open class ProgressHUD: UIView {
open class InsideUnknownProgressHUD: UIView {
    //: required public init?(coder: NSCoder) {
    public required init?(coder _: NSCoder) {
        //: fatalError("init(coder:) has not been implemented")
        fatalError(String(bytes: data_decideStr.map{tagContact(presentation: $0)}, encoding: .utf8)!)
    }

    //: static var shared = ProgressHUD()
    static var shared = InsideUnknownProgressHUD()
    //: private override init(frame: CGRect) {
    override private init(frame: CGRect) {
        //: super.init(frame: frame)
        super.init(frame: frame)
        //: self.frame = UIScreen.main.bounds
        self.frame = UIScreen.main.bounds
        //: self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //: self.backgroundColor = UIColor(white: 0, alpha: 0)
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        //: self.addSubview(activityIndicator)
        self.addSubview(activityIndicator)
    }

    //: open override func copy() -> Any { return self }
    override open func copy() -> Any { return self }
    //: open override func mutableCopy() -> Any { return self }
    override open func mutableCopy() -> Any { return self }

    //: class func show() {
    class func represent() {
        //: show(superView: nil)
        decide(superView: nil)
    }

    //: class func show(superView: UIView?) {
    class func decide(superView: UIView?) {
        //: if superView != nil {
        if superView != nil {
            //: DispatchQueue.main.async {
            DispatchQueue.main.async {
                //: ProgressHUD.shared.frame = superView!.bounds
                InsideUnknownProgressHUD.shared.frame = superView!.bounds
                //: ProgressHUD.shared.activityIndicator.center = ProgressHUD.shared.center
                InsideUnknownProgressHUD.shared.activityIndicator.center = InsideUnknownProgressHUD.shared.center
                //: superView!.addSubview(ProgressHUD.shared)
                superView!.addSubview(InsideUnknownProgressHUD.shared)
            }
            //: } else {
        } else {
            //: DispatchQueue.main.async {
            DispatchQueue.main.async {
                //: ProgressHUD.shared.frame = UIScreen.main.bounds
                InsideUnknownProgressHUD.shared.frame = UIScreen.main.bounds
                //: ProgressHUD.shared.activityIndicator.center = ProgressHUD.shared.center
                InsideUnknownProgressHUD.shared.activityIndicator.center = InsideUnknownProgressHUD.shared.center
                //: AppConfig.getWindow().addSubview(ProgressHUD.shared)
                CutAppConfig.clerestory().addSubview(InsideUnknownProgressHUD.shared)
            }
        }
        //: ProgressHUD.shared.hud_startAnimating()
        InsideUnknownProgressHUD.shared.empty()
    }

    //: class func dismiss() {
    class func rating() {
        //: ProgressHUD.shared.hud_stopAnimating()
        InsideUnknownProgressHUD.shared.institute()
    }

    //: private func hud_startAnimating() {
    private func empty() {
        //: DispatchQueue.main.async {
        DispatchQueue.main.async {
            //: self.backgroundColor = UIColor(white: 0, alpha: 0)
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            //: self.activityIndicator.transform = CGAffineTransform(scaleX: kTransformScale, y: kTransformScale)
            self.activityIndicator.transform = CGAffineTransform(scaleX: user_appName, y: user_appName)
            //: self.activityIndicator.alpha = 0
            self.activityIndicator.alpha = 0
            //: UIView.animate(withDuration: kAnimationInterval) {
            UIView.animate(withDuration: notiMicMsg) {
                //: self.backgroundColor = UIColor(white: 0, alpha: kBackgroundView_alpha)
                self.backgroundColor = UIColor(white: 0, alpha: kLengthContent)
                //: self.activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
                //: self.activityIndicator.alpha = kProgressHUD_alpha
                self.activityIndicator.alpha = mainFastContent
                //: self.activityIndicator.startAnimating()
                self.activityIndicator.startAnimating()
            }
        }
    }

    //: private func hud_stopAnimating() {
    private func institute() {
        //: DispatchQueue.main.async {
        DispatchQueue.main.async {
            //: UIView.animate(withDuration: kAnimationInterval) {
            UIView.animate(withDuration: notiMicMsg) {
                //: self.backgroundColor = UIColor(white: 0, alpha: 0)
                self.backgroundColor = UIColor(white: 0, alpha: 0)
                //: self.activityIndicator.transform = CGAffineTransform(scaleX: kTransformScale, y: kTransformScale)
                self.activityIndicator.transform = CGAffineTransform(scaleX: user_appName, y: user_appName)
                //: self.activityIndicator.alpha = 0
                self.activityIndicator.alpha = 0
                //: } completion: { finished in
            } completion: { _ in
                //: self.activityIndicator.stopAnimating()
                self.activityIndicator.stopAnimating()
                //: ProgressHUD.shared.removeFromSuperview()
                InsideUnknownProgressHUD.shared.removeFromSuperview()
            }
        }
    }

    // MARK: - Lazy load

    //: private lazy var activityIndicator: UIActivityIndicatorView = {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        //: let indicator = UIActivityIndicatorView(style: .whiteLarge)
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        //: indicator.bounds = CGRect(x: 0, y: 0, width: kProgressHUD_W, height: kProgressHUD_W)
        indicator.bounds = CGRect(x: 0, y: 0, width: k_versionUrl, height: k_versionUrl)
        //: indicator.center = self.center
        indicator.center = self.center
        //: indicator.backgroundColor = .black
        indicator.backgroundColor = .black
        //: indicator.layer.cornerRadius = kProgressHUD_cornerRadius
        indicator.layer.cornerRadius = show_forgetMsg
        //: indicator.layer.masksToBounds = true
        indicator.layer.masksToBounds = true
        //: return indicator
        return indicator
        //: }()
    }()
}

//: extension ProgressHUD {
extension InsideUnknownProgressHUD {
    //: class func toast(_ str: String?) {
    class func systemOfRules(_ str: String?) {
        //: toast(str, showTime: 1)
        item(str, showTime: 1)
    }

    //: class func toast(_ str: String?, showTime: CGFloat) {
    class func item(_ str: String?, showTime: CGFloat) {
        //: guard str != nil else { return }
        guard str != nil else { return }

        //: let titleLab = UILabel()
        let titleLab = UILabel()
        //: titleLab.backgroundColor = UIColor(white: 0, alpha: 0.8)
        titleLab.backgroundColor = UIColor(white: 0, alpha: 0.8)
        //: titleLab.layer.cornerRadius = 5
        titleLab.layer.cornerRadius = 5
        //: titleLab.layer.masksToBounds = true
        titleLab.layer.masksToBounds = true
        //: titleLab.text = str
        titleLab.text = str
        //: titleLab.font = .systemFont(ofSize: 16)
        titleLab.font = .systemFont(ofSize: 16)
        //: titleLab.textAlignment = .center
        titleLab.textAlignment = .center
        //: titleLab.numberOfLines = 0
        titleLab.numberOfLines = 0
        //: titleLab.textColor = .white
        titleLab.textColor = .white
        //: AppConfig.getWindow().addSubview(titleLab)
        CutAppConfig.clerestory().addSubview(titleLab)
        //: let size = titleLab.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat(MAXFLOAT)))
        let size = titleLab.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat(MAXFLOAT)))
        //: titleLab.center = AppConfig.getWindow().center
        titleLab.center = CutAppConfig.clerestory().center
        //: titleLab.bounds = CGRect(x: 0, y: 0, width: size.width + 30, height: size.height + 30)
        titleLab.bounds = CGRect(x: 0, y: 0, width: size.width + 30, height: size.height + 30)
        //: titleLab.alpha = 0
        titleLab.alpha = 0

        //: UIView.animate(withDuration: 0.2) {
        UIView.animate(withDuration: 0.2) {
            //: titleLab.alpha = 1
            titleLab.alpha = 1
            //: } completion: { finished in
        } completion: { _ in
            //: DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + showTime) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + showTime) {
                //: UIView.animate(withDuration: 0.2) {
                UIView.animate(withDuration: 0.2) {
                    //: titleLab.alpha = 1
                    titleLab.alpha = 1
                    //: } completion: { finished in
                } completion: { _ in
                    //: titleLab.removeFromSuperview()
                    titleLab.removeFromSuperview()
                }
            }
        }
    }
}
