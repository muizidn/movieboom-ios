import UIKit
import SwiftyJSON
import Nuke
import Kingfisher
import BonMot

protocol HomeHeroCollCellDelegate: class {
    func didTapPlay(id: Int)
    func didTapWatchlist(id: Int)
    func didTapPoster(id: Int)
}

final class HomeHeroCell: UICollectionViewCell {
    @IBOutlet weak var _collectionView: UICollectionView!
    
    weak var delegate: HomeHeroCollCellDelegate?
    
    var dataSource: [JSON] = [] {
        didSet {
            _collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _collectionView.dataSource = self
    }
}

extension HomeHeroCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: R.reuseIdentifier.hero3,
            for: indexPath
            )!
        
        let cfg = TMDBConfiguration.shared.getConfig()

        cell._videoThumbnail.kf.setImage(
            with: URL(string: "\(cfg.images.secureBaseURL)w300\(data["backdrop_path"].stringValue)")
        )
        
        URL(string: "\(cfg.images.secureBaseURL)w92\(data["poster_path"].stringValue)")
            .do({
                KF_loadImageToButtonBackground(
                    with: $0,
                    into: cell._posterButton
                )
            })

        cell._info.attributedText = """
            <title>\(data["original_title"].stringValue)</title>
            <subtitle>\(data["overview"].stringValue)</subtitle>
            """
            .styled(with: .xmlRules([
                .style("title", StringStyle(
                    .font(UIFont.systemFont(ofSize: 14, weight: .regular))
                )),
                .style("subtitle", StringStyle(
                    .font(UIFont.systemFont(ofSize: 14, weight: .light))
                ))
            ]))
        
        cell.onTapPoster = { [unowned self] in
            self.delegate?.didTapPoster(id: data["id"].intValue)
        }
        
        cell.onTapPlay = { [unowned self] in
            self.delegate?.didTapPlay(id: data["id"].intValue)
        }
        
        cell.onTapWatchlist = { [unowned self] in
            self.delegate?.didTapWatchlist(id: data["id"].intValue)
        }
        
        return cell
    }
}
