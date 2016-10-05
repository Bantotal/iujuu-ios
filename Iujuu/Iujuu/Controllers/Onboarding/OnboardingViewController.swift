//
//  OnboardingViewController.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import FXPageControl
import DynamicColor
import RxSwift
import XLSwiftKit
import RealmSwift

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: FXPageControl!
    @IBOutlet weak var skipButton: UIButton!

    let disposeBag = DisposeBag()
    var page = Variable<Int>(0)

    override var prefersStatusBarHidden: Bool {
        return true
    }

    let model = [
        (text: UserMessages.Onboarding.texts[0], image: R.image.splashLogo(), backgroundImage: R.image.backgroundMultiColor()),
        (text: UserMessages.Onboarding.texts[1], image: R.image.onboardingImage1(), backgroundImage: nil),
        (text: UserMessages.Onboarding.texts[2], image: R.image.onboardingImage2(), backgroundImage: nil),
        (text: UserMessages.Onboarding.texts[3], image: R.image.onboardingImage3(), backgroundImage: nil)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ijBackgroundOrangeColor()
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(R.nib.onboardingCell)
        skipButton.setStyle(.borderless(titleColor: .white))
        skipButton.addTarget(self, action: #selector(OnboardingViewController.finishOnboardingAction), for: .touchUpInside)
        skipButton.titleLabel?.font = .light(size: 18)
        setupPageControl()
        setupObservables()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = collectionView.bounds.size
        layout?.minimumInteritemSpacing = 0
        layout?.minimumLineSpacing = 0
    }

    private func setupPageControl() {
        pageControl.backgroundColor = .clear
        pageControl.dotColor = UIColor.white.withAlphaComponent(0.4)
        pageControl.dotSize = 14
        pageControl.dotSpacing = 12
        pageControl.numberOfPages = model.count
        pageControl.selectedDotSize = 14
        pageControl.selectedDotColor = .white
    }

    private func setupObservables() {
        let _ = page.asObservable().bindNext {
            self.pageControl.currentPage = min($0, self.model.count - 2)
        }.addDisposableTo(disposeBag)

        let _ = page.asObservable().bindNext { page in
            UIView.animate(withDuration: 0.2) {
                self.pageControl.alpha = page == self.model.count - 1 ? 0 : 1
            }
        }.addDisposableTo(disposeBag)
    }

    func finishOnboardingAction() {
        performSegue(withIdentifier: R.segue.onboardingViewController.finishOnboarding, sender: nil)
    }

}

extension OnboardingViewController: UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        page.value = Int(collectionView.contentOffset.x / collectionView.bounds.width)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == model.count - 1 {
            UIView.animate(withDuration: 0.2) {
                self.pageControl.alpha = 0
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.visibleCells.forEach {
            let width = self.view.convert($0.frame, from: self.collectionView).intersection(collectionView.frame).width
            $0.alpha = width / collectionView.bounds.width
        }
    }

}

extension OnboardingViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.onboardingCell.identifier, for: indexPath) as? OnboardingCell) ?? OnboardingCell()
        cell.label.text = model[indexPath.row].text
        cell.imageView?.image = model[indexPath.row].image
        cell.backgroundImageView?.image = model[indexPath.row].backgroundImage
        cell.doneButton.isHidden = indexPath.row != model.count - 1
        cell.doneButton.addTarget(self, action: #selector(OnboardingViewController.finishOnboardingAction), for: .touchUpInside)
        let color = indexPath.row == 0 ? UIColor.black : UIColor.white
        cell.label.textColor = color
        return cell
    }

}
