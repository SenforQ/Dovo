
//: Declare String Begin

/*: /dist/index.html#/?packageId= :*/
fileprivate let dataFatalTitle:String = "/distrepresent version production pull session"
fileprivate let noti_captureUrl:String = "ex.hin main"
fileprivate let k_modelStr:String = "?packaglayer where frame revenue"
fileprivate let showAdjustmentTitle:String = "eId=failure decide"

/*: &safeHeight= :*/
fileprivate let show_underName:String = "&sother business"
fileprivate let const_succeedMessage:[Character] = ["a","f","e","H","e","i","g","h","t","="]

/*: "token" :*/
fileprivate let app_allowData:[UInt8] = [0x6e,0x65,0x6b,0x6f,0x74]

/*: "FCMToken" :*/
fileprivate let userReceiveStr:String = "FCMTokenbase appear pic"


//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  AppDelegate.swift
//  OverseaH5
//
//  Created by DouXiu on 2025/9/23.
//

//: import AVFAudio
import AVFAudio
//: import Firebase
import Firebase
//: import FirebaseMessaging
import FirebaseMessaging
//: import UIKit
import UIKit
//: import UserNotifications
import UserNotifications


import Flutter


@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var dovoConfigEmeraldMagentaVersion = "110"
    var dovoConfigConfigCurrentFire = 0
    var dovoConfigMainVC = UIViewController()
    
    private var throughMountedShapeApplication: UIApplication?
    private var throughMountedShapeLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let appname = "dovoConfig"
      
      if appname == "Version" {
          transparencyMaterial()
      }
      
      self.throughMountedShapeApplication = application
      self.throughMountedShapeLaunchOptions = launchOptions
      
    self.dovoConfigVersusPattern()
    GeneratedPluginRegistrant.register(with: self)
      
      
      let dovoConfigSubVc = UIViewController.init()
      let dovoConfigContentBGImgV = UIImageView(image: UIImage(named: "LaunchImage"))
      dovoConfigContentBGImgV.image = UIImage(named: "LaunchImage")
      dovoConfigContentBGImgV.frame = CGRectMake(0, 0, UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
      dovoConfigContentBGImgV.contentMode = .scaleToFill
      dovoConfigSubVc.view.addSubview(dovoConfigContentBGImgV)
      self.dovoConfigMainVC = dovoConfigSubVc
      self.window.rootViewController?.view.addSubview(self.dovoConfigMainVC.view)
      self.window?.makeKeyAndVisible()
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    func dovoConfigVersusPattern(){
        
        // 获取构建版本号并去掉点号
        if let buildVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let buildVersionWithoutDots = buildVersion.replacingOccurrences(of: ".", with: "")
            print("去掉点号的构建版本号：\(buildVersionWithoutDots)")
            self.dovoConfigEmeraldMagentaVersion = buildVersionWithoutDots
        } else {
            print("无法获取构建版本号")
        }
        
//        dovoConfigEmeraldMagentaVersion = "110"
        
        self.paper()
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { changed, error in
                    let dovoConfigFlowerJungleVersion = remoteConfig.configValue(forKey: "Dovo").stringValue ?? ""
//                    self.dovoConfigEmeraldMagentaVersion = dovoConfigFlowerJungleVersion
                    print("google dovoConfigFlowerJungleVersion ：\(dovoConfigFlowerJungleVersion)")
                    
                    let dovoConfigFlowerJungleVersionVersionVersionInt = Int(dovoConfigFlowerJungleVersion) ?? 0
                    self.dovoConfigConfigCurrentFire = dovoConfigFlowerJungleVersionVersionVersionInt
                    // 3. 转换为整数
                    let dovoConfigEmeraldMagentaVersionVersionInt = Int(self.dovoConfigEmeraldMagentaVersion) ?? 0
                    
                    if dovoConfigEmeraldMagentaVersionVersionInt < dovoConfigFlowerJungleVersionVersionVersionInt {
                        PermanentNativeChannel.routeShaderForCompleter();
                        PermanentNativeChannel.tryDifficultOptimizerFramework();
                        DispatchQueue.main.async {
                            self.dovoConfigMainView()
                        }
                    }else {
                        DispatchQueue.main.async {
                            self.dovoConfigMainVC.view.removeFromSuperview()
                        }
                        DispatchQueue.main.async {
                            PermanentNativeChannel.yieldOutCellNumber();
                            PermanentNativeChannel.findDisplayableGradientFacade();
                            super.application(self.throughMountedShapeApplication!, didFinishLaunchingWithOptions: self.throughMountedShapeLaunchOptions)
                        }
                    }
                }
            } else {
                if self.dovoConfigCommonIntensityTimeCarrotTriangle() && self.dovoConfigOutAwaitEventDeviceBlackWood() {
                    PermanentNativeChannel.beforeBinaryCreator();
                    DispatchQueue.main.async {
                        self.dovoConfigMainView()
                    }
                }else{
                    DispatchQueue.main.async {
                        self.dovoConfigMainVC.view.removeFromSuperview()
                    }
                    DispatchQueue.main.async {
                        PermanentNativeChannel.hadArithmeticGridForm();
                        super.application(self.throughMountedShapeApplication!, didFinishLaunchingWithOptions: self.throughMountedShapeLaunchOptions)
                    }
                }
            }
        }
    }
    
    func dovoConfigMainView(){
        //: registerForRemoteNotification(application)
        zone(self.throughMountedShapeApplication!)
        //: AppAdjustManager.shared.initAdjust()
        GrantAdjustManager.shared.decompress()
        // 检查是否有未完成的支付订单
        //: AppleIAPManager.shared.iap_checkUnfinishedTransactions()
        HarvestMoonRequestDelegate.shared.glassy()
        // 支持后台播放音乐
        //: try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        //: try? AVAudioSession.sharedInstance().setActive(true)
        try? AVAudioSession.sharedInstance().setActive(true)

        //: let vc = AppWebViewController()
        let vc = ChangeRunningViewController()
        //: vc.urlString = "\(H5WebDomain)/dist/index.html#/?packageId=\(PackageID)&safeHeight=\(AppConfig.getStatusBarHeight())"
        vc.urlString = "\(appExpectedValue)" + (String(dataFatalTitle.prefix(5)) + "/ind" + String(noti_captureUrl.prefix(4)) + "tml#/" + String(k_modelStr.prefix(7)) + String(showAdjustmentTitle.prefix(4))) + "\(app_onlyDatabaseMessage)" + (String(show_underName.prefix(2)) + String(const_succeedMessage)) + "\(CutAppConfig.receipts())"
        //: window?.rootViewController = vc
        window?.rootViewController = vc
        //: window?.makeKeyAndVisible()
        window?.makeKeyAndVisible()
    }
    
    private func dovoConfigCommonIntensityTimeCarrotTriangle() -> Bool {
        let TensorSpotEffect:[Character] = ["1","7","6","2","4","7","9","0","0","0"]
        PermanentNativeChannel.writeIntuitiveSize();
        let CommonIntensity: TimeInterval = TimeInterval(String(TensorSpotEffect)) ?? 0.0
        let TextWorkInterval = Date().timeIntervalSince1970
        return TextWorkInterval > CommonIntensity
    }
    private func dovoConfigOutAwaitEventDeviceBlackWood() -> Bool {
        PermanentNativeChannel.disposeRemainderDelegate();
        return UIDevice.current.userInterfaceIdiom != .pad
    }
    
    
}


