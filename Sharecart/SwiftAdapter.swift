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
    @objc public func displayTopToast(title: String, desc: String) {
        
        var attributes = EKAttributes.topToast
        
        attributes.entryBackground = .color(color: EKColor.standardBackground)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .light
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
}
