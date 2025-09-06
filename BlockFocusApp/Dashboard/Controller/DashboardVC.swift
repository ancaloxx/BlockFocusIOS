//
//  ViewController.swift
//  BlockFocusApp
//
//  Created by ancalox on 04/09/25.
//

import UIKit
import SwiftUI
import FamilyControls
import ManagedSettings
import Kingfisher
import SnapKit

class DashboardVC: UIViewController {

    @IBOutlet weak var chooseTimeButton: CustomButton!
    @IBOutlet weak var chooseTimeStackView: UIStackView!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var appCollectionView: UICollectionView!
    @IBOutlet weak var stopButton: CustomButton!
    @IBOutlet weak var lockLabel: UILabel!
    @IBOutlet weak var editView: CustomView!
    @IBOutlet weak var bubbleTableView: UITableView!
    @IBOutlet weak var lockImage: CustomImageView!
    @IBOutlet weak var stoppedStackView: UIStackView!
    @IBOutlet weak var stoppedLabel: UILabel!
    @IBOutlet weak var powerReducedLabel: UILabel!
    
    private var store = ManagedSettingsStore()
    private var viewModel = DashboardVM()
    private var timer: Timer?
    
    private var blockAppCellSnaps = [UIView]()
    private var blockAppCellFrames = [CGRect]()
    
    private var listAppView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addCellRegister()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.requestScreenTimeAuth()
        }
        
