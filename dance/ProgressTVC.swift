struct Record
{
    var name = ""
    var picture:Data?
    
}
import UIKit
import FSCalendar
import FirebaseStorage
import FirebaseDatabase
import AVFoundation



class ProgressTVC: UITableViewController,FSCalendarDelegate
{
//    private let imageView:UIImageView = {
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
//        imageView.image = UIImage(named: "2")
//        return imageView
//    }()
    var structRow = Record()
    var arrTable = [Record]()
    var currentRow = 0
    var root:DatabaseReference!
    let storage = Storage.storage()
    var vedioWeb:String!
    var player:AVAudioPlayer!
    var signal2 = true
    @IBOutlet weak var buzy: UIActivityIndicatorView!
    
    @IBOutlet var calendar:FSCalendar!
    //MARK: - Target Action
    //導覽列的編輯按鈕
    @objc func buttonEditAction()
    {
//        print("編輯按鈕被按下")
        if !self.tableView.isEditing        //如果表格不在編輯狀態
        {
            //讓表格進入編輯狀態
            self.tableView.isEditing = true
            //更換按鈕文字
            self.navigationItem.leftBarButtonItem?.title = "完成"
        }
        else
        {   //讓表格回復到非編輯狀態
            self.tableView.isEditing = false
            //更換按鈕文字
            self.navigationItem.leftBarButtonItem?.title = "編輯"
        }
    }
    
    @objc func buttonAddAction()
        {
            print("新增按鈕被按下")
            //從storyboard上以ID取得頁面的實體
            let LoveDanceTVC = self.storyboard!.instantiateViewController(identifier: "LoveDanceTVC") as! LoveDanceTVC
//            通知新增畫面目前表格控制器的實體
            LoveDanceTVC.ProgressTVC = self
            self.show(LoveDanceTVC, sender: nil)
        }
    
    @objc func handelRefresh()
     {
         //Step1.重新讀取實際的資料庫資料
         //Todo
         //Step2.重整表格（重新執行Table view data source代理事件）
         self.tableView.reloadData()
         //Step3.結束表格的下拉更新狀態
         self.tableView.refreshControl?.endRefreshing()
     }
    //MARK: - View Life Cycle
        override func viewDidLoad()
        {
        super.viewDidLoad()
        calendar.delegate = self
            self.buzy.isHidden = true
        arrTable = [
                Record(name: "Hip Hop", picture: UIImage(named: "1")!.jpegData(compressionQuality: 0.8)),
                Record(name: "Breaking", picture: UIImage(named: "1")!.jpegData(compressionQuality: 0.8))
            ]
        self.navigationItem.title = "練習記錄"
        //設定導覽列左側按鈕
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(buttonEditAction))
        //設定導覽列右側按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "最愛", style: .plain, target: self, action: #selector(buttonAddAction))
            root = Database.database().reference()
            print(NSHomeDirectory())

    }
   override func viewWillAppear(_ animated: Bool)
   {
       super.viewWillAppear(animated)
       //重整表格（重新執行Table view data source代理事件）
       self.tableView.reloadData()
   }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return arrTable.count //回傳已觀看的影片數量
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCell
        
        let structRow = arrTable[indexPath.row]
        cell.lblDanceName.text = structRow.name
        if let aPicture = structRow.picture
        {
            cell.imgDance.image = UIImage(data: aPicture)
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let string = formatter.string(from: date)
        print("\(string)")
    }
    
    //MARK: - Table view delegate
    //當特定儲存格被點選時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let danceRecord = indexPath.row
        print(danceRecord)
        if danceRecord == 0
        {
    
             let pathReference = storage.reference(withPath: "dance/vedio/POPPING.mp4") //從根目錄開始找到檔案位置
                    print("=======>\(pathReference)")
                    pathReference.getData(maxSize: 10240 * 10240) {
                                        (bytes, error)
                                        in
                                        if let err = error
                                        {
                                            print("下載出錯:\(err)")
                                        }
                                        else
                                        {
                                            let d = Date()
                                            let path = "\(NSHomeDirectory())/Documents/POPPING\(d).mp4"
                                            print("=====>1\(path)")
                                                guard !FileManager.default.fileExists(atPath: path) else
                                            {
                                                return
                                            }
                                            do
                                            {
                                                try bytes!.write(to: URL(fileURLWithPath: path))
                                                self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                                                self.player.play()
                                                self.player.isMeteringEnabled = true
                                                
                                            }
                                            catch
                                            {
                                                print("儲存失敗:\(error)")
                                            }
                                        }
                        }
            
//                var vedio :DatabaseReference
//                   vedio = root.child("vedio/dance")
//                   vedio.observe(DataEventType.value) {
//                       (ss)
//                       in
//                       print(ss.value!)
//                       DispatchQueue.main.async
//                       {
//                            self.vedioWeb = "\(ss.value!)"
//                       }
//                              }
        }
    }
    // 注意：實現儲存格的移動功能，必須實作以下兩個代理方法(同時進行)
           // <代理方法1>設定儲存格可以被移動
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
           // Return false if you do not want the item to be re-orderable.
           return true
    }
        
           // <代理方法2>實際移動儲存格
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath)
    {
        print("移動前:\(fromIndexPath),移動:\(to)")
        arrTable.insert(arrTable.remove(at: fromIndexPath.row), at: to.row)
        print("移動後的陣列\(arrTable)")
        }
        // 注意：實作表格的編輯事件之後，表格可以滑動"刪除"
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
        {
    //        if editingStyle == .delete
    //        {
                print("刪除前陣列：\(arrTable)")
                //Step1. 先刪除表格對應的該筆陣列資料
    //            list.remove(at: indexPath.row)
                arrTable.remove(at: indexPath.row)
                //Step2. 再刪除介面上的該筆儲存格
                tableView.deleteRows(at: [indexPath], with: .fade)
                print("刪除後陣列：\(arrTable)")
    //        }
        }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        //準備"更多"按鈕
        /*let actionMore = UIContextualAction(style: .normal, title: "更多") {
            (action, view, completionHandler)
            in
            print("更多按鈕被按下")
        }
        actionMore.backgroundColor = .blue
        */
        //準備"刪除"按鈕
        let actionDelete = UIContextualAction(style: .normal, title: "刪除") {
            (action, view, completionHandler)
            in
            print("刪除前陣列：\(self.arrTable)")
           //Step1. 先刪除表格對應的該筆陣列資料
            self.arrTable.remove(at: indexPath.row)
           //Step2. 再刪除介面上的該筆儲存格
           tableView.deleteRows(at: [indexPath], with: .fade)
           print("刪除後陣列：\(self.arrTable)")
        }
        actionDelete.backgroundColor = .red
        //將兩個按鈕組合
        let config = UISwipeActionsConfiguration(actions: [actionDelete]) //,actionMore
        //允許滑動到底時，預設執行delete（即上述陣列的第一個元素）
        config.performsFirstActionWithFullSwipe = true
        //回傳按鈕組合
        return config
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        //確認由特定的連接線執行換頁
//        if segue.identifier == "DanceVC"
//        {
            //由連接線的轉換端取得下一頁的執行實體（注意：必須完成精確轉型！）
            let danceVC = segue.destination as! DanceVC
            //直接對下一頁的執行實體，進行屬性傳遞(值型別的傳遞)
            danceVC.webLink = vedioWeb
            //直接對下一頁的執行實體，進行屬性傳遞(引用型別的傳遞)
            danceVC.progressTVC = self
//        }
    }
    
    
    
}

