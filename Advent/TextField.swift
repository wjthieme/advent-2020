//
//  TextField.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2020.
//

import Cocoa

fileprivate let commandKey = NSEvent.ModifierFlags.command.rawValue
fileprivate let commandShiftKey = NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue

class TextField: NSTextField {
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.type == NSEvent.EventType.keyDown {
            if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue) == commandKey {
                switch event.charactersIgnoringModifiers! {
                case "x": if NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self) { return true }
                case "c": if NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self) { return true }
                case "a": if NSApp.sendAction(#selector(NSResponder.selectAll(_:)), to:nil, from:self) { return true }
                default: break
                }
            }
        }
        return super.performKeyEquivalent(with: event)
    }
}
