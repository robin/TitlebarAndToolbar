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

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func showWindowWithTitle(controller:NSWindowController, title:String) {
        windowControllers.append(controller)
        controller.window?.title = title
        controller.showWindow(self)
    }

    func instantiateWindowController() -> NSWindowController? {
        if let storyboard = self.storyboard {
            return storyboard.instantiateControllerWithIdentifier("windowController") as? NSWindowController
        }
        return nil
    }

    @IBAction func titleAccessoryChecked(sender: AnyObject) {
        self.willChangeValueForKey("titleAccessoryViewEnabled")
        self.didChangeValueForKey("titleAccessoryViewEnabled")
    }
    
    @IBAction func launchWindow(sender: AnyObject) {
        if let controller = instantiateWindowController() {
            if let window = controller.window {
                if unifiedTitleAndToolbarCheckbox.state == NSOnState {
                    window.styleMask |= NSUnifiedTitleAndToolbarWindowMask
                } else {
                    window.styleMask = window.styleMask & (~NSUnifiedTitleAndToolbarWindowMask)
                }
                if fullContentViewCheckbox.state == NSOnState {
                    window.styleMask |= NSFullSizeContentViewWindowMask
                } else {
                    window.styleMask = window.styleMask & (~NSFullSizeContentViewWindowMask)
                }
                if titleBarCheckBox.state == NSOnState {
                    window.styleMask |= NSTitledWindowMask
                } else {
                    window.styleMask = window.styleMask & (~NSTitledWindowMask)
                }
                window.toolbar?.visible = showToolbarCheckbox.state == NSOnState

                showWindowWithTitle(controller, title: "Window")

                if titleAccessoryViewEnabled {
                    if let titlebarController = self.storyboard?.instantiateControllerWithIdentifier("titlebarViewController") as? NSTitlebarAccessoryViewController {
                        switch self.titleAccessoryViewLayoutMatrix.selectedRow {
                        case 0:
                            titlebarController.layoutAttribute = .Bottom
                        case 1:
                            titlebarController.layoutAttribute = .Left
                        case 2:
                            titlebarController.layoutAttribute = .Right
                        default:
                            titlebarController.layoutAttribute = .Bottom
                        }
                        
                        // layoutAttribute has to be set before added to window
                        window.addTitlebarAccessoryViewController(titlebarController)
                    }
                }
                window.titleVisibility = titleVisibilityCheckbox.state == NSOffState ? .Hidden : .Visible
                window.titlebarAppearsTransparent = titleAppearsTransparentCheckbox.state == NSOnState
            }
        }
    }

}

