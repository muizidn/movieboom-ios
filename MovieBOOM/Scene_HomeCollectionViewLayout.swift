import UIKit

final class HomeCollectionViewLayout: UICollectionViewFlowLayout {
    private var contentSize: CGSize = .zero
    
    override func prepare() {
        contentSize = CGSize(width: 100, height: 100)
    }
    
    override var collectionViewContentSize: CGSize { contentSize }
}