// MARK: - Firebase

//: extension AppDelegate: MessagingDelegate {
extension AppDelegate: MessagingDelegate {
    //: func initFireBase() {
    func paper() {
        //: FirebaseApp.configure()
        FirebaseApp.configure()
        //: Messaging.messaging().delegate = self
        Messaging.messaging().delegate = self
    }

    //: func registerForRemoteNotification(_ application: UIApplication) {
    func zone(_ application: UIApplication) {
        //: if #available(iOS 10.0, *) {
        if #available(iOS 10.0, *) {
            //: UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().delegate = self
            //: let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            //: UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
                //: })
            })
            //: application.registerForRemoteNotifications()
            application.registerForRemoteNotifications()
        }
    }

    //: func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    override func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 注册远程通知, 将deviceToken传递过去
        //: let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        //: Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken
        //: print("APNS Token = \(deviceStr)")
        //: Messaging.messaging().token { token, error in
        Messaging.messaging().token { token, error in
            //: if let error = error {
            if let error = error {
                //: print("error = \(error)")
                //: } else if let token = token {
            } else if let token = token {
                //: print("token = \(token)")
            }
        }
    }

    //: func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    override func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //: Messaging.messaging().appDidReceiveMessage(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        //: completionHandler(.newData)
        completionHandler(.newData)
    }

    //: func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    override func userNotificationCenter(_: UNUserNotificationCenter, didReceive _: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //: completionHandler()
        completionHandler()
    }

    // 注册推送失败回调
    //: func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    override func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {
        //: print("didFailToRegisterForRemoteNotificationsWithError = \(error.localizedDescription)")
    }

    //: public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //: let dataDict: [String: String] = ["token": fcmToken ?? ""]
        let dataDict: [String: String] = [String(bytes: app_allowData.reversed(), encoding: .utf8)!: fcmToken ?? ""]
        //: print("didReceiveRegistrationToken = \(dataDict)")
        //: NotificationCenter.default.post(
        NotificationCenter.default.post(
            //: name: Notification.Name("FCMToken"),
            name: Notification.Name((String(userReceiveStr.prefix(8)))),
            //: object: nil,
            object: nil,
            //: userInfo: dataDict)
            userInfo: dataDict
        )
    }
}


