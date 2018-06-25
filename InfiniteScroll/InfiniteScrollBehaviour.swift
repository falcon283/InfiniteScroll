//
//  InfiniteScrollBahaviour.swift
//  InfiniteScroll
//
//  Created by Gabriele Trabucco on 23/06/2018.
//  Copyright © 2018 Gabriele Trabucco. All rights reserved.
//

import Foundation

public class InfiniteScrollBahaviour<T> {

    /// The view used for the infinite scroll. Once setted the scroll is initially prepared.
    public weak var scrollView: InfiniteScrollableView? {
        didSet {
            scrollView?.prepare()
        }
    }

    /// The size used to fake the infinite scroll.
    // This value should be safe to not overflow view sizes calculation.
    private let infiniteSize: Int = 100//Int(Int32.max / 5000) // 858.993

    /// Value used to know if the centering is needed during `didLayoutSubview`
    private var didCenter = false

    /**
     The disaplayed source that repeats indefinitely.
     Once the source is updated the view is required to be reloaded.
     */
    public var source: [T] {
        didSet {
            if oldValue.count == 0 {
                didCenter = false
            }
            scrollView?.reloadData()
            didLayoutSubview()
        }
    }

    /**
     Default initializer. You can pass the source if you have it available fromt the beginning
     or use the setter to update it subsequently

     - parameter source: The displayed source in the infinite scroll.
     */
    public init(source: [T] = [], view: InfiniteScrollableView? = nil) {
        self.source = source
        self.scrollView = view
    }

    /**
     Call this method to retrieve the displayed item for the given indexPath.

     - parameter indexPath: The indexPath you need to retrieve the object.

     - returns: The item referring the input indexPath. Nil if the source is empty.
     */
    public func object(at indexPath: IndexPath) -> T? {
        guard source.count > 0 else { return nil }
        let reference = infiniteSize / 2
        let offset = indexPath.item - reference
        return source[offset.asCircularIndex]
    }

    /**
     This variable allows you to easily retrieve the number of items for your infite scroll implementation.
     Tipically you use it in your `collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)`
     implementation or similar.
     */
    public var infinite: Int {
        return source.count > 0 ? infiniteSize : 1
    }

    /**
     This function allows you to easily prepare your infinite scroll.
     You should call this method in your `viewDidLayoutSubview()` implementation or similar.
     */
    public func didLayoutSubview() {
        guard let infiniteScroll = scrollView else { return }

        infiniteScroll.prepare()
        if !didCenter {
            didCenter = true
            infiniteScroll.moveToCenter()
        }
    }

    /**
     This function allows you to easily implement the paging of your infite scroll.
     If you want to support paging automatically you must call
     `didEndDragging(decelerate: Bool)` and `didEndDecelerating()` as appropiate.
     For example if you are using a UIScrollView you will need to call this method in your
     `scrollViewDidEndDragging(scrollView: UIScrollView, decelerate: Bool)` implementation
     */
    public func didEndDragging(willDecelerate decelerate: Bool) {
        guard decelerate == false else { return }

        scrollView?.moveToCenterClosestItem(animated: true)
    }

    /**
     This function allows you to easily implement the paging of your infite scroll.
     If you want to support paging automatically you must call
     `didEndDragging(decelerate: Bool)` and `didEndDecelerating()` as appropiate.
     For example if you are using a UIScrollView you will need to call this method in your
     `scrollViewDidEndDecelerating(scrollView: UIScrollView)` implementation
     */
    public func didEndDecelerating() {
        scrollView?.moveToCenterClosestItem(animated: true)
    }

}

/**
 Support struct to allow Array Subscripting using an index that avoid outOfBound
 exception looping the index withing the array.
 */
public struct CircularIndex {

    /// The associated index
    public let index: Int

    /// Designated initializer
    public init(_ index: Int) {
        self.index = index
    }
}

public extension Array {

    /// This subscript allows you to avoid out of bound retrieval looping the array.
    public subscript(circularIndex: CircularIndex) -> Element? {
        guard count > 0 else { return nil }

        let index = circularIndex.index
        var idx = index - (index / count) * count
        idx += idx >= 0 ? 0 : count
        return self[idx]
    }
}

public extension Int {

    /// Circular Index retrieval
    public var asCircularIndex: CircularIndex {
        return CircularIndex(self)
    }
}
