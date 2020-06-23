//
//  ViewController.swift
//  Layout
//
//  Created by John Liedtke on 6/23/20.
//  Copyright © 2020 Walmart. All rights reserved.
//

import UIKit

/// Slightly modified version of the Appple Sample code.

class ConferenceNewsFeedViewController: UIViewController {

    enum Section {
        case main
    }

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ConferenceNewsController.NewsFeedItem>!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Conference News Feed"
        configureHierarchy()
        configureDataSource()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension ConferenceNewsFeedViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        collectionView.register(
            ConferenceNewsFeedCell.self,
            forCellWithReuseIdentifier: ConferenceNewsFeedCell.reuseIdentifier)
        collectionView.register(LineReusableView.self, forSupplementaryViewOfKind: "LineReusableView", withReuseIdentifier: LineReusableView.reuseIdentifier)

    }

    func configureDataSource() {
        let newsController = ConferenceNewsController()

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView,
            indexPath: IndexPath,
            newsItem: ConferenceNewsController.NewsFeedItem) -> UICollectionViewCell? in
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ConferenceNewsFeedCell.reuseIdentifier,
                for: indexPath) as? ConferenceNewsFeedCell {
                cell.titleLabel.text = newsItem.title
                cell.bodyLabel.text = newsItem.body

                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                cell.dateLabel.text = dateFormatter.string(from: newsItem.date)
                cell.showsSeparator = indexPath.item != newsController.items.count - 1
                return cell
            } else {
                fatalError("Cannot create new cell")
            }
        }

        dataSource.supplementaryViewProvider = {(
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            // Get a supplementary view of the desired kind.
            if let lineView = collectionView.dequeueReusableSupplementaryView(
                ofKind: "LineReusableView",
                withReuseIdentifier: LineReusableView.reuseIdentifier,
                for: indexPath) as? LineReusableView {

                // Return the view.
                return lineView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }


        // load our data
        let newsItems = newsController.items
        var snapshot = NSDiffableDataSourceSnapshot<Section, ConferenceNewsController.NewsFeedItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(newsItems)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func createLayout() -> UICollectionViewLayout {

        let estimatedHeight = CGFloat(10)

        let sup = NSCollectionLayoutSupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(2)),
            elementKind: "LineReusableView",
            containerAnchor: .init(edges: [.bottom])
        )

        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(estimatedHeight)),
            supplementaryItems: []
        )
        item.edgeSpacing = .init(leading: nil, top: nil, trailing: nil, bottom: .flexible(0))

        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize, subitems: [item])
        group.supplementaryItems = [sup]

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}


