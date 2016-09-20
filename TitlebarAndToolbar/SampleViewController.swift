//
//  SampleViewController.swift
//  TitlebarAndToolbar
//
//  Created by Lu Yibin on 16/6/21.
//  Copyright © 2016年 Lu Yibin. All rights reserved.
//

import Cocoa

class SampleViewController: NSViewController {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var textField2: NSTextField!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var imageView: NSImageView!
    
    var topConstraint : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do view setup here.
        textField.stringValue = "aligned to window.topAnchor"

    }
    
    override func updateViewConstraints() {
        if topConstraint == nil {
            if let topAnchor = (self.view.window?.contentLayoutGuide as? NSLayoutGuide)?.topAnchor {
                topConstraint = self.textField.topAnchor.constraint(equalTo: topAnchor, constant: 0)
                topConstraint?.isActive = true
            }
        }
        super.updateViewConstraints()
    }
}
