//
//  SimpleFormAlertController.swift
//
//  Created by Haizhen Lee on 15/11/13.
//

import UIKit
import BXiOSUtils

open class SimpleFormAlertController: UIAlertController {

    open var cancelButtonTitle:String = i18n("取消")
    open var okButtonTitle:String = i18n("确定")
    open var shouldShowCancelButton = true
    open var onFormSubmitCallback:  (([String:String]) -> Void)?
    public var textFieldConfigure:((UITextField) -> Void)?
  
    override open func viewDidLoad() {
        super.viewDidLoad()
        if shouldShowCancelButton{
          addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel,handler:nil))
        }
        addAction(UIAlertAction(title: okButtonTitle, style: .default){ _ in
            var form:[String:String] = [:]
            for (name,field) in self.nameFieldMap{
                form[name] = field.text?.trimmed()
            }
            self.onFormSubmitCallback?(form)
        })
    }
    
    fileprivate var nameFieldMap :[String:UITextField] = [:]
  
    open func setupForm(_ form:[String:String]){
        nameFieldMap.removeAll()
        for (name,label):(String,String) in form{
            addTextField{
                textField in
                textField.textColor = UIColor.darkText
                textField.placeholder = label
                textField.borderStyle = .none
                textField.background = nil
                textField.backgroundColor = .white
                self.nameFieldMap[name] = textField
                self.textFieldConfigure?(textField)
            }
        }
    }
  
  public static func prompt(title:String, placeholder:String, text:String? = nil,callback:@escaping (String) -> Void ){
    let controller = SimpleFormAlertController(title: title, message: nil, preferredStyle: .alert)
    controller.textFieldConfigure = { textField in
      textField.text = text
    }
    controller.setupForm(["prompt":placeholder])
    controller.onFormSubmitCallback = { form in
      callback(form["prompt"] ?? "")
    }
    UIApplication.shared.rootViewController?.present(controller, animated: true, completion: nil)
  }
}
