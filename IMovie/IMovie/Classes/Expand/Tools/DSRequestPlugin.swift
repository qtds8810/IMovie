//
//  DSRequestPlugin.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/11.
//  Copyright © 2018年 zds. All rights reserved.
//

import Foundation
import Result
import Moya

let kNetworkActivityPlugin = NetworkActivityPlugin { (state, target)  -> Void  in
    switch state {
    case .began:
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    case .ended:
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

public final class DSRequestPlugin: PluginType {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        //make sure we have a URL string to display
        guard let requestURLString = request.request?.url?.absoluteString else { return }
        
        //create alert view controller with a single action
        let alertViewController = UIAlertController(title: "Sending Request", message: requestURLString, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        //and present using the view controller we created at initialization
        viewController.present(alertViewController, animated: true)
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        //only continue if result is a failure
        guard case Result.failure(_) = result else { return }
        
        //create alert view controller with a single action and messing displaying status code
        let alertViewController = UIAlertController(title: "Error", message: "Request failed with status code: \(result.error?.response?.statusCode ?? 0)", preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        //and present using the view controller we created at initialization
        viewController.present(alertViewController, animated: true)
    }
}

