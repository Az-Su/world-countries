//
//  JumpAvoidingFlowLayout.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 13.05.2023.
//

import UIKit

final class JumpAvoidingFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }

        let targetX: CGFloat = {
            let totalWidth = collectionViewContentSize.width + collectionView.contentInset.left + collectionView.contentInset.right

            
            if totalWidth > collectionView.bounds.size.width {
                return proposedContentOffset.x
            }

            return 0
        }()

        let targetY: CGFloat = {
            let totalHeight = collectionViewContentSize.height + collectionView.contentInset.top + collectionView.contentInset.bottom

            if totalHeight > collectionView.bounds.size.height {
                return proposedContentOffset.y
            }
            
            return 0
        }()

        return CGPoint(x: targetX, y: targetY)
    }
}
