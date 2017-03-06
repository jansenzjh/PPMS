//
//  DashboardViewController.swift
//  PPMS
//
//  Created by Jansen on 2/17/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import SideMenu
import FontAwesome
import SwiftyTimer
import Eureka
import KRAlertController
import Format
import SwiftyUserDefaults

class DashboardViewController: FormViewController, RevMobAdsDelegate {

    @IBOutlet weak var btnMenuOutlet: UIBarButtonItem!
    
    var currentClockIn = TimeClock().GetCurrentTimeClock()
    var timeClockCount = 0
    var clockTimer = Timer()
    let projects = Project().GetAllProjects(isActiveOnly: true)
    var rewardedVideo: RevMobFullscreen?
    let AD_SHOW_INTERVAL = 3
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.IsPaidAd] = PPMSProducts.store.isProductPurchased(PPMSProducts.AdRemoveProduct)
        Defaults[.IsPaidAd] = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Defaults[.IsPaidAd] {
            let completionBlock: () -> Void = {
                RevMobAds.session().showFullscreen()
            }
            let errorBlock: (Error?) -> Void = {error in
                // check the error
                print(error ?? "error in ad")
            }
            RevMobAds.startSession(withAppID: "58ba560427c28c615fa23089", withSuccessHandler: completionBlock, andFailHandler: errorBlock)
            
        }
        
        self.uiInit()
        self.timeclockInit()
        
        form +++ Section("Time Clock")
            <<< LabelRow("lblTime"){
                $0.title = "Project Time"
                $0.value = "00:00:00"
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< PushRow<String>("ProjectGID") {
                let projs = Project().GetAllProjectName()
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .folderOpen, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                $0.options = projs
                $0.title = "Clock in"
                if self.currentClockIn.ProjectGID.characters.count > 0{
                    $0.value = Project().GetProjectNameByGuid(guid: (self.currentClockIn.ProjectGID))
                    
                }
                
                $0.disabled = Condition.function(["lblTime"], { form in
                    return (((form.rowBy(tag: "lblTime") as? LabelRow)?.value != "00:00:00") )
                })
                
                if projs.count == 0 {
                    $0.selectorTitle = "Please create Project first!"
                }else{
                    $0.selectorTitle = "Choose a Project"
                }
                
                }.onChange{  row in
                    if row.value != nil {
                        //insert new clock in
                        let tc = TimeClock()
                        tc.ProjectGID = Project().GetProjectGuidByName(name: row.value! as String)
                        tc.IsClockIn = true
                        TimeClock().Insert(timeClock: tc)
                        self.currentClockIn.Guid = tc.Guid
                        self.currentClockIn.ProjectGID = tc.ProjectGID
                        //update time clock
                        self.startTimer()
                        //update clock in count
                        Defaults[.ClockInCount] += 1
                    }
                    
                    
                }.onCellSelection{ row in
                    if !Defaults[.IsPaidAd] && Defaults[.ClockInCount] > 0 && Defaults[.ClockInCount] % self.AD_SHOW_INTERVAL == 0{
                        KRAlertController(title: "Ad Time", message: "Every 3 times you clock in, you will watch a video. You can continue your work after that.You also can pay the In-App Purchase in Menu to remove Ad. Thank you!")
                            .addAction(title: "OK"){ action, textFields in
                                
                                //Run the Ad
                                self.loadRewardedVideo()
                            }
                            .showInformation(icon: true)
                    }
                    row.1.options = Project().GetAllProjectName()
            
            }
            
            <<< ButtonRow("btnClockOut"){
                $0.title = "Clock Out"
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .signOut, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                $0.hidden = Condition.function(["lblTime"], { form in
                    return (((form.rowBy(tag: "lblTime") as? LabelRow)?.value == "00:00:00") )
                })
                }.onCellSelection {row in
                    KRAlertController(title: "Clock Out", message: "Comment for this time punch!")
                        .addCancel()
                        .addTextField({ (textField) in
                            textField.placeholder = "Comment"
                            textField.isSecureTextEntry = false
                            textField.becomeFirstResponder()
                        })
                        .addAction(title: "OK") { action, textFields in
                            let desc = textFields[0].text!
                            self.currentClockIn.Description = desc
                            self.currentClockIn.IsClockIn = false
                            self.currentClockIn.EndDate = Date()
                            TimeClock().Update(timeClock: self.currentClockIn)
                            self.currentClockIn = TimeClock()
                            //stop timer
                            self.stopTimer()
                            //hide clock out button
                            let projRow = self.form.rowBy(tag: "ProjectGID") as? PushRow<String>
                            projRow?.baseValue = nil
                            projRow?.updateCell()
                            
                        }
                        .showEdit(icon: true)
                    
            
            }
            +++ Section("Top Information")
            <<< LabelRow("Project"){
                $0.title = "Project Total"
                $0.value = String(projects.count)
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .folderOpen, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< LabelRow("Tasks"){
                $0.title = "Tasks Total"
                $0.value = String(Task().GetAllProjects(isActiveOnly: true).count)
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .tasks, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< LabelRow("closingProject"){
                $0.title = "Deadline Project"
                if projects.count > 0{
                    $0.value = projects[0].Name
                }else{
                    $0.value = "Plz create project"
                }
                
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            
            +++ Section("Financial")
            <<< LabelRow("totalInvoice"){
                $0.title = "Total Invoices"
                $0.value = String(Bill().Count())
                
                
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .money, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< LabelRow("totalEarn"){
                $0.title = "Total Earn"
                $0.value = Bill().TotalEarn().format(Currency.USD)
                
                
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .money, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            
            
            
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer(){
        self.clockTimer = Timer.every(1.second) {
            let taxTotalRow: LabelRow? = self.form.rowBy(tag: "lblTime")
            self.timeClockCount  = self.timeClockCount + 1
            taxTotalRow?.value = self.seconds2Timestamp(intSeconds: self.timeClockCount)
            taxTotalRow?.reload()
        }
    }
    
    func stopTimer(){
        self.clockTimer.invalidate()
        let taxTotalRow: LabelRow? = self.form.rowBy(tag: "lblTime")
        self.timeClockCount  = 0
        taxTotalRow?.value = "00:00:00"
        taxTotalRow?.reload()
    }
    
    func timeclockInit(){
        if currentClockIn.ProjectGID.characters.count > 0{
            //currently clock in
            timeClockCount = Int(Date().timeIntervalSince(currentClockIn.StartDate!))
            self.startTimer()
        }else{
            
        }
    }
    
    func uiInit() {
        btnMenuOutlet.image = UIImage.fontAwesomeIcon(name: .bars, textColor: UIColor.black, size: CGSize(width: 30, height: 30))
        btnMenuOutlet.title = ""
        
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func seconds2Timestamp(intSeconds:Int)->String {
        let hours = Int(intSeconds) / 3600
        let minutes = Int(intSeconds) / 60 % 60
        let seconds = Int(intSeconds) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    // MARK: - Ad Delegate
    func loadRewardedVideo(){
        rewardedVideo = RevMobAds.session().fullscreen()
        rewardedVideo!.delegate = self
        rewardedVideo!.loadRewardedVideo()
    }
    func showLoadedRewardedVideo(){
        if(rewardedVideo != nil) {
            rewardedVideo!.showRewardedVideo()
        }
    }
    func revmobRewardedVideoDidLoad(_ placementId: String!) {
        NSLog("[RevMob Sample App] Received Rewarded Video of Placement id:\(placementId)")
        self.showLoadedRewardedVideo()
    }
    
    
    
    
    func revmobRewardedVideoDidFailWithError(_ error: Error!, onPlacement placementId: String!) {
        NSLog("[RevMob Sample App] Rewarded Video of placement: \(placementId) failed with error: \(error.localizedDescription)")
        
    }
    
    func revmobRewardedVideoDidStart(_ placementId: String!) {
        NSLog("[RevMob Sample App] Rewarded Video of placement Id: \(placementId) started")
    }
    func revmobUserDidCloseRewardedVideo(_ placementId: String!) {
        NSLog("[RevMob Sample App] Rewarded Video of placement Id: \(placementId) completed")
    }
    func revmobRewardedPreRollDidDisplay(_ placementId: String!) {
        NSLog("[RevMob Sample App] Rewarded Video of placement Id: \(placementId) finished")
    }
    func revmobRewardedVideoNotCompletelyLoaded(_ placementId: String!) {
        NSLog("[RevMob Sample App] Rewarded Video of placement Id: \(placementId) not loaded yet")
    }
    
    
}























