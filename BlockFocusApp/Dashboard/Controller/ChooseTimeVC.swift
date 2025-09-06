//
//  ChooseTimeVC.swift
//  BlockFocusApp
//
//  Created by ancalox on 04/09/25.
//

import UIKit

protocol ChooseTimeVCDelegate: AnyObject {
    
    func chooseTimeDoneDidTap(interval: Double)
    
}

class ChooseTimeVC: UIViewController {
    
    @IBOutlet weak var timePickerView: UIDatePicker!
    
    private var viewModel = ChooseTimeVM()
    
    weak var delegate: ChooseTimeVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        timePickerView.setValue(UIColor.lightGray, forKeyPath: "textColor")
    }

    @IBAction func doneButtonClick(_ sender: CustomButton) {
        let time = timePickerView.countDownDuration
        delegate?.chooseTimeDoneDidTap(interval: time)
        self.dismiss(animated: true)
    }
    
}
