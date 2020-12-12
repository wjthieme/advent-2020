//
//  Controller.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2020.
//

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {
    
    @IBOutlet weak private var itemPicker: NSPopUpButton!
    @IBOutlet weak private var itemMenu: NSMenu!
    @IBOutlet weak private var inputField: NSTextView!
    @IBOutlet weak private var outputField: NSTextField!
    @IBOutlet weak private var activityIndicator: NSProgressIndicator!
    @IBOutlet weak private var timeLabel: NSTextField!
    
    private var workItem: DispatchWorkItem?
    private let workQueue = DispatchQueue.global(qos: .userInteractive)
    
    private var prevTime: UInt64 = 0
    
    private var selectedPuzzle: Puzzle {
        get { return Puzzle(rawValue: UserDefaults.standard.string(forKey: "Puzzle") ?? "") ?? Puzzle.allCases[0] }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "Puzzle") }
    }
    
    private var inputString: String {
        get { return UserDefaults.standard.string(forKey: "Input") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "Input") }
    }
    
    private lazy var timebaseInfo: mach_timebase_info = {
        var info = mach_timebase_info_data_t()
        mach_timebase_info(&info)
        return info
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        Puzzle.allCases.forEach { itemMenu.addItem(withTitle: $0.rawValue, action: #selector(didSelectItem), keyEquivalent: "") }
        
        inputField.string = inputString
        itemPicker.select(itemMenu.item(withTitle: selectedPuzzle.rawValue))
        
        
        solve()
    }

    @objc private func didSelectItem(sender: NSMenu) {
        selectedPuzzle = Puzzle(rawValue: sender.title)!
        solve()
    }
    
    func textDidChange(_ notification: Notification) {
        inputString = inputField.string.trimmingCharacters(in: .whitespacesAndNewlines)
        solve()
    }
    
    private func solve() {
        workItem?.cancel()
        workItem = DispatchWorkItem { [self] in
            let result = selectedPuzzle.solve(inputString)
            
            DispatchQueue.main.async { [self] in
                stopLoading()
                outputField.stringValue = result
                workItem = nil
            }
        }
        
        startLoading()
        workQueue.async(execute: workItem!)
    }
    
    private func startLoading() {
        prevTime = mach_absolute_time()
        activityIndicator.startAnimation(self)
        activityIndicator.isHidden = false
        NSAnimationContext.runAnimationGroup { [self] context in
            context.duration = 0.5
            activityIndicator.animator().alphaValue = 1
        }
    }
    
    private func stopLoading() {
        let diff = mach_absolute_time() - prevTime
        let nanos = Double(diff * UInt64(timebaseInfo.numer)) / Double(timebaseInfo.denom) * 1e-9
        timeLabel.stringValue = String(format: "%.2fs", nanos)
        
        NSAnimationContext.runAnimationGroup { [self] context in
            context.duration = 0.5
            activityIndicator.animator().alphaValue = 0
        } completionHandler: { [self] in
            activityIndicator.stopAnimation(self)
            activityIndicator.isHidden = true
        }
    }
}

