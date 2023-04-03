//
//  ViewController.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    let fetcher = CombineNetworkManager()
    var cancellables = Set<AnyCancellable>()
    
    var collectionView: UICollectionView!
    typealias DataSourceType = UICollectionViewDiffableDataSource<MainViewModel.Section, MainViewModel.Item>
    
    var dataSource: DataSourceType?
    var model = MainModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        getData()
        
    }
    
    private func getData() {
        fetcher.getCategories().sink { [weak self] categories in
            print(categories)
            self?.model.categories = categories
            self?.dataSource = self?.createDataSource()
            self?.collectionView.dataSource = self?.dataSource
            
            self?.reloadData()
            
            if let first = categories.first?.strCategory {
                self?.getMeals(with: first)
            }
            
        }.store(in: &cancellables)
    }
    
    private func getMeals(with category: String) {
        fetcher.getMeals(category: category)
            .sink { [weak self] meals in
                guard let self = self else {return}
                meals.forEach { meal in
                    self.getDetails(with: meal.idMeal, meal: meal)
                }
        }.store(in: &cancellables)
    }
    
    private func getDetails(with id: String, meal: Meal) {
        fetcher.getDetails(id: id)
            .sink{ [weak self] ingredients in
                guard let details = ingredients.first else {return}
                let mealModel = MealViewModel(from: meal, and: details)
                
                self?.model.meals.append(mealModel)
                self?.reloadData()
               
                
            } .store(in: &self.cancellables)
    }
    
    // MARK: -  NavigationBar & CollectionView setups
    private func setupNavigationBar() {
        let locationButton: UIButton = {
            var config = UIButton.Configuration.plain()
            
            var container = AttributeContainer()
            container.font = .systemFont(ofSize: 17)
            container.foregroundColor = #colorLiteral(red: 0.1340610683, green: 0.1581320465, blue: 0.1931300461, alpha: 1)
            
            config.attributedTitle = AttributedString("Moscow", attributes: container)
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
        
        let bannerItems = model.banners.map{ MainViewModel.Item.bannerItem(imageString: $0) }
        snapShot.appendItems(bannerItems, toSection: .bannersSection)
        
        let mealItems = model.meals.map {MainViewModel.Item.mealItem(mealViewModel: $0) }
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
                    
                sectionHeader.setup(with: self.model.categories)
                    
                sectionHeader.buttonPublisher.sink { [weak self] index in
                        print(index)
                        guard let category = self?.model.categories[index].strCategory else {return}
                        self?.model.meals.removeAll()
                        self?.getMeals(with: category)
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
