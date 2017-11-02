//
//  SQDemoViewController.swift
//  wulewa
//
//  Created by 苏强 on 2017/10/30.
//  Copyright © 2017年 sugercode. All rights reserved.
//

import UIKit

class SQDemoViewController: UITableViewController {
    
    
    let dataArray = [["title":"横向线性","file":"linear_layout_horizontal.json"],
                     ["title":"纵向线性","file":"linear_layout_horizontal1.json"],
                     ["title":"混合线性","file":"linear_layout_mix.json"],
                     ["title":"横向权重等分","file":"linear_layout_weight_split.json"],
                     ["title":"纵向权重等分","file":"linear_layout_weight_split_vertical.json"],
                     ["title":"居右上对齐","file":"linear_layout_align_right_top.json"],
                     ["title":"居中中对齐","file":"linear_layout_align_center_center.json"],
                     ["title":"居中下对齐","file":"linear_layout_align_center_bottom.json"],
                     ["title":"居右下对齐","file":"linear_layout_align_right_bottom.json"],
                     ["title":"居右下对齐覆盖","file":"linear_layout_align_right_bottom_override.json"],
                     ["title":"居右下对齐覆盖纵向","file":"linear_layout_align_right_bottom_override_vertical.json"],
                     ["title":"帧布局","file":"frame_layout.json"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.clearsSelectionOnViewWillAppear = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let info = dataArray[indexPath.row]
        
        cell.textLabel?.text = info["title"]!
        cell.detailTextLabel?.text = info["file"]!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = dataArray[indexPath.row]
        
        let file = info["file"]!
        
        let vc = SQLayoutViewController(filepath: file)
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
