
//: Declare String Begin

/*: "minglejo" :*/
fileprivate let kUnderMessage:String = "minsystemlej"
fileprivate let const_upKey:[Character] = ["o"]

/*: "https://m. :*/
fileprivate let showTotalervalMessage:String = "httppaper"

/*: .com" :*/
fileprivate let k_finishName:String = ".comtype total flexible label type"

/*: "1.9.1" :*/
fileprivate let userPresentFormat:String = "local.9.local"

/*: "996" :*/
fileprivate let user_triggerSystemLoadTitle:[Character] = ["9","9","6"]

/*: "9yvcxecevi80" :*/
fileprivate let show_coreYourMessage:[Character] = ["9","y","v","c","x","e","c","e","v","i","8","0"]

/*: "2o8gal" :*/
fileprivate let dataBlackLogMsg:[Character] = ["2","o","8","g","a","l"]

/*: "CFBundleShortVersionString" :*/
fileprivate let app_enterMicValue:String = "CFBunnative that message"
fileprivate let user_evaluateMsg:String = "tVersinative foundation behavior"
fileprivate let userFinishName:String = "phone list kit info observeronSt"

/*: "CFBundleDisplayName" :*/
fileprivate let kTunScriptId:String = "CFBunfatal break remove"
fileprivate let data_albumMsg:String = "post"
fileprivate let notiPointTitle:String = "observe panelleDi"
fileprivate let userOriginalTitle:String = "reduce adjustment key global elementyName"

/*: "CFBundleVersion" :*/
fileprivate let show_failPath:String = "point presentation or control firstCFBu"
fileprivate let kErrorKey:String = "kit warnVersio"
fileprivate let kBridgeSelectPath:String = "feedback"

/*: "weixin" :*/
fileprivate let kIndexFormat:String = "wbodyixi"
fileprivate let app_allowContent:String = "fir"

/*: "wxwork" :*/
fileprivate let app_failText:String = "wpolicyork"

/*: "dingtalk" :*/
fileprivate let k_userPendingFilterText:String = "runngtalk"

/*: "lark" :*/
fileprivate let mainAllTitle:[Character] = ["l","a","r","k"]

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  CutAppConfig.swift
//  OverseaH5
//
//  Created by young on 2025/9/24.
//

//: import KeychainSwift
import KeychainSwift
//: import UIKit
import UIKit

/// 域名
//: let ReplaceUrlDomain = "minglejo"
let user_countValue = (kUnderMessage.replacingOccurrences(of: "system", with: "g") + String(const_upKey))
//: let H5WebDomain = "https://m.\(ReplaceUrlDomain).com"
let appExpectedValue = (showTotalervalMessage.replacingOccurrences(of: "paper", with: "s") + "://m.") + "\(user_countValue)" + (String(k_finishName.prefix(4)))
/// 网络版本号
//: let AppNetVersion = "1.9.1"
let notiWarnPath = (userPresentFormat.replacingOccurrences(of: "local", with: "1"))
/// 包ID
//: let PackageID = "996"
let app_onlyDatabaseMessage = (String(user_triggerSystemLoadTitle))
/// Adjust
//: let AdjustKey = "9yvcxecevi80"
let user_firPath = (String(show_coreYourMessage))
//: let AdInstallToken = "2o8gal"
let userMaximumName = (String(dataBlackLogMsg))

//: let AppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let show_actuallyData = Bundle.main.infoDictionary![(String(app_enterMicValue.prefix(5)) + "dleShor" + String(user_evaluateMsg.prefix(6)) + String(userFinishName.suffix(4)) + "ring")] as! String
//: let AppBundle = Bundle.main.bundleIdentifier!
let user_fastUrl = Bundle.main.bundleIdentifier!
//: let AppName = Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? ""
let userClientData = Bundle.main.infoDictionary![(String(kTunScriptId.prefix(5)) + data_albumMsg.replacingOccurrences(of: "post", with: "d") + String(notiPointTitle.suffix(4)) + "spla" + String(userOriginalTitle.suffix(5)))] ?? ""
//: let AppBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
let app_observePath = Bundle.main.infoDictionary![(String(show_failPath.suffix(4)) + "ndle" + String(kErrorKey.suffix(6)) + kBridgeSelectPath.replacingOccurrences(of: "feedback", with: "n"))] as! String

