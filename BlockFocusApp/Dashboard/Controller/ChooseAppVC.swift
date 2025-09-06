//
//  ChooseAppVC.swift
//  BlockFocusApp
//
//  Created by ancalox on 04/09/25.
//

import UIKit
import SwiftUI
import FamilyControls
import ManagedSettings

protocol ChooseAppVCDelegate: AnyObject {
    
    func chooseAppDoneDidTap(selection: FamilyActivitySelection)
    
}

class ChooseAppVC: UIViewController {

    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var tokenLabel: UILabel!
    
    private var selection = FamilyActivitySelection()
    
    weak var delegate: ChooseAppVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPickerActivity()
    }
    
    func setupPickerActivity() {
        let picker = FamilyActivityPicker(selection: Binding(get: { self.selection },
                                                             set: { self.selection = $0 }))
        
        let hosting = UIHostingController(rootView: picker)
        hosting.view.frame = pickerView.bounds
        pickerView.addSubview(hosting.view)
    }

    @IBAction func doneButtonClick(_ sender: CustomButton) {
        selection.applications.forEach { item in
//            print("id: \(item.token)")
//            print("name: \(item.localizedDisplayName ?? "")")
            
//            tokenLabel.text = "\(item.token)"
//            let app = Application(token: item.token!)
//            tokenLabel.text = app.bundleIdentifier
        }
        
        delegate?.chooseAppDoneDidTap(selection: selection)
        self.dismiss(animated: true)
    }
    
}
