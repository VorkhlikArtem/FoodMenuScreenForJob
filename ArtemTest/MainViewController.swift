//
//  ViewController.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import UIKit
import Combine

protocol MenuDisplayLogic: AnyObject {
    func displayData(viewModel: MainMenu.Model.ViewModel.ViewModelData)
}

class MainViewController: UIViewController, MenuDisplayLogic {
    
    var interactor: MenuBusinessLogic?
        
    var collectionView: UICollectionView!
    typealias DataSourceType = UICollectionViewDiffableDataSource<MainViewModel.Section, MainViewModel.Item>
    
    var dataSource: DataSourceType?
    var mainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        
        interactor?.makeRequest(request: .getCategories)
    }
    
    func displayData(viewModel: MainMenu.Model.ViewModel.ViewModelData) {
        switch viewModel {
      
        case .displayCategories(categoryViewModels: let categoryViewModels):
            mainViewModel.categories = categoryViewModels
            dataSource = createDataSource()
            collectionView.dataSource = dataSource
            reloadData()
        case .displayMeals(mealViewModel: let mealViewModel):
            mainViewModel.meals.append(mealViewModel)
            reloadData()
        }
    }
    

    // MARK: -  NavigationBar & CollectionView setups
    private func setupNavigationBar() {
        let locationButton: UIButton = {
            var config = UIButton.Configuration.plain()
            
            var container = AttributeContainer()
            container.font = .systemFont(ofSize: 17)
            container.foregroundColor = #colorLiteral(red: 0.1340610683, green: 0.1581320465, blue: 0.1931300461, alpha: 1)
            
            config.attributedTitle = AttributedString(mainViewModel.location, attributes: container)
            config.image = UIImage(named: "down")
            config.imagePadding = 10
            config.imagePlacement = .trailing
            return UIButton(configuration: config, primaryAction: nil)
        }()
        
        let left = UIBarButtonItem(customView: locationButton)
        navigationItem.leftBarButtonItem = left
        navigationController?.navigationBar.barTintColor = .background
        navigationController?.navigationBar.backgroundColor = .background
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .background
        view.addSubview(collectionView)
        
        collectionView.register(CategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeader.reuseId)
        collectionView.register(MealCell.self, forCellWithReuseIdentifier: MealCell.reuseId)
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.reuseId)
    }
    
    // MARK: - Reload Data
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<MainViewModel.Section, MainViewModel.Item>()
        snapShot.appendSections(MainViewModel.Section.allCases)
        
        let bannerItems = mainViewModel.bannerItems
        snapShot.appendItems(bannerItems, toSection: .bannersSection)
        
        let mealItems = mainViewModel.mealItems
        snapShot.appendItems(mealItems, toSection: .mealsSection)
        
        dataSource?.apply(snapShot, animatingDifferences: true)
    }

}

// MARK: - Create Data Source
extension MainViewController {
    func createDataSource()->DataSourceType{
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, item  in
            switch item {
            case .mealItem(mealViewModel: let meal) :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCell.reuseId, for: indexPath) as! MealCell
                cell.configure(with: meal)
                return cell
                
            case .bannerItem(imageString: let imageString):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseId, for: indexPath) as! BannerCell
                cell.configure(with: imageString)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryHeader.reuseId, for: indexPath) as? CategoryHeader else {return nil}
                    
                sectionHeader.setup(with: self.mainViewModel.categories)
                    
                sectionHeader.buttonPublisher.sink { [weak self] index in
                        print(index)
                    guard let category = self?.mainViewModel.categories[index].category else {return}
                        self?.mainViewModel.meals.removeAll()
                        self?.interactor?.makeRequest(request: .getMeals(fromCategory: category))
                }.store(in: &sectionHeader.cancellables)
                    
                return sectionHeader
            default: return nil
            }
        }
        return dataSource
    }
}

// MARK: - Create Compositional Layout
extension MainViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {  sectionIndex, layoutEnvironment in
            
            switch self.dataSource?.snapshot().sectionIdentifiers[sectionIndex] {
            case .mealsSection :
                return self.createMealSectionLayout()
            case .bannersSection:
                return self.createBannerSectionLayout()
            default:
                return self.createBannerSectionLayout()
            }
        }
        return layout
    }
    
    private func createMealSectionLayout()-> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200) )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200) )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 24, trailing: 0)
       
        let sectionHeader = createSectionHeaderLayout()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createBannerSectionLayout()-> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(3/4), heightDimension: .fractionalWidth(1/3) )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 24, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 14
        section.orthogonalScrollingBehavior = .continuous
       
        return section
    }
    
    private func createSectionHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        return sectionHeader
    }
}
