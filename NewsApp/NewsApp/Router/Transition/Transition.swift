//
//  Transition.swift
//  NewsApp
//
//  Created by Atakan Atalar on 21.11.2024.
//

import UIKit

protocol Transition: AnyObject {
    var viewController: UIViewController? { get set }
    
    func open(_ viewController: UIViewController)
    func close(_ viewController: UIViewController)
}
