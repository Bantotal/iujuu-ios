//
//  HomeRegaloTransitionController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 10/13/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class HomeRegaloTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    var selectedCell: RegaloCell!
    var initialFrame: CGRect!
    private var buttonFrame: CGRect!

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) is HomeViewController {
            animatePushTransition(context: transitionContext)
        } else {
            animatePopTransition(context: transitionContext)
        }
    }

    func animatePushTransition(context transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? HomeViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? RegaloDetailViewController else {
                return
        }
        let containerView = transitionContext.containerView

        // frames for animation
        initialFrame = fromVC.view.convert(selectedCell.motivoImageView.frame, from: selectedCell) // selectedCell.motivoImageView.frame
        let initialLabel = fromVC.view.convert(selectedCell.dateLabelBackground.frame, from: selectedCell)
        initialFrame.origin.x += 10
        let finalImageFrame = CGRect(x: 0, y: fromVC.navigationBarHeight(), width: UIScreen.main.bounds.width, height: 150)

        // snapshot cell image view
        let imageSnapshot = snapshotImageView(from: selectedCell.motivoImageView)
        selectedCell.motivoImageView.isHidden = true

        // adding subviews and setting up presented view
        containerView.addSubview(toVC.view)
        containerView.addSubview(imageSnapshot)
        toVC.view.frame = fromVC.view.frame
        toVC.view.alpha = 0
        imageSnapshot.frame = initialFrame

        // hide views we are moving
        let headerView = ((toVC.tableView?.tableHeaderView as? RegaloDetailHeader))!
        headerView.motivoImageView.isHidden = true

        // if necessary configure label
        var labelSnapshot: UIView?
        var shouldShowLabel = false
        if !selectedCell.dateLabelBackground.isHidden {
            shouldShowLabel = true
            labelSnapshot = createLabelView(frame: selectedCell.dateLabelBackground.frame, text: selectedCell.dateLabel.text)
            selectedCell.dateLabelBackground.isHidden = true
            containerView.addSubview(labelSnapshot!)
            labelSnapshot?.frame = initialLabel
            headerView.dateLabelBackground.isHidden = true
        }

        // move button
        var finalButtonFrame = toVC.tableView!.convert(toVC.participarButton!.frame, from: toVC.tableView?.tableFooterView)
        let defaultButthonHeight: CGFloat = 60
        finalButtonFrame.size.height = defaultButthonHeight
        finalButtonFrame.size.width = 0.75 * UIScreen.main.bounds.width
        finalButtonFrame.origin.x = (UIScreen.main.bounds.width - finalButtonFrame.size.width) / 2
        finalButtonFrame.origin.y += toVC.navigationBarHeight() + (toVC.participarFooterHeight - defaultButthonHeight) / 2
        let button = fromVC.createColectaButton
        buttonFrame = fromVC.createColectaButton.frame

        let duration = transitionDuration(using: transitionContext)

        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModePaced,
            animations: {
                // main animation: button and imageView of cell
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                    imageSnapshot.frame = finalImageFrame
                    labelSnapshot?.frame.origin.x -= 5
                    labelSnapshot?.frame.origin.y = finalImageFrame.origin.y + 10
                    button?.frame = finalButtonFrame
                    button?.layer.cornerRadius = 12
                })

                // first hide old view
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2, animations: {
                    fromVC.view.alpha = 0
                })

                // then show new view
                UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {
                    toVC.view.alpha = 1
                })
            },
            completion: { _ in
                headerView.motivoImageView.isHidden = false
                if shouldShowLabel {
                    headerView.dateLabelBackground.isHidden = false
                }
                imageSnapshot.removeFromSuperview()
                labelSnapshot?.removeFromSuperview()

                // Finish animation
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    func animatePopTransition(context transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? RegaloDetailViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? HomeViewController else {
                return
        }
        let containerView = transitionContext.containerView
        let headerView = ((fromVC.tableView?.tableHeaderView as? RegaloDetailHeader))!

        // snapshot and hide old image view
        let imageSnapshot = snapshotImageView(from: headerView.motivoImageView)
        headerView.motivoImageView.isHidden = true

        // adding subviews and setting up presented view
        toVC.view.frame = fromVC.view.frame
        containerView.addSubview(toVC.view)

        // add and set up snapshots
        containerView.addSubview(imageSnapshot)
        imageSnapshot.frame.origin = CGPoint(x: 0, y: -fromVC.tableView!.contentOffset.y)

        // if necessary configure label
        var labelSnapshot: UIView?
        var shouldShowLabel = false
        if !headerView.dateLabelBackground.isHidden {
            shouldShowLabel = true
            labelSnapshot = createLabelView(frame: headerView.dateLabelBackground.frame, text: headerView.dateLabel.text)
            headerView.dateLabelBackground.isHidden = true
            containerView.addSubview(labelSnapshot!)
            labelSnapshot?.frame.origin = CGPoint(x: 0, y: 10 - fromVC.tableView!.contentOffset.y)
        }

        // move the button to initial position if scrolled
        toVC.createColectaButton.frame.origin.y -= fromVC.tableView!.contentOffset.y + fromVC.navigationBarHeight()

        let duration = transitionDuration(using: transitionContext)

        UIView.animateKeyframes(
                withDuration: duration,
                delay: 0,
                options: .calculationModePaced,
                animations: {
                    // main animation: button and imageView of cell
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: { [weak self] in
                        guard let me = self else { return }
                        imageSnapshot.frame = me.initialFrame
                        labelSnapshot?.frame.origin.x += 5
                        labelSnapshot?.frame.origin.y = me.initialFrame.origin.y + 10
                        toVC.createColectaButton.frame = me.buttonFrame
                        toVC.createColectaButton.layer.cornerRadius = 0
                        })

                    // first hide old view
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2, animations: {
                        fromVC.view.alpha = 0
                    })

                    // then show new view
                    UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {
                        toVC.view.alpha = 1
                        })
                },
                completion: { [weak self] _ in
                    // remove and redo everything
                    self?.selectedCell.motivoImageView.isHidden = false
                    if shouldShowLabel {
                        self?.selectedCell.dateLabelBackground.isHidden = false
                    }
                    imageSnapshot.removeFromSuperview()
                    labelSnapshot?.removeFromSuperview()
                    toVC.createColectaButton.isHidden = false

                    // Finish animation
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
    }

    //MARK: Helpers

    func snapshotImage(from view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func snapshotImageView(from view: UIView, in rect: CGRect? = nil) -> UIImageView {
        let image = snapshotImage(from: view)
        return UIImageView(image: rect != nil ? image?.crop(rect!) : image)
    }

    func createLabelView(frame: CGRect, text: String?) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let label = UILabel()
        label.text = text
        label.textColor = .ijWhiteColor()
        label.font = .bold(size: 14)
        label.textAlignment = .center
        view.addSubview(label)
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        label.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
