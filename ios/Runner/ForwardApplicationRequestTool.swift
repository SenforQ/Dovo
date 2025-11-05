
//: Declare String Begin

/*: "Net Error, Try again later" :*/
fileprivate let appAreaStr:String = "Net field capture protection all"
fileprivate let notiRootTitle:String = "kit succeed alongr, Tr"
fileprivate let appProtectionKey:String = "LATER"

/*: "data" :*/
fileprivate let k_presentTapStr:String = "daneta"

/*: ":null" :*/
fileprivate let show_windowText:String = ":nullpush present"

/*: "json error" :*/
fileprivate let userAgainLoadContent:String = "jsototal"

/*: "platform=iphone&version= :*/
fileprivate let mainActionId:[Character] = ["p","l","a","t","f","o","r","m","=","i","p","h"]
fileprivate let appNativeName:[Character] = ["o","n","e","&","v","e","r","s","i","o","n","="]

/*: &packageId= :*/
fileprivate let k_poorOkMsg:String = "class handle permission time&pac"
fileprivate let app_enterPath:String = "Id=database observe index file fast"

/*: &bundleId= :*/
fileprivate let showServerMessage:String = "&bundprotection manager progress maximum enter"

/*: &lang= :*/
fileprivate let dataNetId:[Character] = ["&","l","a","n","g"]
fileprivate let data_insertMsg:String = "package"

/*: ; build: :*/
fileprivate let kOriginValue:String = "; build:net content sub click actually"

/*: ; iOS  :*/
fileprivate let showServiceDateKey:[Character] = [";"," ","i","O","S"," "]

//: Declare String End

//: import Alamofire
import Alamofire
//: import CoreMedia
import CoreMedia
//: import HandyJSON
import HandyJSON
// __DEBUG__
// __CLOSE_PRINT__
//: import UIKit
import UIKit

//: typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: AppErrorResponse?) -> Void
typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: KindErrorResponse?) -> Void

//: @objc class AppRequestTool: NSObject {
@objc class ForwardApplicationRequestTool: NSObject {
    /// 发起Post请求
    /// - Parameters:
    ///   - model: 请求参数
    ///   - completion: 回调
    //: class func startPostRequest(model: AppRequestModel, completion: @escaping FinishBlock) {
    class func execute(model: RequestModel, completion: @escaping FinishBlock) {
        //: let serverUrl = self.buildServerUrl(model: model)
        let serverUrl = self.with(model: model)
        //: let headers = self.getRequestHeader(model: model)
        let headers = self.launchModel(model: model)
        //: AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
        AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
            //: switch responseData.result {
            switch responseData.result {
            //: case .success:
            case .success:
                //: func__requestSucess(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)
                permissionCompletion(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)

            //: case .failure:
            case .failure:
                //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "Net Error, Try again later"))
                completion(false, nil, KindErrorResponse(errorCode: EverCustomReflectable.NetError.rawValue, errorMsg: (String(appAreaStr.prefix(4)) + "Erro" + String(notiRootTitle.suffix(5)) + "y again " + appProtectionKey.lowercased())))
            }
        }
    }

    //: class func func__requestSucess(model: AppRequestModel, response: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
    class func permissionCompletion(model _: RequestModel, response _: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
        //: var responseJson = String(data: responseData, encoding: .utf8)
        var responseJson = String(data: responseData, encoding: .utf8)
        //: responseJson = responseJson?.replacingOccurrences(of: "\"data\":null", with: "\"data\":{}")
        responseJson = responseJson?.replacingOccurrences(of: "\"" + (k_presentTapStr.replacingOccurrences(of: "net", with: "t")) + "\"" + (String(show_windowText.prefix(5))), with: "" + "\"" + (k_presentTapStr.replacingOccurrences(of: "net", with: "t")) + "\"" + ":{}")
        //: if let responseModel = JSONDeserializer<AppBaseResponse>.deserializeFrom(json: responseJson) {
        if let responseModel = JSONDeserializer<RefHandyJSON>.deserializeFrom(json: responseJson) {
            //: if responseModel.errno == RequestResultCode.Normal.rawValue {
            if responseModel.errno == EverCustomReflectable.Normal.rawValue {
                //: completion(true, responseModel.data, nil)
                completion(true, responseModel.data, nil)
                //: } else {
            } else {
                //: completion(false, responseModel.data, AppErrorResponse.init(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                completion(false, responseModel.data, KindErrorResponse(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                //: switch responseModel.errno {
                switch responseModel.errno {
//                case EverCustomReflectable.NeedReLogin.rawValue:
//                    NotificationCenter.default.post(name: DID_LOGIN_OUT_SUCCESS_NOTIFICATION, object: nil, userInfo: nil)
                //: default:
                default:
                    //: break
                    break
                }
            }
            //: } else {
        } else {
            //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "json error"))
            completion(false, nil, KindErrorResponse(errorCode: EverCustomReflectable.NetError.rawValue, errorMsg: (userAgainLoadContent.replacingOccurrences(of: "total", with: "n") + " error")))
        }
    }

    //: class func buildServerUrl(model: AppRequestModel) -> String {
    class func with(model: RequestModel) -> String {
        //: var serverUrl: String = model.requestServer
        var serverUrl: String = model.requestServer
        //: let otherParams = "platform=iphone&version=\(AppNetVersion)&packageId=\(PackageID)&bundleId=\(AppBundle)&lang=\(UIDevice.interfaceLang)"
        let otherParams = (String(mainActionId) + String(appNativeName)) + "\(notiWarnPath)" + (String(k_poorOkMsg.suffix(4)) + "kage" + String(app_enterPath.prefix(3))) + "\(app_onlyDatabaseMessage)" + (String(showServerMessage.prefix(5)) + "leId=") + "\(user_fastUrl)" + (String(dataNetId) + data_insertMsg.replacingOccurrences(of: "package", with: "=")) + "\(UIDevice.interfaceLang)"
        //: if !model.requestPath.isEmpty {
        if !model.requestPath.isEmpty {
            //: serverUrl.append("/\(model.requestPath)")
            serverUrl.append("/\(model.requestPath)")
        }
        //: serverUrl.append("?\(otherParams)")
        serverUrl.append("?\(otherParams)")

        //: return serverUrl
        return serverUrl
    }

    /// 获取请求头参数
    /// - Parameter model: 请求模型
    /// - Returns: 请求头参数
    //: class func getRequestHeader(model: AppRequestModel) -> HTTPHeaders {
    class func launchModel(model _: RequestModel) -> HTTPHeaders {
        //: let userAgent = "\(AppName)/\(AppVersion) (\(AppBundle); build:\(AppBuildNumber); iOS \(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        let userAgent = "\(userClientData)/\(show_actuallyData) (\(user_fastUrl)" + (String(kOriginValue.prefix(8))) + "\(app_observePath)" + (String(showServiceDateKey)) + "\(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        //: let headers = [HTTPHeader.userAgent(userAgent)]
        let headers = [HTTPHeader.userAgent(userAgent)]
        //: return HTTPHeaders(headers)
        return HTTPHeaders(headers)
    }
}
