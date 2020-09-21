import UIKit

final class HomeHeroCollCell: UICollectionViewCell {
    @IBOutlet weak var _videoThumbnail: UIImageView!
    @IBOutlet weak var _posterButton: UIButton!
    @IBOutlet weak var _watchlistButton: UIButton!
    @IBOutlet weak var _playButton: UIButton!
    @IBOutlet weak var _info: UITextView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _videoThumbnail.image = nil
        _posterButton.setBackgroundImage(nil, for: .normal)
        _playButton.setBackgroundImage(nil, for: .normal)
        _watchlistButton.setBackgroundImage(nil, for: .normal)
    }
    
    var onTapPlay: () -> Void = { }
    @IBAction func _doBtnPlay() {
        onTapPlay()
    }
    var onTapWatchlist: () -> Void = { }
    @IBAction func _doBtnWatchlist() {
        onTapWatchlist()
    }
    var onTapPoster: () -> Void = { }
    @IBAction func _doBtnPoster() {
        onTapPoster()
    }
    
}
