//
//  CameraOptViewController.swift
//  SomatoApp
//
//  Created by Sandor ferreira da silva on 04/09/17.
//  Copyright © 2017 Sandor Ferreira da Silva. All rights reserved.
//

import UIKit

class CameraOptViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        var v1 : View1 = View1(nibName: "View1", bundle: nil)
        
        
        var v2 : View2 = View2(nibName: "View2", bundle: nil)
        
        self.addChildViewController(v1)
        self.scrollView.addSubview(v1.view)
        v1.didMove(toParentViewController: self)
        
        self.addChildViewController(v2)
        self.scrollView.addSubview(v2.view)
        v2.didMove(toParentViewController: self)
        
        var v2ViewFrame : CGRect = v2.view.frame //viewControllerMulher!.view.frame
        v2ViewFrame.origin.x = self.view.frame.width
        v2.view.frame = v2ViewFrame
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: self.view.frame.height)
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let contentXOffset = scrollView.contentOffset.x
        let distanceFromRight = scrollView.contentSize.width - contentXOffset
        if distanceFromRight == width {
            // está em Mulher ou segunda posição
            fotoString = "mulher_1"
            print(fotoString)
        } else if distanceFromRight == width * 2{
            fotoString = "homem_1"
            print(fotoString)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
