//
//  loginPageViewController.swift
//  YGGG
//
//  Created by uunwon on 6/18/24.
//

import UIKit

class loginPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pageControl: UIPageControl?
    
    lazy var pageViewControllers: [UIViewController] = {
        return [
            createPage(image: "onBoarding Image 1", text: "화장품 유통기한을 기록해요"),
            createPage(image: "onBoarding Image 2", text: "서로의 화장품 냉장고를 공유해요"),
            createPage(image: "onBoarding Image 3", text: "유통기한이 임박한 화장품을 알려줘요")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self

        if let firstViewController = pageViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    // MARK: - Methods
    func createPage(image: String, text: String) -> UIViewController {
        let viewController = UIViewController()
        
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.view.addSubview(imageView)
        viewController.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 50),
            imageView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor)
        ])
        
        return viewController
    }
    
    // MARK: - UIPageViewControllerDataSource Methods
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pageViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pageViewControllers.count else {
            return nil
        }
        
        return pageViewControllers[nextIndex]
    }
    
    // MARK: - 페이지 인디케이터 업데이터를 위한 UIPageViewControllerDelegate Method
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = pageViewControllers.firstIndex(of: viewController) else {
            return
        }
        pageControl?.currentPage = index
    }
}
