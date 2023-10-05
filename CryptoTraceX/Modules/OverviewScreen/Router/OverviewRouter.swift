//
//  OverviewRouter.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import UIKit

protocol OverviewRouterProtocol: AnyObject {
    
    func showDetaileScreen(coinName: String)
    func showWebsite(url: String)
    func showAlert()
}

final class OverviewRouter: OverviewRouterProtocol {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let alertControllerCornerRadius: CGFloat = 10
        }
        
        
        enum Text {
            static let alertControllerTitle: String = "Warning"
            static let alertControllerActionTitle: String = "Ok"
            static let showWebsiteURLError: String = "Could not open URL"
            static let alertControllerMessage: String = """
                                                        The information provided here is for informational purposes only.
                                                        Financial decisions should be made with caution.
                                                        """
        }
    }
    
    // MARK: - Private Properties
    
    private var overViewController: UIViewController?
    
    // MARK: - Initializer
    
    init(viewController: UIViewController) {
        self.overViewController = viewController
    }
    
    // MARK: - Methods
    
    func showDetaileScreen(coinName: String) {
        let detailViewController = DetailBuilder(coinName: coinName).toPresent()
        detailViewController.modalPresentationStyle = .fullScreen
        overViewController?.show(detailViewController, sender: nil)
    }
    
    func showWebsite(url: String) {
        guard let finallURL = URL(string: url) else {
            return
        }
        if UIApplication.shared.canOpenURL(finallURL) {
            UIApplication.shared.open(finallURL, options: [:], completionHandler: nil)
        } else {
            print(Constants.Text.showWebsiteURLError)
        }
    }
    
    func showAlert(){
        let alertController = UIAlertController(
            title: Constants.Text.alertControllerTitle,
            message: Constants.Text.alertControllerMessage,
            preferredStyle: .alert
        )
        let customAction = UIAlertAction(title: Constants.Text.alertControllerActionTitle, style: .cancel)
        alertController.addAction(customAction)
        alertController.view.tintColor = UIColor.white
        alertController.view.backgroundColor = UIColor.black
        alertController.view.layer.cornerRadius = Constants.Layout.alertControllerCornerRadius
        overViewController?.present(alertController, animated: true, completion: nil)
    }
}