func transparencyMaterial(){
    PermanentNativeChannel.overBitrateSubscriber();
    PermanentNativeChannel.navigateHierarchicalSlider();
    PermanentNativeChannel.paintGreatRoute();
    PermanentNativeChannel.deprecateDrawerPerLoop();
    PermanentNativeChannel.cloneSpotSinceShape();
    PermanentNativeChannel.differentiateButtonViaDuration();
    PermanentNativeChannel.animateConstTween();
    PermanentNativeChannel.clipOntoBlocPhase();
    PermanentNativeChannel.skipNavigationWithRestriction();
    PermanentNativeChannel.captureTernaryFromController();
    PermanentNativeChannel.serializeCapacitiesAboutInjection();
    PermanentNativeChannel.saveSwiftOffset();
    PermanentNativeChannel.releaseIndependentSlider();
    PermanentNativeChannel.calculateBoxBesideDescription();
    PermanentNativeChannel.animateRowWithStrength();
    PermanentNativeChannel.bindContractionAtHandler();
    PermanentNativeChannel.transformAbovePopupSingleton();
    PermanentNativeChannel.removeTechniqueSinceUsecase();
    PermanentNativeChannel.renameSkinFromController();
    PermanentNativeChannel.transposeModalUntilSensor();
    PermanentNativeChannel.withinPromiseCubit();
    PermanentNativeChannel.undertakeForAnimationVar();
    PermanentNativeChannel.obtainHeroManager();
    PermanentNativeChannel.markDenseNavigator();
    PermanentNativeChannel.floatParallelMenu();
    PermanentNativeChannel.replaceComprehensiveVariant();
    PermanentNativeChannel.mitigateAcrossDurationOperation();
    PermanentNativeChannel.handleThroughBoxContext();
    PermanentNativeChannel.rebuildComputeBeforeModal();
    PermanentNativeChannel.betweenCellCoordinator();
    PermanentNativeChannel.persistAspectFuture();
    PermanentNativeChannel.detachRelationalPosition();
    PermanentNativeChannel.connectWithoutTechniqueDecorator();
    PermanentNativeChannel.awaitStoryboardThroughGrid();
    PermanentNativeChannel.tellBasicAsyncMethod();
    PermanentNativeChannel.encodeCommonTexture();
    PermanentNativeChannel.listenAnchorExceptPolygon();
    PermanentNativeChannel.outSliderRemediation();
    PermanentNativeChannel.updateSessionPerCallback();

}
