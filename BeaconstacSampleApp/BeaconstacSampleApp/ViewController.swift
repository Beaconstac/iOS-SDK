//
//  ViewController.swift
//  SampleApp
//
//  Created by Sachin Vas on 21/11/17.
//  Copyright © 2017 MobStac. All rights reserved.
//

import UIKit
import Beaconstac
import CoreLocation

class ViewController: UITableViewController {

    var beacons = [MBeacon]()
    var isShowingToast: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Beacons"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeaconCell", for: indexPath) as! BeaconTableViewCell
        let beacon = beacons[indexPath.row]
        cell.name.text = beacon.name
        cell.major.text = "\(beacon.hardware.major)"
        cell.minor.text = "\(beacon.hardware.minor)"
        cell.uuid.text = "\(beacon.hardware.UUID)"
        if beacon.isCampedOn {
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
}

extension ViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/3, y: self.view.frame.size.height/5, width: 0, height: 0))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        if !isShowingToast {
            isShowingToast = true
            UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {[weak self] (isCompleted) in
                toastLabel.removeFromSuperview()
                self?.isShowingToast = false
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {[weak self] in
                self?.showToast(message: message)
            })
        }
    }
}

extension ViewController: BeaconDelegate {
    func didFail(_ error: Error) {
        print(error)
    }
    
    func didEnterRegion(_ region: String) {
        showToast(message: "Region Entered \(region)")
    }
    
    func didRangeBeacons(_ beacons: [MBeacon]) {
        self.beacons = beacons
        tableView.reloadData()
    }
    
    func campOnBeacon(_ beacon: MBeacon) {
        tableView.reloadData()
        showToast(message: "Camped On \(beacon.name)")
    }
    
    func exitBeacon(_ beacon: MBeacon) {
        tableView.reloadData()
        showToast(message: "Exit \(beacon.name)")
    }
    
    func didExitRegion(_ region: String) {
        tableView.reloadData()
        showToast(message: "Region Exited \(region)")
    }
}

extension ViewController: RuleProcessorDelegate {
    func willTriggerRule(_ rule: MRule) {
        // Check which rule is going to be triggred..
    }
    
    func didTriggerRule(_ rule: MRule) {
        // Check which rule is triggred..
    }
}

extension ViewController: NotificationDelegate {
    func overrideNotification(_ notification: MNotification) {
        // Override the notification.
    }
}

extension ViewController: WebhookDelegate {
    func addParameters(_ webhook: MWebhook) -> Dictionary<String, Any> {
        // retrun your values...
        return [:]
    }
}
