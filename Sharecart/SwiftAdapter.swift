//
//  SwiftAdapter.swift
//  Sharecart
//
//  Created by Tariq Almawash on 7/19/22.
//

import Foundation
import SwiftEntryKit
import UIKit

public class SwiftAdapter : NSObject {
    
    static var topFloatAttributes = EKAttributes.topFloat
    static var centerFloatAttributes = EKAttributes.centerFloat
    
    @objc public static func setupAttributes() {
        
        topFloatAttributes.entryBackground = .color(color: EKColor.standardBackground)
        topFloatAttributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        topFloatAttributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        topFloatAttributes.statusBar = .inferred
        topFloatAttributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        topFloatAttributes.positionConstraints.maxSize = .init(width: .constant(value: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)), height: .intrinsic)
        topFloatAttributes.displayDuration = 1
        topFloatAttributes.entryInteraction = .delayExit(by: 0.5)
        
        centerFloatAttributes.hapticFeedbackType = .success
        centerFloatAttributes.displayDuration = .infinity
        centerFloatAttributes.entryBackground = .color(color: EKColor(UIColor.systemBackground))
        centerFloatAttributes.screenBackground = .color(color: EKColor(UIColor(white: 50.0/255.0, alpha: 0.3)))
        centerFloatAttributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        centerFloatAttributes.screenInteraction = .dismiss
        centerFloatAttributes.entryInteraction = .absorbTouches
        centerFloatAttributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        centerFloatAttributes.roundCorners = .all(radius: 8)
        centerFloatAttributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 0.7, initialVelocity: 0)
            ),
            scale: .init(
                from: 0.7,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        centerFloatAttributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        centerFloatAttributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.35)
            )
        )
        centerFloatAttributes.positionConstraints.size = .init(
            width: .offset(value: 20),
            height: .intrinsic
        )
        centerFloatAttributes.positionConstraints.maxSize = .init(width: .constant(value: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)),height: .intrinsic)
        centerFloatAttributes.statusBar = .inferred
        centerFloatAttributes.positionConstraints.keyboardRelation = .bind(
            offset: .init(
                bottom: 15,
                screenEdgeResistance: 0
            )
        )
    }
    
    // Below code is adapted from SwiftEntryKit examples on github
    // https://github.com/huri000/SwiftEntryKit/tree/master/Example/SwiftEntryKit

    @objc public static func displayTopFloat(title: String, desc: String) {
        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont.systemFont(ofSize: 17), color: EKColor.standardContent))
        let description = EKProperty.LabelContent(text: desc, style: .init(font: UIFont.systemFont(ofSize: 15), color: EKColor.standardContent))
        let simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: topFloatAttributes)
    }
    
    // Below code is adapted from SwiftEntryKit examples on github
    // https://github.com/huri000/SwiftEntryKit/tree/master/Example/SwiftEntryKit

    @objc public static func displayInvitationCode(code: String) {
        let title = EKProperty.LabelContent(
            text: "Code has been generated",
            style: .init(
                font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium),
                color: EKColor(UIColor.label),
                alignment: .center
            )
        )
        let description = EKProperty.LabelContent(
            text: "Your list invitation code has been created, it will expire in 24 hours if not used and can only be used once.\n\nCode: " + code,
            style: .init(
                font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light),
                color: EKColor(UIColor.secondaryLabel),
                alignment: .center
            )
        )
        let button = EKProperty.ButtonContent(
            label: .init(
                text: "Copy to clipboard",
                style: .init(
                    font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold),
                    color: EKColor.standardContent
                )
            ),
            backgroundColor: EKColor(.secondarySystemBackground),
            highlightedBackgroundColor: .white.with(alpha: 0.05),
            displayMode: .inferred
        )
        let message = EKPopUpMessage(
            title: title,
            description: description,
            button: button) {
                UIPasteboard.general.string = code
                SwiftEntryKit.dismiss()
        }
        let view = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: view, using: centerFloatAttributes)
    }
    @objc public static func displayAddList(delegate: AddListViewDelegate) {
        let view = Bundle.main.loadNibNamed("AddList", owner: NSObject())?.first as! AddList
        view.addListDelegate = delegate;
        SwiftEntryKit.display(entry: view, using: centerFloatAttributes, presentInsideKeyWindow: true)
    }
    
    @objc public static func dismissPopup() {
        SwiftEntryKit.dismiss();
    }
}
