//
//  ProductsListViewModel.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import Foundation

protocol ProductsListViewModelDelegate: AnyObject {
    func showError(error: Error)
    func productsFetched()
    func productsAmountChanged()
}

class ProductsListViewModel {

    weak var delegate: ProductsListViewModelDelegate?
    
    var products: [ProductModel]?
    var totalPrice: Double? {
        products?.reduce(0) { $0 + $1.price * Double(($1.selectedAmount ?? 0))}
    }
    
    func viewDidLoad() {
        fetchProducts()
    }
    
    private func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] response in
            switch response {
            case .success(let products):
                self?.products = products
                self?.delegate?.productsFetched()
            case .failure(let error):
                //TODO: handle Error - DONE!
                self?.delegate?.showError(error: error)
                break
            }
        }
    }
    
    func addProduct(at index: Int) {
        if var product = products?[index] {
            //TODO: handle if products are out of stock - DONE!
            product.selectedAmount = (product.selectedAmount ?? 0) + 1
            if product.stock < product.selectedAmount! {
                print("Product is out of stock.")
            } else {
                products?[index] = product
                delegate?.productsAmountChanged()
            }
        }
    }
    
    func removeProduct(at index: Int) {
        if var product = products?[index] {
            //TODO: handle if selected quantity of product is already 0 - DONE!
            if (product.selectedAmount ?? 0) > 0 {
                product.selectedAmount = (products?[index].selectedAmount ?? 0) - 1
                products?[index] = product
                delegate?.productsAmountChanged()
            }
        }
    }
}
