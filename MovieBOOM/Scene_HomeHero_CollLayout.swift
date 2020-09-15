import UIKit

final class HomeHeroCollLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let coll = collectionView else { return }
        let count = coll.dataSource?
            .collectionView(
                coll, numberOfItemsInSection: 0) ?? 0
        itemSize = coll.frame.size
        _contentSize = CGSize(
            width: CGFloat(count) * itemSize.width,
            height: itemSize.height
        )
    }
    
    private var _contentSize = CGSize.zero
    
    override var collectionViewContentSize: CGSize { _contentSize }
}
