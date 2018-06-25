//
//  ViewController.swift
//  InfiniteScrollExample
//
//  Created by Gabriele Trabucco on 23/06/2018.
//  Copyright © 2018 Gabriele Trabucco. All rights reserved.
//

import UIKit
import InfiniteScroll

class InfiniteCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let infiniteBehaviour = InfiniteScrollBahaviour(source: [1,2,3,4,5,6,7,8,9,10])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        infiniteBehaviour.scrollView = collectionView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infiniteBehaviour.didLayoutSubview()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infiniteBehaviour.infinite
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = infiniteBehaviour.object(at: indexPath)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DefaultCell
        cell.label.text = item.map { "\($0)" } ?? "No Item"
        return cell
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        infiniteBehaviour.didEndDragging(willDecelerate: decelerate)
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        infiniteBehaviour.didEndDecelerating()
    }

}

class DefaultCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
}


class InfiniteTableViewController: UITableViewController {

    let infiniteBehaviour = InfiniteScrollBahaviour(source: [1,2,3,4,5,6,7,8,9,10])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        infiniteBehaviour.scrollView = tableView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infiniteBehaviour.didLayoutSubview()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infiniteBehaviour.infinite
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = infiniteBehaviour.object(at: indexPath)

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = item.map { "\($0)" } ?? "No Item"
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }

    // WARNING: Do not use per row eastimation. It will increase the load time significantly!"
    // Eastimation is set to a default tableView height during the scroView prepare()
    // Uncomment the code below if you want to see the time difference with your 👁👁
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.bounds.height
//    }

    // Automatically Support Paging using didEnd Delegate messages
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        infiniteBehaviour.didEndDragging(willDecelerate: decelerate)
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        infiniteBehaviour.didEndDecelerating()
    }

}