//: class AppConfig: NSObject {
class CutAppConfig: NSObject {
    /// 获取状态栏高度
    //: class func getStatusBarHeight() -> CGFloat {
    class func receipts() -> CGFloat {
        //: if #available(iOS 13.0, *) {
        if #available(iOS 13.0, *) {
            //: if let statusBarManager = UIApplication.shared.windows.first?
            if let statusBarManager = UIApplication.shared.windows.first?
                //: .windowScene?.statusBarManager
                .windowScene?.statusBarManager
            {
                //: return statusBarManager.statusBarFrame.size.height
                return statusBarManager.statusBarFrame.size.height
            }
            //: } else {
        } else {
            //: return UIApplication.shared.statusBarFrame.size.height
            return UIApplication.shared.statusBarFrame.size.height
        }
        //: return 20.0
        return 20.0
    }

    /// 获取window
    //: class func getWindow() -> UIWindow {
    class func clerestory() -> UIWindow {
        //: var window = UIApplication.shared.windows.first(where: {
        var window = UIApplication.shared.windows.first(where: {
            //: $0.isKeyWindow
            $0.isKeyWindow
            //: })
        })
        // 是否为当前显示的window
        //: if window?.windowLevel != UIWindow.Level.normal {
        if window?.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: return window!
        return window!
    }

    /// 获取当前控制器
    //: class func currentViewController() -> (UIViewController?) {
    class func futurism() -> (UIViewController?) {
        //: var window = AppConfig.getWindow()
        var window = CutAppConfig.clerestory()
        //: if window.windowLevel != UIWindow.Level.normal {
        if window.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: let vc = window.rootViewController
        let vc = window.rootViewController
        //: return currentViewController(vc)
        return transaction(vc)
    }

    //: class func currentViewController(_ vc: UIViewController?)
    class func transaction(_ vc: UIViewController?)
        //: -> UIViewController?
        -> UIViewController?
    {
        //: if vc == nil {
        if vc == nil {
            //: return nil
            return nil
        }
        //: if let presentVC = vc?.presentedViewController {
        if let presentVC = vc?.presentedViewController {
            //: return currentViewController(presentVC)
            return transaction(presentVC)
            //: } else if let tabVC = vc as? UITabBarController {
        } else if let tabVC = vc as? UITabBarController {
            //: if let selectVC = tabVC.selectedViewController {
            if let selectVC = tabVC.selectedViewController {
                //: return currentViewController(selectVC)
                return transaction(selectVC)
            }
            //: return nil
            return nil
            //: } else if let naiVC = vc as? UINavigationController {
        } else if let naiVC = vc as? UINavigationController {
            //: return currentViewController(naiVC.visibleViewController)
            return transaction(naiVC.visibleViewController)
            //: } else {
        } else {
            //: return vc
            return vc
        }
    }
}

// MARK: - Device