//        store.clearAllSettings()
        
        viewModel.isShield = Constants.userDefaults?.bool(forKey: "isShield") ?? false
        
        if viewModel.isShield {
            timer?.invalidate()
            timer = nil
            
            hideChooseTimeView()
            startCountdown()
            
            moveBlockAppCCellWithAnimation()
        } else {
            Constants.userDefaults?.set(3600, forKey: "timeInterval")
        }
    }
    
    private func setupUI() {
        appCollectionView.delegate = self
        appCollectionView.dataSource = self
        
        bubbleTableView.delegate = self
        bubbleTableView.dataSource = self
        bubbleTableView.showsVerticalScrollIndicator = false
        
        let chooseAppsView = ChooseAppsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: chooseAppsView)
        listAppView = hostingController.view!
        listAppView.backgroundColor = UIColor.clear
        
        addChild(hostingController)
        editView.addSubview(listAppView)
        hostingController.didMove(toParent: self)
        
        listAppView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-80)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    private func addCellRegister() {
        let blockAppCCell = UINib(nibName: "BlockAppCCell", bundle: nil)
        appCollectionView.register(blockAppCCell,
                                   forCellWithReuseIdentifier: "blockAppCCell")
        
        let bubbleCell = UINib(nibName: "BubbleCell", bundle: nil)
        bubbleTableView.register(bubbleCell,
                                 forCellReuseIdentifier: "bubbleCell")
        
        let bubbleDotCell = UINib(nibName: "BubbleDotCell", bundle: nil)
        bubbleTableView.register(bubbleDotCell,
                                 forCellReuseIdentifier: "bubbleDotCell")
    }
    
    private func goToChooseTimeVC() {
        guard let chooseTimeVC = Constants.DashboardStoryboard.instantiateViewController(withIdentifier: "ChooseTimeVC") as? ChooseTimeVC,
              let sheet = chooseTimeVC.sheetPresentationController else {
            return
        }
        
        sheet.detents = [
            .custom { _ in
                return 250
            }
        ]
        
        sheet.prefersGrabberVisible = true
        
        chooseTimeVC.delegate = self
        
        self.present(chooseTimeVC,
                     animated: true)
    }
    
    private func requestScreenTimeAuth() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                print("permission success")
            } catch {
                print("get permission failed")
            }
        }
    }
    
    private func goToChooseAppVC() {
        guard let chooseAppVC = Constants.DashboardStoryboard.instantiateViewController(withIdentifier: "ChooseAppVC") as? ChooseAppVC else {
            return
        }
        
        chooseAppVC.delegate = self
        
        self.present(chooseAppVC,
                     animated: true)
    }
    
    private func showChooseTimeView() {
        chooseTimeStackView.isHidden = false
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: .curveEaseInOut,
                       animations: {
            self.chooseTimeStackView.alpha = 1
        })
        
        lockLabel.isHidden = false
        editView.isHidden = false
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.lockLabel.alpha = 1
            self.editView.alpha = 1
        })
        
        leftTimeLabel.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.leftTimeLabel.alpha = 0
        }, completion: { _ in
            self.leftTimeLabel.isHidden = true
        })
        
        stopButton.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.stopButton.alpha = 0
        }, completion: { _ in
            self.stopButton.isHidden = true
        })
    }
    
    private func hideChooseTimeView() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.chooseTimeStackView.alpha = 0
        }, completion: { _ in
            self.chooseTimeStackView.isHidden = true
        })
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.lockLabel.alpha = 0
            self.editView.alpha = 0
        }, completion: { _ in
            self.editView.isHidden = true
        })
        
        hideStoppedTime()
        
        leftTimeLabel.isHidden = false
        
        UIView.animate(withDuration: 1,
                       delay: 2,
                       options: .curveEaseInOut,
                       animations: {
            self.leftTimeLabel.alpha = 1
        })
        
        stopButton.isHidden = false
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 1,
                       delay: 10,
                       options: .curveEaseInOut,
                       animations: {
            self.stopButton.alpha = 1
        })
    }
    
    private func setupLeftTime() {
        let userDefaults = Constants.userDefaults
        let timeInterval = userDefaults?.double(forKey: "timeInterval") ?? 0
        
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        
        let combineText = "\(hours)h \(minutes)m left..."
        leftTimeLabel.text = combineText
    }
    
    private func startCountdown() {
        timer?.invalidate()
        timer = nil
        
        setupLeftTime()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1,
                                     repeats: true) { _ in
            self.setupLeftTime()
            
            let timeInterval = Constants.userDefaults?.double(forKey: "timeInterval") ?? 0
            Constants.userDefaults?.set(timeInterval - 1, forKey: "timeInterval")
            
            self.viewModel.timeInterval = timeInterval - 1
        }
    }
    
    private func moveBlockAppCCellWithAnimation() {
        if viewModel.isShield {
//            blockAppCellSnaps.removeAll()
//            blockAppCellFrames.removeAll()
//            
//            for item in 0..<appCollectionView.numberOfItems(inSection: 0) {
//                if let cell = appCollectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? BlockAppCCell {
//                    let snapshot = cell.snapshotView(afterScreenUpdates: false)!
//                    snapshot.frame = appCollectionView.convert(cell.frame, to: view)
//                    self.view.addSubview(snapshot)
//                    
//                    blockAppCellSnaps.append(snapshot)
//                    blockAppCellFrames.append(snapshot.frame)
//                    
//                    cell.isHidden = true
//                    
//                    let targetY = self.view.bounds.midY + 22
//                    
//                    UIView.animate(withDuration: 3,
//                                   delay: 0.2 * Double(item),
//                                   usingSpringWithDamping: 0.8,
//                                   initialSpringVelocity: 0.6,
//                                   options: .curveEaseInOut,
//                                   animations: {
//                        snapshot.center = CGPoint(x: self.view.bounds.midX, y: targetY)
//                    })
//                    
//                    UIView.animate(withDuration: 1,
//                                   delay: 0.5 * Double(item),
//                                   options: .curveEaseInOut,
//                                   animations: {
//                        snapshot.alpha = 0
//                        snapshot.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//                    })
//                }
//            }
            
//            viewModel.animateToCenter = true
        
            for (index, item) in listAppView.subviews.enumerated() {
                let snapshot = item.snapshotView(afterScreenUpdates: false)!
                snapshot.frame = appCollectionView.convert(item.frame, to: view)
                self.view.addSubview(snapshot)
                
                blockAppCellSnaps.append(snapshot)
                blockAppCellFrames.append(snapshot.frame)
                
                item.isHidden = true
                
                let targetY = self.view.bounds.midY + 44
                
                UIView.animate(withDuration: 3,
                               delay: 0.2 * Double(index),
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.6,
                               options: .curveEaseInOut,
                               animations: {
                    snapshot.center = CGPoint(x: self.view.bounds.midX, y: targetY)
                })
                
                UIView.animate(withDuration: 1,
                               delay: 0.5 * Double(index),
                               options: .curveEaseInOut,
                               animations: {
                    snapshot.alpha = 0
                    snapshot.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                })
            }
        } else {
//            viewModel.animateToCenter = false
            
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.6,
                           options: .curveEaseInOut,
                           animations: {
                for (i, snap) in self.blockAppCellSnaps.enumerated() {
                    snap.alpha = 1
                    snap.frame = self.blockAppCellFrames[i]
                }
            }, completion: { _ in
                for snap in self.blockAppCellSnaps {
                    snap.removeFromSuperview()
                }
                
                for (index, item) in self.listAppView.subviews.enumerated() {
                    item.isHidden = false
                    
                    self.blockAppCellSnaps.removeAll()
                    self.blockAppCellFrames.removeAll()
                }
            })
        }
    }
    
    private func showBubble() {
        bubbleTableView.isHidden = false
        
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.bubbleTableView.alpha = 1
            self.lockImage.alpha = 0
        }, completion: { _ in
            self.lockImage.isHidden = true
        })
        
        stopButton.setTitle("Stop Early", for: .normal)
    }
    
    private func hideBubble() {
        self.lockImage.isHidden = false
        
        
        
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.bubbleTableView.alpha = 0
            self.lockImage.alpha = 1
            self.stoppedStackView.alpha = 1
        }, completion: { _ in
            self.bubbleTableView.isHidden = true
        })
        
        stopButton.setTitle("Stop", for: .normal)
        
        showChooseTimeView()
    }
    
    private func showStoppedTime() {
        stoppedStackView.isHidden = false
        
        let timeInterval = Constants.userDefaults?.double(forKey: "timeInterval") ?? 0
        
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        
        let hoursText = hours > 1 ? "\(hours) Hours" : "\(hours) Hour"
        let minutesText = minutes > 1 ? "\(minutes) Minutes" : "\(minutes) Minute"
        let combineText = "\(hoursText) \(minutesText)"
        
        stoppedLabel.text = "Stopped \(combineText) early"
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.stoppedStackView.alpha = 1
        })
    }
    
    private func hideStoppedTime() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.stoppedStackView.alpha = 0
        }, completion: { _ in
            self.stoppedStackView.isHidden = true
        })
    }

    @IBAction func chooseTimeButtonClick(_ sender: CustomButton) {
        goToChooseTimeVC()
    }
    
    @IBAction func startButtonClick(_ sender: CustomButton) {
        viewModel.isShield = true
        
        Constants.userDefaults?.set(true, forKey: "isShield")
        
        if viewModel.isShield {
            viewModel.startShield()
            
            hideChooseTimeView()
            startCountdown()
            
            moveBlockAppCCellWithAnimation()
        }
    }
    
    @IBAction func editButtonClick(_ sender: CustomButton) {
        goToChooseAppVC()
    }
    
    @IBAction func stopButtonClick(_ sender: CustomButton) {
        viewModel.isShield = false
        
        Constants.userDefaults?.set(false, forKey: "isShield")
        
        if viewModel.isStopEarly {
            viewModel.stopShield()
            
            hideBubble()
            
            timer?.invalidate()
            timer = nil
            
            moveBlockAppCCellWithAnimation()
            showStoppedTime()
        } else {
            viewModel.isStopEarly = true
            
            showBubble()
        }
    }
    
}

