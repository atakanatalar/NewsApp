//
//  Animator.swift
//  NewsApp
//
//  Created by Atakan Atalar on 21.11.2024.
//

import UIKit

protocol Animator: UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool { get set }
}
