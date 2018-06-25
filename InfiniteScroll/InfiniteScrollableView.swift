//
//  InfiniteScrollableView.swift
//  InfiniteScroll
//
//  Created by Gabriele Trabucco on 23/06/2018.
//  Copyright © 2018 Gabriele Trabucco. All rights reserved.
//

import Foundation

/// Protocol to represent an Infinite Scrollable View.
public protocol InfiniteScrollableView: class {

    /// Prepare the view for the infinite scroll.
    func prepare()

    /// Move the view content to its central position.
    func moveToCenter()

    /**
     Move the view content to the item that is nearest to the center of the screen.

     - parameter animated: Use animation or not.
     */
    func moveToCenterClosestItem(animated: Bool)

    /// Reload the view.
    func reloadData()
}

private extension UIScrollView {

    func prepareForInfiniteScroll() {
        scrollsToTop = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        } else {
            contentInset = .zero
            scrollIndicatorInsets = .zero
        }
    }
}

extension UITableView: InfiniteScrollableView {

    public func prepare() {
        prepareForInfiniteScroll()
        estimatedRowHeight = frame.height
    }

    public func moveToCenter() {
        let count = numberOfRows(inSection: 0)
        let indexPath = IndexPath(row: count / 2, section: 0)
        scrollToRow(at: indexPath, at: .middle, animated: false)
    }

    public func moveToCenterClosestItem(animated: Bool) {
        guard let superview = superview else { return }
        let centralPoint = convert(center, from: superview)
        if let indexPath = indexPathForRow(at: centralPoint) {
            scrollToRow(at: indexPath, at: .middle, animated: true)
        } else {
            typealias Result = (distance: CGFloat, cell: UITableViewCell?)
            let visibleCell = visibleCells
                .reduce(Result(CGFloat.greatestFiniteMagnitude, nil)) {
                    let distance = $1.center.distance(from: centralPoint)
                    if distance < $0.distance {
                        return (distance, $1)
                    }
                    else {
                        return $0
                    }
                }.cell
            guard let cell = visibleCell, let indexPath = indexPath(for: cell) else { return }
            scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
}

extension UICollectionView: InfiniteScrollableView {

    public func prepare() {
        prepareForInfiniteScroll()
    }
    
    public func moveToCenter() {
        let count = numberOfItems(inSection: 0)
        let indexPath = IndexPath(item: count / 2, section: 0)
        centerOnItem(at: indexPath, animated: false)
    }

    public func moveToCenterClosestItem(animated: Bool) {
        guard let superview = superview else { return }
        let centralPoint = convert(center, from: superview)
        if let indexPath = indexPathForItem(at: centralPoint) {
            centerOnItem(at: indexPath, animated: true)
        } else {
            typealias Result = (distance: CGFloat, cell: UICollectionViewCell?)
            let visibleCell = visibleCells
                .reduce(Result(CGFloat.greatestFiniteMagnitude, nil)) {
                    let distance = $1.center.distance(from: centralPoint)
                    if distance < $0.distance {
                        return (distance, $1)
                    }
                    else {
                        return $0
                    }
                }.cell
            guard let cell = visibleCell, let indexPath = indexPath(for: cell) else { return }
            centerOnItem(at: indexPath, animated: true)
        }
    }

    private func centerOnItem(at indexPath: IndexPath, animated: Bool) {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let position: UICollectionViewScrollPosition = layout.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
            scrollToItem(at: indexPath, at: position, animated: animated)
        } else {
            scrollToItem(at: indexPath, at: .top, animated: animated)
        }
    }

}

fileprivate extension CGPoint {

    /**
     Calculate the distance between two points

     - parameter point: the to calculate the distance from.
     */
    func distance(from point: CGPoint) -> CGFloat {
        let p = point
        return sqrt((x - p.x) * (x - p.x) + (y - p.y) * (y - p.y))
    }
}
