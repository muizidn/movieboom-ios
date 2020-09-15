import UIKit

final class HomeHeroCollCell: UICollectionViewCell {
    @IBOutlet weak var _videoThumbnail: UIImageView!
    @IBOutlet weak var _posterImageView: UIImageView!
    @IBOutlet weak var _watchlistButton: UIButton!
    @IBOutlet weak var _info: UITextView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _videoThumbnail.image = nil
        _posterImageView.image = nil
    }
}
