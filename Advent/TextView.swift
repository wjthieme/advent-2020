//
//  TextView.swift
//  Advent
//
//  Created by Wilhelm Thieme on 01/12/2020.
//

import Cocoa

fileprivate let commandKey = NSEvent.ModifierFlags.command.rawValue
fileprivate let commandShiftKey = NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue

class TextView: NSTextView {
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.type == NSEvent.EventType.keyDown {
            if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue) == commandKey {
                switch event.charactersIgnoringModifiers! {
                case "x": if NSApp.sendAction(#selector(NSText.cut(_:)), to:nil, from:self) { return true }
                case "c": if NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self) { return true }
                case "v": if NSApp.sendAction(#selector(NSText.paste(_:)), to:nil, from:self) { return true }
                case "z": if NSApp.sendAction(Selector(("undo:")), to:nil, from:self) { return true }
                case "a": if NSApp.sendAction(#selector(NSResponder.selectAll(_:)), to:nil, from:self) { return true }
                default: break
                }
            }
            else if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue) == commandShiftKey {
                if event.charactersIgnoringModifiers == "Z" {
                    if NSApp.sendAction(Selector(("redo:")), to:nil, from:self) { return true }
                }
            }
        }
        return super.performKeyEquivalent(with: event)
    }
}
