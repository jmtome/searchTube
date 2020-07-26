//
//  VideoTableViewCell.swift
//  MyTubePlay
//
//  Created by Juan Manuel Tome on 21/07/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let thumbnailImageView: UIImageView = {
        let thumbnailImageView = UIImageView(frame: .zero)
//        let thumbnailImageView = UIImageView(image: UIImage(systemName: "star"))
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.autoresizesSubviews = true
        thumbnailImageView.layer.cornerRadius = 20

//        thumbnailImageView.clearsContextBeforeDrawing = true
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 1280/720).isActive = true
        print("imageView \(thumbnailImageView.contentHuggingPriority(for: .vertical))")
        thumbnailImageView.backgroundColor = .red
        
        thumbnailImageView.setContentCompressionResistancePriority(thumbnailImageView.contentCompressionResistancePriority(for: .vertical) - 1, for: .vertical)
        thumbnailImageView.setContentCompressionResistancePriority(thumbnailImageView.contentCompressionResistancePriority(for: .horizontal) + 1, for: .horizontal)
        print("vertical compression resistance \(thumbnailImageView.contentCompressionResistancePriority(for: .vertical))")
        print("horizontal compression resistance \(thumbnailImageView.contentCompressionResistancePriority(for: .horizontal))")
        //Content compression resistance priority
        //Sets the priority with which a view resists being made smaller than its intrinsic size. Setting a higher value means that we don’t want the view to shrink smaller than the intrinsic content size.
        //If there is not enough space, the thumbnail of the video should get truncated, so here we change the compression resistance priority

        return thumbnailImageView
    }()
    let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "label 1"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(titleLabel.contentHuggingPriority(for: .vertical) - 1, for: .vertical)
        titleLabel.setContentHuggingPriority(titleLabel.contentHuggingPriority(for: .horizontal) + 1, for: .horizontal)
        //Sets the priority with which a view resists being made larger than its intrinsic size. Setting a larger value to this priority indicates that we don’t want the view to grow larger than its content.
        // We are lowering title label content hugging priority so that  If there is extra space, give it to the title label
        print(titleLabel.contentHuggingPriority(for: .vertical))
        print(titleLabel.contentHuggingPriority(for: .horizontal))
        return titleLabel
    }()
    let dateLabel: UILabel = {
        let dateLabel = UILabel(frame: .zero)
        dateLabel.text = "label 2"
        print(dateLabel.contentHuggingPriority(for: .vertical))
        return dateLabel
    }()
    
    var video: Video?
    //https://youtu.be/g46in8JKfw0?t=1197
    //thumbnail finished
    
    func setCell(_ vid: Video) {

        //i dont like how chris did this, i think the approach is wrong because by doing:
        self.video = vid
        print(vid)
        //given that vid: Video is not an optional type, if we dont call it with a proper Video parameter its gonna complain, therefore, if we call it properly, self.video could never be still nil after the previous assignment, therefore the following statement doesnt make any sense, because it will never be nil
        guard self.video != nil else { return }
        //the proper way to do this would be to do a guard let "variable" = self.video else { return } and then assign the stuff that was assigned using self.video!.title and self.video!.published, using the "variable" name, which will either exist or have exited, nonetheless, unless the parameter vid: Video is optional, the first assignment would never fail...
        
        
        //Set title and date label
        self.titleLabel.text = video!.title
        
        //we create a date formtter object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        //Go to NSDateFormatter.com to find formats
        self.dateLabel.text = dateFormatter.string(from: video!.published)
        
        // set the thumbnail
        //first we check if there is a thumbnail, if there isnt we return
        guard self.video!.thumbnail != "" else { return }
        //apparently according to chris, this thumbnail could not exist, and be and empty string...
        
        //check cache before downloading data
        if let cachedData = CacheManager.getVideoCache(self.video!.thumbnail) {
            // Set the thumbnailImageView
            self.thumbnailImageView.image = UIImage(data: cachedData)
            return
        }
        
        let url = URL(string: self.video!.thumbnail)!
        
        // Get the shared URL session object
        let session = URLSession.shared
        
        //Create a data task
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            //we check that data exists and that error doesnt
            guard let data = data, error == nil else { return }
            
            //Save data in the cache
            CacheManager.setVideoCache(url.absoluteString, data)
            
            //We need to check that the downloaded url matches the video thumbnail url that this cell is currently set to display
            // (what could happen is that, since the cells get reused by the tableview, so when we scroll out of view, this gets recycled and reused, so there is a scenario that may happen where the data for the image is being downloaded and the cell gets scrolled down out of view, it might have gone recycled for another video, and if that is the case, when the data returns, for the old video, you dont want to be setting that thumbnail for the old video it was displaying and want to set it to the new video, so when the data comes back, check that what you downloaded is actually for the video that you are currently trying to display for the cell.
            
            if url.absoluteString != self.video!.thumbnail {
                // video cell has been recycled for another video and no longer matches the thumbnail that was downloaded
                return
            }
            
            // Create the image object
            let image = UIImage(data: data)
            
            //Set the imageview
            // we want to do this in the main queue
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
        // resume data task
        dataTask.resume()
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
//    private func setupCell() {
//        self.contentView.addSubview(stackView)
//        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
//        stackView.addArrangedSubview(thumbnailImageView)
//        stackView.addArrangedSubview(titleLabel)
//        stackView.addArrangedSubview(dateLabel)
//        //imageView?.image = myImageView.image
//        //doing the above will add an image to the leading side of the cell,
//    }
    private func setupCell() {
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        stackView.addArrangedSubview(thumbnailImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        //imageView?.image = myImageView.image
        //doing the above will add an image to the leading side of the cell,
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