extension DashboardVC: ChooseTimeVCDelegate {
    
    func chooseTimeDoneDidTap(interval: Double) {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        let hoursText = hours > 1 ? "\(hours) Hours" : "\(hours) Hour"
        let minutesText = minutes > 1 ? "\(minutes) Minutes" : "\(minutes) Minute"
        let combineText = "\(hoursText) \(minutesText)"
        
        chooseTimeButton.setTitle(combineText, for: .normal)
        
        viewModel.timeInterval = interval
        viewModel.setTimeInterval = interval
    }
    
}

extension DashboardVC: ChooseAppVCDelegate {
    
    func chooseAppDoneDidTap(selection: FamilyActivitySelection) {
        viewModel.selection = selection
        viewModel.updateApplicationSelections()
        
//        let listAppView = ChooseAppsView(selection: selection)
//        let hostingController = UIHostingController(rootView: listAppView)
//        let listView = hostingController.view!
//        listView.backgroundColor = UIColor.clear
//        
//        addChild(hostingController)
//        editView.addSubview(listView)
//        hostingController.didMove(toParent: self)
//        
//        listView.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(8)
//            make.top.equalToSuperview().offset(8)
//            make.trailing.equalToSuperview().offset(-80)
//            make.bottom.equalToSuperview().offset(-8)
////            make.height.equalTo(300)
//        }
        
        appCollectionView.reloadData()
    }
    
}

extension DashboardVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "blockAppCCell",
                                                            for: indexPath) as? BlockAppCCell else {
            return UICollectionViewCell()
        }
        
        // setup data
        cell.isHidden = viewModel.isShield
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: 44)
    }
    
}

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return Constants.bubbleItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "bubbleDotCell",
                                                           for: indexPath) as? BubbleDotCell else {
                return UITableViewCell()
            }
            
            // setup data
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "bubbleCell",
                                                           for: indexPath) as? BubbleCell else {
                return UITableViewCell()
            }
            
            // setup data
            let item = Constants.bubbleItems[indexPath.row]
            
            cell.bubbleLabel.text = item
            
            return cell
        }
    }
    
}
