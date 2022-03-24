//
//  CardPaymentViewController.swift
//  StripePayIntegration
//
//  Created by Hafiz Fahad Hassan on 22/03/2022.
//

import UIKit
import Stripe
import AFNetworking
class CardPaymentViewController: UITableViewController, UITextViewDelegate {

    // MARK: - Variable

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        return true
    }
    
    // MARK: Methods
    
    func handleError(error: NSError) {
            UIAlertView(title: "Please Try Again",
                message: error.localizedDescription,
                delegate: nil,
                cancelButtonTitle: "OK").show()
            
        }
    
    func postStripeToken(token: STPToken) {
        let amountField:Int? = Int(amountTextField.text ?? "")
        let URL = ""
        let params = ["stripeToken": token.tokenId,
                      "amount": amountField ?? "",
                      "currency": "usd",
                      "description": self.emailTextField.text as Any] as [String : Any]
        
        let manager = AFHTTPRequestOperationManager()
        manager.post(URL, parameters: params, success: { (operation, responseObject) -> Void in
            
            if let response = responseObject as? [String: String] {
                UIAlertView(title: response["status"],
                            message: response["message"],
                            delegate: nil,
                            cancelButtonTitle: "OK").show()
            }
            
        }) { (operation, error) -> Void in
            self.handleError(error: error! as NSError)
        }
    }
    
    // MARK: Actions
    
    @IBAction func StripPayIntegration(sender: AnyObject) {
        // Initiate the card
        let stripCard = STPCard()
           
           // Split the expiration date to extract Month & Year
        if self.expireDateTextField.text?.isEmpty == false {
            let expirationDate = self.expireDateTextField.text?.components(separatedBy: "/")
            let expMonth = UInt(expirationDate?[0] ?? "")
               let expYear = UInt(expirationDate?[1] ?? "")
            
               // Send the card info to Strip to get the token
               stripCard.number = self.cardNumberTextField.text
               stripCard.cvc = self.cvcTextField.text
            stripCard.expMonth = expMonth ?? 0
            stripCard.expYear = expYear ?? 0
           }
        let underlyingError: NSError? = nil
        do {
            try stripCard.validateReturningError()
        } catch {
            
        }
        if underlyingError != nil {
            self.spinner.stopAnimating()
            self.handleError(error: underlyingError!)
            return
        }
        
        STPAPIClient.shared().createToken(with: stripCard, completion: { (token, error) -> Void in
            
            if error != nil {
                self.handleError(error: error! as NSError)
                return
            }
            
            self.postStripeToken(token: token!)
        })
    }
}
