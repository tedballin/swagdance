import UIKit
import AVKit
import WebKit
import FirebaseDatabase



class DanceVC: UIViewController
{
    
    var root:DatabaseReference!
    weak var progressTVC:ProgressTVC?
    
    //從第一頁取到網址
    var webLink:String!
    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        root = Database.database().reference()
        webView.load(URLRequest(url:URL(string: "https://www.youtube.com/watch?v=tWDQsRUrHQo&t=2s")!))
//        print("dance====>\(webLink)")
    }
    
  
//    @IBAction func showVedioBtn(_ sender: UIButton)
//    {
//        //從Bundle播影片
//
//        if let path = Bundle.main.path(forResource: "POPPING", ofType: "mp4")
//         {
//
//       let vedio = AVPlayer(url: URL(fileURLWithPath: path))
//
//        let vedioPlayer = AVPlayerViewController()
//            vedioPlayer.player = vedio
//            self.present(vedioPlayer, animated: true, completion: {
//                vedio.play()
//            })
//        }
//
//        let json:[String:String] = [
//            "dance" : "https://www.youtube.com/watch?v=FRcx319RSJU"
//
//        ]
//
//        let broadcast = root.child("vedio")
//               broadcast.setValue(json)
//
//    }
    
    
    
}

