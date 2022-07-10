//
//  ListViewController.swift
//  iChat_App
//
//  Created by Felix Titov on 7/10/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

struct MChat: Hashable {
    var userName: String
    var userImage: UIImage
    var lastMessage: String
    var id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        lhs.id == rhs.id
    }
}

class ListViewController: UIViewController {
    
    let activeChats: [MChat] = [
        MChat(userName: "Felix", userImage: UIImage(named: "human1")!, lastMessage: "Fuck you!"),
        MChat(userName: "Azamat", userImage: UIImage(named: "human2")!, lastMessage: "How are you?"),
        MChat(userName: "Emil", userImage: UIImage(named: "human3")!, lastMessage: "Ok")
    ]
    
    enum Section: Int, CaseIterable {
        case activeChats
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupCollectionView()
        setupDataSource()
        reloadData()
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { collectionView, indexPath, _ in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError()
            }
            
            switch section {
            case .activeChats:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
                cell.backgroundColor = .systemBlue
                return cell
            }
        })
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapshot.appendSections([.activeChats])
        snapshot.appendItems(activeChats, toSection: .activeChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(84))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
            
            return section
        })
        
        return layout
    }
}

//MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("hello theree!")
    }
}

//MARK: - SwiftUI
import SwiftUI

struct ListControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some MainTabBarController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
