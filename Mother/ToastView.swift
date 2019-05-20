//
//  ToastView.swift
//  Mother
//
//  Created by Apple on 20/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

open class ToastView {
    fileprivate let mMessage: String
    fileprivate static var BackgroundColor = UIColor(red: 0x66/255, green: 0x66/255, blue: 0x66/255, alpha: 1.0)
    fileprivate static var TextColor = UIColor(red: 0xfa/255, green: 0xfa/255, blue: 0xfa/255, alpha: 1.0)
    fileprivate static var ToastDuration: TimeInterval = 3
    
    fileprivate static let ANIMATION_DURATION = 0.4
    fileprivate static let PADDING: CGFloat = 15
    fileprivate static let TOP_PADDING: CGFloat = 10
    fileprivate static let CORNER_RADIUS : CGFloat = 10
    fileprivate static let FONT_SIZE : CGFloat = 15
    
    fileprivate var isShowing : Bool = false
    fileprivate var toastView: UIView? = nil
    
    static var instance : ToastView?
    
    fileprivate var keyboardHeight: CGFloat = 0
    
    public init(message: String, keyboardHeight: CGFloat = 0) {
        if let beforeToast = ToastView.instance, let toastView = beforeToast.toastView {
            beforeToast.removeToast(toastView, message: beforeToast.mMessage)
        }
        
        mMessage = message
        ToastView.instance = self
        self.keyboardHeight = keyboardHeight
    }
    
    open func setDuration(_ duration: TimeInterval) -> ToastView {
        ToastView.ToastDuration = duration
        return self
    }
    
    open func showLaterWindow(_ isDrawLastWindow:Bool) {
        if let toastView = toastView {
            if isShowing {
                removeToast(toastView, message : mMessage)
            }
        }
        
        isShowing = true
        self.toastView = makeToast()
        let curMessage = self.mMessage
        if let toastView = toastView, curMessage != "" {
            toastView.center = bottomPoint(toastView)
            toastView.alpha = 0
            
            if(isDrawLastWindow == true) {
                UIApplication.shared.windows.last?.addSubview(toastView)
            }
            else {
                UIApplication.shared.delegate?.window??.addSubview(toastView)
            }
            
            UIView.animate(withDuration: ToastView.ANIMATION_DURATION, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                    toastView.alpha = 0.9
            },completion: {
                (result) -> Void in
                if curMessage == self.mMessage {
                    self.removeToast(toastView, message : curMessage)
                }
            })
        }
    
    }
    
    open func show() {
        self.showLaterWindow(false)
    }
    
    fileprivate func removeToast(_ toastView: UIView, message: String) {
        if message == mMessage {
            UIView.animate(withDuration: ToastView.ANIMATION_DURATION, delay: ToastView.ToastDuration, options: .curveEaseIn, animations: {() -> Void in
                toastView.alpha = 0
            }, completion: {
                (result) -> Void in
                if self.mMessage == message {
                    toastView.removeFromSuperview()
                    self.isShowing = false
                }
            })
        }
    }
    
    fileprivate func bottomPoint(_ toastView:UIView) -> CGPoint {
        let posX = UIScreen.main.bounds.width/2
        let screenHeight = UIScreen.main.bounds.height - keyboardHeight
        
        var posY:CGFloat
        posY = screenHeight - 100 - (toastView.frame.size.height/2)
        
        return CGPoint(x:posX, y:posY)
    }
    
    fileprivate func makeToast() -> UIView {
        
        let windowWidth = UIScreen.main.bounds.width
        let windowHeight = UIScreen.main.bounds.height
        
        let viewBackground = UIView()
        viewBackground.isUserInteractionEnabled = false
        viewBackground.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        viewBackground.layer.cornerRadius = ToastView.CORNER_RADIUS
        viewBackground.backgroundColor = ToastView.BackgroundColor
        
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: ToastView.FONT_SIZE)
        label.textAlignment = .natural
        label.lineBreakMode = .byWordWrapping
        label.textColor = ToastView.TextColor
        label.backgroundColor = UIColor.clear
        label.text = mMessage
        label.alpha = 0.9
        
        let maxSizeMessage = CGSize(width: windowWidth - (ToastView.PADDING*4), height: windowHeight)
        let expectedSizeMessage = sizeForString(mMessage, font: label.font, constrainedToSize: maxSizeMessage, lineBreakMode: label.lineBreakMode)
        
        label.frame = CGRect(x: ToastView.PADDING, y: ToastView.TOP_PADDING, width: expectedSizeMessage.width, height: expectedSizeMessage.height)
        let backgroundWidth = label.bounds.width + (ToastView.PADDING*2)
        let backgroundHeight = label.bounds.height + (ToastView.PADDING*2)
        viewBackground.frame = CGRect(x:0, y:0 , width: backgroundWidth, height: backgroundHeight)
        
        viewBackground.addSubview(label)
        
        return viewBackground
        
    }
    
    fileprivate func sizeForString(_ msg: String, font:UIFont, constrainedToSize:CGSize, lineBreakMode:NSLineBreakMode) -> CGSize {
        
        let string = NSString(string: msg)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        
        let attributes = [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle]
        
        let boundingRect = string.boundingRect(with: constrainedToSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let widthFloat = ceilf(Float(boundingRect.size.width))
        let heightFloat = ceilf(Float(boundingRect.size.height))
        
        return CGSize(width: CGFloat(widthFloat), height: CGFloat(heightFloat))
    }
    
}
