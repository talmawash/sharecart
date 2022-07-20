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
    
    // Below code is adapted from SwiftEntryKit examples on github
    // https://github.com/huri000/SwiftEntryKit/tree/master/Example/SwiftEntryKit

    @objc public static func displayTopFloat(title: String, desc: String) {
        
        var attributes = EKAttributes.topFloat
        
        attributes.entryBackground = .color(color: EKColor.standardBackground)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .inferred
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)), height: .intrinsic)
        attributes.displayDuration = 1
        attributes.entryInteraction = .delayExit(by: 0.5)

        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont.systemFont(ofSize: 17), color: EKColor.standardContent))
        let description = EKProperty.LabelContent(text: desc, style: .init(font: UIFont.systemFont(ofSize: 15), color: EKColor.standardContent))
        let simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    // Below code is adapted from SwiftEntryKit examples on github
    // https://github.com/huri000/SwiftEntryKit/tree/master/Example/SwiftEntryKit

    @objc public static func displayInvitationCode(code: String) {
        var attributes = EKAttributes.centerFloat
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: EKColor(UIColor.systemBackground))
        attributes.screenBackground = .color(color: EKColor(UIColor(white: 50.0/255.0, alpha: 0.3)))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.roundCorners = .all(radius: 8)
        attributes.entranceAnimation = .init(
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
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.35)
            )
        )
        attributes.positionConstraints.size = .init(
            width: .offset(value: 20),
            height: .intrinsic
        )
        attributes.positionConstraints.maxSize = .init(width: .constant(value: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)),height: .intrinsic)
        attributes.statusBar = .inferred
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
        SwiftEntryKit.display(entry: view, using: attributes)
    }
}
