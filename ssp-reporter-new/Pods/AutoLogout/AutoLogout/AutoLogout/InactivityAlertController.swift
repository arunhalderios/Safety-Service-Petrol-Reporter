//
//  InactivityAlertController.swift
//  AutoLogout
//
//  Created by Adnan Yousaf on 26/08/2021.
//

import UIKit

public protocol InactivityAlertControllerDelegate: AnyObject {
    func inactivityAlertControllerDidSelectLogout(_ inactivityAlertController: InactivityAlertController)
    func inactivityAlertControllerDidSelectContinue(_ inactivityAlertController: InactivityAlertController)
}

public class InactivityAlertController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    private let timer: WatchTimer
    public weak var delegate: InactivityAlertControllerDelegate?
    
    public init(timer: WatchTimer) {
        self.timer = timer
        let podBundle = Bundle(for: InactivityAlertController.self)
        super.init(nibName: "InactivityAlertController", bundle: podBundle)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(duration:)")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let observer = TimerObserver(interval: .seconds(1)) { [weak self] timer in
            self?.updateMessage()
        }
        timer.add(observer)
    }
    
    private func setupUI() {
        setup(continueButton)
        updateMessage()
    }
    
    private func setup(_ button: UIButton) {
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
    }
    
    private func updateMessage() {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.roundingMode = .up
        let remainingSeconds = timer.remainingTime?.in(.seconds) ?? 0
        let formattedSeconds = numberFormatter.string(from: remainingSeconds as NSNumber)!
        messageLabel.text = "You will be logged out in "  + formattedSeconds + " Seconds due to inactivity"
    }
    
    
    @IBAction func continueTapped(_ sender: Any) {
        delegate?.inactivityAlertControllerDidSelectContinue(self)
    }
    
}
