import UIKit

enum Tab {
    case home, grave
}

var userCosmetics = [
    userCosmetic(expirationDate: Date(timeIntervalSinceNow: 60*60*24*365), purchaseDate: Date(), title: "녹두", category: "세럼",  imageName: "serum", kind: 0),
    userCosmetic(expirationDate: Date(timeIntervalSinceNow: 60*60*24*365), purchaseDate: Date(), title: "안넝", category: "세럼",  imageName: "sunscreen", kind: 0),
    userCosmetic(expirationDate: Date(timeIntervalSinceNow: 60*60*24*365), purchaseDate: Date(), title: "우히히", category: "세럼",  imageName: "eye-liner", kind: 1),
    userCosmetic(expirationDate: Date(timeIntervalSinceNow: 60*60*24*365), purchaseDate: Date(), title: "녹두", category: "세럼",  imageName: "serum", kind: 1),
    userCosmetic(expirationDate: Date(timeIntervalSinceNow: 60*60*24*365), purchaseDate: Date(), title: "안넝", category: "세럼",  imageName: "sunscreen", kind: 2),
    userCosmetic(expirationDate: Date(timeIntervalSinceNow: 60*60*24*365), purchaseDate: Date(), title: "우히히", category: "세럼",  imageName: "eye-liner", kind: 1),
    userCosmetic(expirationDate: Date(timeIntervalSinceNow: -60*60*24*365), purchaseDate: Date(), title: "크림", category: "크림",  imageName: "lotion", kind: 2)
]

class MainViewController: UIViewController {
    var tab = Tab.home
    let cellHeight: CGFloat = 150
    var selectedButton: UIButton?
    var filterCategory: String = "전체"
    
    var topCategorys: [TopCategory] = [
        TopCategory(imageName: "AllMenu", title: "전체"),
        TopCategory(imageName: "snowflake", title: "냉동"),
        TopCategory(imageName: "fridge", title: "냉장"),
        TopCategory(imageName: "body", title: "실온")
    ]
    
    lazy var stackView: UIStackView = {
        let buttons = topCategorys.map { category -> UIButton in
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage(named: category.imageName)
            configuration.title = category.title
            configuration.imagePadding = 8
            configuration.imagePlacement = .leading
            configuration.baseForegroundColor = .label
            
            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.backgroundColor = .white
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            
            return button
        }

        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let doubleTitleView = DoubleTitleView()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: cellHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.name)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
        if let firstButton = stackView.arrangedSubviews.first as? UIButton {
            filterButtonTapped(firstButton)
        }
    }
    
    private func getFilteredCosmetics() -> [userCosmetic] {
        let filteredCosmetics: [userCosmetic]
        
        switch filterCategory {
        case "전체":
            filteredCosmetics = userCosmetics
        case "냉동":
            filteredCosmetics = userCosmetics.filter { $0.kind == 0 }
        case "냉장":
            filteredCosmetics = userCosmetics.filter { $0.kind == 1 }
        case "실온":
            filteredCosmetics = userCosmetics.filter { $0.kind == 2 }
        default:
            filteredCosmetics = userCosmetics
        }
        
        switch tab {
        case .home:
            return filteredCosmetics.filter { $0.expirationDate >= Date() }
        case .grave:
            return filteredCosmetics.filter { $0.expirationDate < Date() }
        }
    }
}

extension MainViewController {
    func setupNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        
        doubleTitleView.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        doubleTitleView.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: doubleTitleView.leftButton),
            UIBarButtonItem(customView: doubleTitleView.rightButton)
        ]
        
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
    }
    
    func setupCollectionView() {
        view.addSubview(stackView)
        view.addSubview(collectionView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getFilteredCosmetics().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.name, for: indexPath) as! CustomCollectionViewCell
        let cosmetics = getFilteredCosmetics()
        let cosmetic = cosmetics[indexPath.item]
        cell.configure(with: cosmetic, isHomeTab: (tab == .home))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension MainViewController {
    @objc func leftButtonTapped() {
        tab = .home
        
        collectionView.reloadData()
        
        doubleTitleView.leftButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        doubleTitleView.rightButton.titleLabel?.font = .systemFont(ofSize: 25)
        doubleTitleView.rightButton.setTitleColor(.gray, for: .normal)
        doubleTitleView.leftButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func rightButtonTapped() {
        tab = .grave
        
        collectionView.reloadData()
        
        doubleTitleView.leftButton.titleLabel?.font = .systemFont(ofSize: 25)
        doubleTitleView.rightButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        doubleTitleView.leftButton.setTitleColor(.gray, for: .normal)
        doubleTitleView.rightButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func plusButtonTapped() {
        let vc = NameModalViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.modalPresentationStyle = .automatic
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func filterButtonTapped(_ sender: UIButton) {
        selectedButton?.backgroundColor = .white
        sender.backgroundColor = .setorange
        selectedButton = sender
        
        guard let index = stackView.arrangedSubviews.firstIndex(of: sender) else {
            return
        }
        
        let topCategory = topCategorys[index]
        filterCategory = topCategory.title
        
        collectionView.reloadData()
    }

}
