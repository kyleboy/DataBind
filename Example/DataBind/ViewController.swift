//
//  ViewController.swift
//  DataBind
//
//  Created by iyinghui@163.com on 12/01/2021.
//  Copyright (c) 2021 iyinghui@163.com. All rights reserved.
//

import UIKit

import DataBind

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signIn: UIButton!
    
    var user: String?
    var viewModel = ViewModel()
    
    deinit {
        debugPrint("deinit ViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewModel.$account.change(owner: self) { value in
            print("newValue: \(value.newValue ?? ""), oldValue: \(value.oldValue ?? "")")
        }
        
        viewModel.$account.bind(owner: password, keyPath: \UITextField.text)
        viewModel.$account.bind(owner: self, keyPath: \.user)
        viewModel.$account.bind(owner: confirmPassword, transform: { ($0 ?? "") + "3" }, keyPath: \.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func accountChanged(_ sender: UITextField) {
        viewModel.account = sender.text
    }
    
    @IBAction func presentSelf(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController")
        self.present(vc, animated: true, completion: nil)
    }
}


class ViewModel: NSObject {
    @Observable var account: String? = "12"
    @Observable var password: String?
}
