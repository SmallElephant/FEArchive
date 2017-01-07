//
//  ViewController.swift
//  FEArchive
//
//  Created by FlyElephant on 17/1/7.
//  Copyright © 2017年 FlyElephant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var zipPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func zipAction(_ sender: UIButton) {
        let imageDataPath = Bundle.main.bundleURL.appendingPathComponent("FlyElephant").path
        
        zipPath = tempZipPath()
        
        let success = SSZipArchive.createZipFile(atPath: zipPath!, withContentsOfDirectory: imageDataPath)
        if success {
            print("压缩成功---\(zipPath!)")
        }
    }

    @IBAction func unZipAction(_ sender: UIButton) {
        guard let zipPath = self.zipPath else {
            return
        }
        
        guard let unzipPath = tempUnzipPath() else {
            return
        }
        
        let success = SSZipArchive.unzipFile(atPath: zipPath, toDestination: unzipPath)
        if !success {
            return
        }
        print("解压成功---\(unzipPath)")
        var items: [String]
        do {
            items = try FileManager.default.contentsOfDirectory(atPath: unzipPath)
        } catch {
            return
        }
        
        for (index, item) in items.enumerated() {
            print("\(index)--文件名称---\(item)")
        }
    }
    
    // MARK: Private
    
    func tempZipPath() -> String {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/\(UUID().uuidString).zip"
        return path
    }
    
    func tempUnzipPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/\(UUID().uuidString)"
        let url = URL(fileURLWithPath: path)
        
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        
        
        return url.path
    }

}

