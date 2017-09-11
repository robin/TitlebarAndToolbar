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
        return self.contains(opt) ? NSControl.StateValue.on.rawValue : NSControl.StateValue.off.rawValue
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
    
    @objc dynamic var titleAccessoryViewEnabled : Bool {
        return self.titleAccessoryViewCheckbox.state == NSControl.StateValue.on
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
            return storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "windowController")) as? NSWindowController
        }
        return nil
    }

    func generateCode() {
        var code : String = ""
        if unifiedTitleAndToolbarCheckbox.state == NSControl.StateValue.on {
            code.append("window.styleMask.insert(NSWindow.StyleMask.unifiedTitleAndToolbar)\n")
        } else {
            code.append("window.styleMask.remove(NSWindow.StyleMask.unifiedTitleAndToolbar)\n")
        }
        if fullContentViewCheckbox.state == NSControl.StateValue.on {
            code.append("window.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)\n")
        } else {
            code.append("window.styleMask.remove(NSWindow.StyleMask.fullSizeContentView)\n")
        }
        if titleBarCheckBox.state == NSControl.StateValue.on {
            code.append("window.styleMask.insert(NSWindow.StyleMask.titled)\n")
        } else {
            code.append("window.styleMask.remove(NSWindow.StyleMask.titled)\n")
        }
        let showToolbar = showToolbarCheckbox.state == NSControl.StateValue.on
        code.append("window.toolbar?.isVisible = \(showToolbar)\n")
        
        let visibility = titleVisibilityCheckbox.state == NSControl.StateValue.off ? ".hidden" : ".visible"
        code.append("window.titleVisibility = \(visibility)\n")
        
        let transparent = titleAppearsTransparentCheckbox.state == NSControl.StateValue.on
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
            unifiedTitleAndToolbarCheckbox.state = NSControl.StateValue(rawValue: defaultStyleMask.optionState(NSWindow.StyleMask.unifiedTitleAndToolbar))
            userDefaults.set(unifiedTitleAndToolbarCheckbox.state, forKey: "unifiedTitleAndToolbar")
            fullContentViewCheckbox.state = NSControl.StateValue(rawValue: defaultStyleMask.optionState(NSWindow.StyleMask.fullSizeContentView))
            userDefaults.set(fullContentViewCheckbox.state, forKey: "fullSizeContentView")
            titleBarCheckBox.state = NSControl.StateValue(rawValue: defaultStyleMask.optionState(NSWindow.StyleMask.titled))
            userDefaults.set(titleBarCheckBox.state, forKey: "titleBar")
        }
        self.titleAccessoryViewCheckbox.state = NSControl.StateValue.off
        userDefaults.set(NSControl.StateValue.off, forKey: "hasTitleAccessoryView")
        titleVisibilityCheckbox.state = NSControl.StateValue.on
        userDefaults.set(titleVisibilityCheckbox.state, forKey: "titleVisibility")
        titleAppearsTransparentCheckbox.state = NSControl.StateValue.off
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
            titleVisibilityCheckbox.state = NSControl.StateValue.off
            userDefaults.set(titleVisibilityCheckbox.state, forKey: "titleVisibility")
            showToolbarCheckbox.state = NSControl.StateValue.on
            userDefaults.set(showToolbarCheckbox.state, forKey:"showToolbar")
        } else if item.tag == 3 {
            setToDefault()
            fullContentViewCheckbox.state = NSControl.StateValue.on
            userDefaults.set(fullContentViewCheckbox.state, forKey: "fullSizeContentView")
            titleVisibilityCheckbox.state = NSControl.StateValue.off
            userDefaults.set(titleVisibilityCheckbox.state, forKey: "titleVisibility")
            titleAppearsTransparentCheckbox.state = NSControl.StateValue.on
            userDefaults.set(titleAppearsTransparentCheckbox.state, forKey: "transparentTitleBar")
            showToolbarCheckbox.state = NSControl.StateValue.off
            userDefaults.set(showToolbarCheckbox.state, forKey:"showToolbar")
            
        }
        generateCode()
    }
    
    @IBAction func launchWindow(_ sender: AnyObject) {
        if let controller = instantiateWindowController() {
            if let window = controller.window {
                if unifiedTitleAndToolbarCheckbox.state == NSControl.StateValue.on {
                    window.styleMask.insert(NSWindow.StyleMask.unifiedTitleAndToolbar)
                } else {
                    window.styleMask.remove(NSWindow.StyleMask.unifiedTitleAndToolbar)
                }
                if fullContentViewCheckbox.state == NSControl.StateValue.on {
                    window.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
                } else {
                    window.styleMask.remove(NSWindow.StyleMask.fullSizeContentView)
                }
                if titleBarCheckBox.state == NSControl.StateValue.on {
                    window.styleMask.insert(NSWindow.StyleMask.titled)
                } else {
                    window.styleMask.remove(NSWindow.StyleMask.titled)
                }
                window.toolbar?.isVisible = showToolbarCheckbox.state == NSControl.StateValue.on

                showWindowWithTitle(controller, title: "Window")

                if titleAccessoryViewEnabled {
                    if let titlebarController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "titlebarViewController")) as? NSTitlebarAccessoryViewController {
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
                window.titleVisibility = titleVisibilityCheckbox.state == NSControl.StateValue.off ? .hidden : .visible
                window.titlebarAppearsTransparent = titleAppearsTransparentCheckbox.state == NSControl.StateValue.on
            }
        }
    }

}

