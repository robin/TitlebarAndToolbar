//
//  ViewController.swift
//  TitlebarAndToolbar
//
//  Created by Lu Yibin on 16/3/24.
//  Copyright © 2016年 Lu Yibin. All rights reserved.
//

import Cocoa

extension OptionSet {
    func optionState(_ opt: Self.Element) -> Int {
        return self.contains(opt) ? NSOnState : NSOffState
    }
}

class ViewController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var unifiedTitleAndToolbarCheckbox: NSButton!
    @IBOutlet weak var titleAppearsTransparentCheckbox: NSButton!
    @IBOutlet weak var titleVisibilityCheckbox: NSButton!
    @IBOutlet weak var fullContentViewCheckbox: NSButton!
    @IBOutlet weak var titleAccessoryViewCheckbox: NSButton!
    @IBOutlet weak var titleAccessoryViewLayoutMatrix: NSMatrix!
    @IBOutlet weak var showToolbarCheckbox: NSButton!
    @IBOutlet weak var titleBarCheckBox: NSButton!
    
    @IBOutlet var codeTextView: NSTextView!
    
    var windowControllers = [NSWindowController]()
    
    var titleAccessoryViewEnabled : Bool {
        return self.titleAccessoryViewCheckbox.state == NSOnState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.codeTextView.font = NSFont(name: "Monaco", size: 12)
        generateCode()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func showWindowWithTitle(_ controller:NSWindowController, title:String) {
        windowControllers.append(controller)
        controller.window?.title = title
        controller.showWindow(self)
    }

    func instantiateWindowController() -> NSWindowController? {
        if let storyboard = self.storyboard {
            return storyboard.instantiateController(withIdentifier: "windowController") as? NSWindowController
        }
        return nil
    }

    func generateCode() {
        var code : String = ""
        if unifiedTitleAndToolbarCheckbox.state == NSOnState {
            code.append("window.styleMask.insert(NSWindowStyleMask.unifiedTitleAndToolbar)\n")
        } else {
            code.append("window.styleMask.remove(NSWindowStyleMask.unifiedTitleAndToolbar)\n")
        }
        if fullContentViewCheckbox.state == NSOnState {
            code.append("window.styleMask.insert(NSWindowStyleMask.fullSizeContentView)\n")
        } else {
            code.append("window.styleMask.remove(NSWindowStyleMask.fullSizeContentView)\n")
        }
        if titleBarCheckBox.state == NSOnState {
            code.append("window.styleMask.insert(NSWindowStyleMask.titled)\n")
        } else {
            code.append("window.styleMask.remove(NSWindowStyleMask.titled)\n")
        }
        let showToolbar = showToolbarCheckbox.state == NSOnState
        code.append("window.toolbar?.isVisible = \(showToolbar)\n")
        
        let visibility = titleVisibilityCheckbox.state == NSOffState ? ".hidden" : ".visible"
        code.append("window.titleVisibility = \(visibility)\n")
        
        let transparent = titleAppearsTransparentCheckbox.state == NSOnState
        code.append("window.titlebarAppearsTransparent = \(transparent)\n")
        self.codeTextView.string = code
    }
    
    @IBAction func titleAccessoryChecked(_ sender: AnyObject) {
        self.willChangeValue(forKey: "titleAccessoryViewEnabled")
        self.didChangeValue(forKey: "titleAccessoryViewEnabled")
        self.attributeChanged(sender)
    }
    
    @IBAction func attributeChanged(_ sender: AnyObject) {
        generateCode()
    }
    
    func setToDefault() {
        let userDefaults = UserDefaults.standard
        if let defaultStyleMask = self.view.window?.styleMask {
            unifiedTitleAndToolbarCheckbox.state = defaultStyleMask.optionState(NSWindowStyleMask.unifiedTitleAndToolbar)
            userDefaults.set(unifiedTitleAndToolbarCheckbox.state, forKey: "unifiedTitleAndToolbar")
            fullContentViewCheckbox.state = defaultStyleMask.optionState(NSWindowStyleMask.fullSizeContentView)
            userDefaults.set(fullContentViewCheckbox.state, forKey: "fullSizeContentView")
            titleBarCheckBox.state = defaultStyleMask.optionState(NSWindowStyleMask.titled)
            userDefaults.set(titleBarCheckBox.state, forKey: "titleBar")
        }
        self.titleAccessoryViewCheckbox.state = NSOffState
        userDefaults.set(NSOffState, forKey: "hasTitleAccessoryView")
        titleVisibilityCheckbox.state = NSOnState
        userDefaults.set(titleVisibilityCheckbox.state, forKey: "titleVisibility")
        titleAppearsTransparentCheckbox.state = NSOffState
        userDefaults.set(titleAppearsTransparentCheckbox.state, forKey: "transparentTitleBar")
    }
    
    @IBAction func restoreSettings(_ sender: AnyObject) {
        guard let popUpButton = sender as? NSPopUpButton, let item = popUpButton.selectedItem else {
            return
        }
        let userDefaults = UserDefaults.standard
        if item.tag == 1 {
            setToDefault()
        } else if item.tag == 2 {
            setToDefault()
            titleVisibilityCheckbox.state = NSOffState
            userDefaults.set(titleVisibilityCheckbox.state, forKey: "titleVisibility")
            showToolbarCheckbox.state = NSOnState
            userDefaults.set(showToolbarCheckbox.state, forKey:"showToolbar")
        } else if item.tag == 3 {
            setToDefault()
            fullContentViewCheckbox.state = NSOnState
            userDefaults.set(fullContentViewCheckbox.state, forKey: "fullSizeContentView")
            titleVisibilityCheckbox.state = NSOffState
            userDefaults.set(titleVisibilityCheckbox.state, forKey: "titleVisibility")
            titleAppearsTransparentCheckbox.state = NSOnState
            userDefaults.set(titleAppearsTransparentCheckbox.state, forKey: "transparentTitleBar")
            showToolbarCheckbox.state = NSOffState
            userDefaults.set(showToolbarCheckbox.state, forKey:"showToolbar")
            
        }
        generateCode()
    }
    
    @IBAction func launchWindow(_ sender: AnyObject) {
        if let controller = instantiateWindowController() {
            if let window = controller.window {
                if unifiedTitleAndToolbarCheckbox.state == NSOnState {
                    window.styleMask.insert(NSWindowStyleMask.unifiedTitleAndToolbar)
                } else {
                    window.styleMask.remove(NSWindowStyleMask.unifiedTitleAndToolbar)
                }
                if fullContentViewCheckbox.state == NSOnState {
                    window.styleMask.insert(NSWindowStyleMask.fullSizeContentView)
                } else {
                    window.styleMask.remove(NSWindowStyleMask.fullSizeContentView)
                }
                if titleBarCheckBox.state == NSOnState {
                    window.styleMask.insert(NSWindowStyleMask.titled)
                } else {
                    window.styleMask.remove(NSWindowStyleMask.titled)
                }
                window.toolbar?.isVisible = showToolbarCheckbox.state == NSOnState

                showWindowWithTitle(controller, title: "Window")

                if titleAccessoryViewEnabled {
                    if let titlebarController = self.storyboard?.instantiateController(withIdentifier: "titlebarViewController") as? NSTitlebarAccessoryViewController {
                        switch self.titleAccessoryViewLayoutMatrix.selectedRow {
                        case 0:
                            titlebarController.layoutAttribute = .bottom
                        case 1:
                            titlebarController.layoutAttribute = .left
                        case 2:
                            titlebarController.layoutAttribute = .right
                        default:
                            titlebarController.layoutAttribute = .bottom
                        }
                        
                        // layoutAttribute has to be set before added to window
                        window.addTitlebarAccessoryViewController(titlebarController)
                    }
                }
                window.titleVisibility = titleVisibilityCheckbox.state == NSOffState ? .hidden : .visible
                window.titlebarAppearsTransparent = titleAppearsTransparentCheckbox.state == NSOnState
            }
        }
    }

}

