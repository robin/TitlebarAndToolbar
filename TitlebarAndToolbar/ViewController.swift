//
//  ViewController.swift
//  TitlebarAndToolbar
//
//  Created by Lu Yibin on 16/3/24.
//  Copyright © 2016年 Lu Yibin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var unifiedTitleAndToolbarCheckbox: NSButton!
    @IBOutlet weak var titleAppearsTransparentCheckbox: NSButton!
    @IBOutlet weak var titleVisibilityCheckbox: NSButton!
    @IBOutlet weak var fullContentViewCheckbox: NSButton!
    @IBOutlet weak var titleAccessoryViewCheckbox: NSButton!
    @IBOutlet weak var titleAccessoryViewLayoutMatrix: NSMatrix!
    @IBOutlet weak var showToolbarCheckbox: NSButton!
    @IBOutlet weak var titleBarCheckBox: NSButton!
    
    var windowControllers = [NSWindowController]()
    
    var titleAccessoryViewEnabled : Bool {
        return self.titleAccessoryViewCheckbox.state == NSOnState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func titleAccessoryChecked(_ sender: AnyObject) {
        self.willChangeValue(forKey: "titleAccessoryViewEnabled")
        self.didChangeValue(forKey: "titleAccessoryViewEnabled")
    }
    
    @IBAction func launchWindow(_ sender: AnyObject) {
        if let controller = instantiateWindowController() {
            if let window = controller.window {
                if unifiedTitleAndToolbarCheckbox.state == NSOnState {
                    window.styleMask.insert(NSUnifiedTitleAndToolbarWindowMask)
                } else {
                    window.styleMask.remove(NSUnifiedTitleAndToolbarWindowMask)
                }
                if fullContentViewCheckbox.state == NSOnState {
                    window.styleMask.insert(NSFullSizeContentViewWindowMask)
                } else {
                    window.styleMask.remove(NSFullSizeContentViewWindowMask)
                }
                if titleBarCheckBox.state == NSOnState {
                    window.styleMask.insert(NSTitledWindowMask)
                } else {
                    window.styleMask.remove(NSTitledWindowMask)
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

