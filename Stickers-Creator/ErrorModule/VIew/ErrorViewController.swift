//
//  ErrorViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 21.05.2022.
//

import UIKit

class ErrorViewController: UIViewController {
    weak var presenter: ErrorPresenterInputProtocol?
    
    @IBOutlet weak var errorCodeLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBAction func backToMainModuleButton(_ sender: Any) {
        presenter?.tapOnBackButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setErrorCode()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension ErrorViewController: ErrorViewPresenterOutputProtocol {
    func showError(code: Int, message: String) {
        errorCodeLabel.text = "Code: \(code)"
        errorMessageLabel.text = "Message: \(message)"
        self.reloadInputViews()
    }
}
