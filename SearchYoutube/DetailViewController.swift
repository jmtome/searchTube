//
//  DetailViewController.swift
//  MyTubePlay
//
//  Created by Juan Manuel Tome on 22/07/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    let stackView: UIStackView! = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let titleLabel: UILabel! = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Title Label"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    let dateLabel: UILabel! = {
        let dateLabel = UILabel(frame: .zero)
        dateLabel.text = "Date Label"
        dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return dateLabel
    }()
    let webView: WKWebView! = {
        let webView = WKWebView(frame: .zero)
        webView.layer.cornerRadius = 20
        webView.clipsToBounds = true 
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.widthAnchor.constraint(equalTo: webView.heightAnchor, multiplier: 1280/720).isActive = true
        
        return webView
    }()
    
    let textView: UITextView! = {
        let textView = UITextView(frame: .zero)
        //if there is more than enough space we would want the textview to take the majority of it, therefore we set the vertical content hugging priority of the textview to be lower than the rest, to 247 (default is 250)
        textView.setContentHuggingPriority(textView.contentHuggingPriority(for: .vertical) - 3, for: .vertical)
        
        //in the case there is too little space, what would get compressed first?
        //probably the textview aswell, so therefore we set the textview compression resistance to be the lowest of all, 3 points below the default of 750, this is 747
        textView.setContentCompressionResistancePriority(textView.contentCompressionResistancePriority(for: .vertical) - 3, for: .vertical)
        //so this is gonna get squished first if there is not enough space
        
        textView.text = "ipsum lorem bla bla bla"
        return textView
    }()
    
    var video: Video?
    
    override func viewWillAppear(_ animated: Bool) {
        //happens after viewdidload
        
        //clear the fields
        titleLabel.text = ""
        dateLabel.text = ""
        textView.text = ""
        
        //check if there is a video
        guard let video = video else { return }
        
        //create embed url
        let embedUrlString = Constants.YT_EMBED_URL + video.videoID
        //load it into the webview
        let url = URL(string: embedUrlString)!
        let request = URLRequest(url: url)
        webView.load(request)
        //set the title
        titleLabel.text = video.title
        
        //set the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: video.published)
        //set the description
        textView.text = video.description
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 50).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(webView)
        stackView.addArrangedSubview(textView)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//code to add a placeholder that will hide when some text appears on the textview
/*
 class NotesViewController : UIViewController, UITextViewDelegate {

     @IBOutlet var textView : UITextView!
     var placeholderLabel : UILabel!

     override func viewDidLoad() {
         super.viewDidLoad()

         textView.delegate = self
         placeholderLabel = UILabel()
         placeholderLabel.text = "Enter some text..."
         placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
         placeholderLabel.sizeToFit()
         textView.addSubview(placeholderLabel)
         placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
         placeholderLabel.textColor = UIColor.lightGray
         placeholderLabel.isHidden = !textView.text.isEmpty
     }

     func textViewDidChange(_ textView: UITextView) {
         placeholderLabel.isHidden = !textView.text.isEmpty
     }
 }
 */
