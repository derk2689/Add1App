//
//  MainViewController.swift
//  Add 1
//
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController
{
    @IBOutlet weak var numbersLabel:UILabel?
    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var userInput:UITextField?
    @IBOutlet weak var timeLabel:UILabel?
    
    var userScore:Int = 0
    var timer:Timer?
    var seconds:Int = 15
    var count = 2
    var numberToCheck = 11
    
    var hud:MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRandomNumberLabel()
        updateScoreLabel()
        updateTimeLabel()
        
        hud = MBProgressHUD(view:self.view)
        
        if(hud != nil) {
            self.view.addSubview(hud!)
        }
        
        userInput?.addTarget(self, action: #selector(textDidChange(textField:)), for:UIControlEvents.editingChanged)
    }
    
    @objc func textDidChange(textField:UITextField) {
        if userInput?.text?.count ?? 0 < count - 1 {
            return
        }
        
        if  let numberLabel    = numbersLabel?.text,
            let userInputText      = userInput?.text,
            let number         = Int(numberLabel),
            let userInput           = Int(userInputText)
        {
            print("Comparing: \(userInputText) minus \(numberLabel) == \(userInput - number)")
            
            if(userInput - number == numberToCheck) {
                print(userInput - number)
                userScore += 1
                
                show(isRight: true)
            }
            else {
                print("Incorrect!")
                
                userScore -= 1
                
                show(isRight: false)
            }
            
        }
        
        getNumberToCheck()
        setupRandomNumberLabel()
        updateScoreLabel()
       
        
        if(timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:#selector(onTimeUpdate), userInfo:nil, repeats:true)
        }
    }
    
    @objc func onTimeUpdate()
    {
        if(seconds > 0 && seconds <= 60) {
            seconds -= 1
            
            updateTimeLabel()
        }
        else if(seconds == 0) {
            if(timer != nil) {
                timer!.invalidate()
                timer = nil
                
                let alertController = UIAlertController(title: "Time Up!", message: "Your time is up! You got a score of: \(userScore) points. Very good!", preferredStyle: .alert)
                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: nil)
                alertController.addAction(restartAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                userScore = 0
                seconds = 60
                count = 2
                updateTimeLabel()
                updateScoreLabel()
                setupRandomNumberLabel()
            }   
        }  
    }
    
    func updateTimeLabel() {
        if(timeLabel != nil) {
            let minutes:Int = (seconds / 60) % 60
            let second:Int = seconds % 60
            
            let minutesPassed:String = String(format: "%02d", minutes)
            let secondsPassed:String = String(format: "%02d", second)
            
            timeLabel!.text = "\(minutesPassed):\(secondsPassed)"
        }
    }
    
    func show(isRight:Bool) {
        var imageView:UIImageView?
        
        if isRight {
            imageView = UIImageView(image: UIImage(named:"thumbs-up"))
        }
        else {
            imageView = UIImageView(image: UIImage(named:"thumbs-down"))
        }
        
        if(imageView != nil) {
            hud?.mode = MBProgressHUDMode.customView
            hud?.customView = imageView
            
            hud?.show(animated: true)
            
            self.userInput?.text = ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hud?.hide(animated: true)
            }
        }
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = "\(userScore)"
    }
    
    func setupRandomNumberLabel() {
        numbersLabel?.text = getRandomNumber()
    }
    
    func getRandomNumber() -> String {
        var randomNumber:String = ""
        
        for _ in 1...count
        {
            let digit:Int = Int(arc4random_uniform(8) + 1)
            
            
            randomNumber += "\(digit)"
        }
        count = count != 5 ? count + 1 : 5
//        count = count + 1
        return randomNumber  
    }

    func getNumberToCheck()  {
        var randomNum:String = ""
        
        for _ in 1...count
        {
            let digit:Int = Int(arc4random_uniform(1) + 1)

            randomNum += "\(digit)"
        }
        numberToCheck = Int(randomNum)!
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