//: extension UIDevice {
extension UIDevice {
    //: static var modelName: String {
    static var modelName: String {
        //: var systemInfo = utsname()
        var systemInfo = utsname()
        //: uname(&systemInfo)
        uname(&systemInfo)
        //: let machineMirror = Mirror(reflecting: systemInfo.machine)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        //: let identifier = machineMirror.children.reduce("") {
        let identifier = machineMirror.children.reduce("") {
            //: identifier, element in
            identifier, element in
            //: guard let value = element.value as? Int8, value != 0 else {
            guard let value = element.value as? Int8, value != 0 else {
                //: return identifier
                return identifier
            }
            //: return identifier + String(UnicodeScalar(UInt8(value)))
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        //: return identifier
        return identifier
    }

    /// 获取当前系统时区
    //: static var timeZone: String {
    static var timeZone: String {
        //: let currentTimeZone = NSTimeZone.system
        let currentTimeZone = NSTimeZone.system
        //: return currentTimeZone.identifier
        return currentTimeZone.identifier
    }

    /// 获取当前系统语言
    //: static var langCode: String {
    static var langCode: String {
        //: let language = Locale.preferredLanguages.first
        let language = Locale.preferredLanguages.first
        //: return language ?? ""
        return language ?? ""
    }

    /// 获取接口语言
    //: static var interfaceLang: String {
    static var interfaceLang: String {
        //: let lang = UIDevice.getSystemLangCode()
        let lang = UIDevice.start()
        //: if ["en", "ar", "es", "pt"].contains(lang) {
        if ["en", "ar", "es", "pt"].contains(lang) {
            //: return lang
            return lang
        }
        //: return "en"
        return "en"
    }

    /// 获取当前系统地区
    //: static var countryCode: String {
    static var countryCode: String {
        //: let locale = Locale.current
        let locale = Locale.current
        //: let countryCode = locale.regionCode
        let countryCode = locale.regionCode
        //: return countryCode ?? ""
        return countryCode ?? ""
    }

    /// 获取系统UUID（每次调用都会产生新值，所以需要keychain）
    //: static var systemUUID: String {
    static var systemUUID: String {
        //: let key = KeychainSwift()
        let key = KeychainSwift()
        //: if let value = key.get(AdjustKey) {
        if let value = key.get(user_firPath) {
            //: return value
            return value
            //: } else {
        } else {
            //: let value = NSUUID().uuidString
            let value = NSUUID().uuidString
            //: key.set(value, forKey: AdjustKey)
            key.set(value, forKey: user_firPath)
            //: return value
            return value
        }
    }

    /// 获取已安装应用信息
    //: static var getInstalledApps: String {
    static var getInstalledApps: String {
        //: var appsArr: [String] = []
        var appsArr: [String] = []
        //: if UIDevice.canOpenApp("weixin") {
        if UIDevice.island((kIndexFormat.replacingOccurrences(of: "body", with: "e") + app_allowContent.replacingOccurrences(of: "fir", with: "n"))) {
            //: appsArr.append("weixin")
            appsArr.append((kIndexFormat.replacingOccurrences(of: "body", with: "e") + app_allowContent.replacingOccurrences(of: "fir", with: "n")))
        }
        //: if UIDevice.canOpenApp("wxwork") {
        if UIDevice.island((app_failText.replacingOccurrences(of: "policy", with: "xw"))) {
            //: appsArr.append("wxwork")
            appsArr.append((app_failText.replacingOccurrences(of: "policy", with: "xw")))
        }
        //: if UIDevice.canOpenApp("dingtalk") {
        if UIDevice.island((k_userPendingFilterText.replacingOccurrences(of: "run", with: "di"))) {
            //: appsArr.append("dingtalk")
            appsArr.append((k_userPendingFilterText.replacingOccurrences(of: "run", with: "di")))
        }
        //: if UIDevice.canOpenApp("lark") {
        if UIDevice.island((String(mainAllTitle))) {
            //: appsArr.append("lark")
            appsArr.append((String(mainAllTitle)))
        }
        //: if appsArr.count > 0 {
        if appsArr.count > 0 {
            //: return appsArr.joined(separator: ",")
            return appsArr.joined(separator: ",")
        }
        //: return ""
        return ""
    }

    /// 判断是否安装app
    //: static func canOpenApp(_ scheme: String) -> Bool {
    static func island(_ scheme: String) -> Bool {
        //: let url = URL(string: "\(scheme)://")!
        let url = URL(string: "\(scheme)://")!
        //: if UIApplication.shared.canOpenURL(url) {
        if UIApplication.shared.canOpenURL(url) {
            //: return true
            return true
        }
        //: return false
        return false
    }

    /// 获取系统语言
    /// - Returns: 国际通用语言Code
    //: @objc public class func getSystemLangCode() -> String {
    @objc public class func start() -> String {
        //: let language = NSLocale.preferredLanguages.first
        let language = NSLocale.preferredLanguages.first
        //: let array = language?.components(separatedBy: "-")
        let array = language?.components(separatedBy: "-")
        //: return array?.first ?? "en"
        return array?.first ?? "en"
    }
}
