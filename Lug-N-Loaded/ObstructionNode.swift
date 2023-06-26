import Foundation
import SpriteKit

class ObstructionNode: SKNode {
    var background = SKSpriteNode()
    var textFieldBackground = SKSpriteNode()
    var container = SKSpriteNode()
    var parentView: SKView!
    var textField: UITextField!
    
    var isCorrect = false
    
    var button1 = SKSpriteNode(imageNamed: "1.png")
    var button2 = SKSpriteNode(imageNamed: "2.png")
    var button3 = SKSpriteNode(imageNamed: "3.png")
    var button4 = SKSpriteNode(imageNamed: "4.png")
    
    init(size: CGSize, parentView: SKView) {
        super.init()
        
        self.parentView = parentView
        self.textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        setupBackground(size: size)
        setupContainer()
        setupButtons()
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupBackground(size: CGSize) {
        background.size = size
        background.color = UIColor(red: 100, green: 0, blue: 0, alpha: 0.75)
        addChild(background)
    }
    
    private func setupContainer() {
        container.size = CGSize(width: 300, height: 200)
        container.color = UIColor(red: 0.4, green: 0.6, blue: 0.76, alpha: 1)
        addChild(container)
    }
    
    private func setupButtons() {
        button1.size = CGSize(width: 44, height: 44)
        button1.position = CGPoint(x: -75, y: -50)
        button1.name = "1"
        addChild(button1)
        
        button2.size = CGSize(width: 44, height: 44)
        button2.position = CGPoint(x: -25, y: -50)
        button2.name = "2"
        button2.name = "2"
        addChild(button2)
        
        button3.size = CGSize(width: 44, height: 44)
        button3.position = CGPoint(x: 25, y: -50)
        button3.name = "3"
        button3.name = "3"
        addChild(button3)
        
        button4.size = CGSize(width: 44, height: 44)
        button4.position = CGPoint(x: 75, y: -50)
        button4.name = "4"
        button4.name = "4"
        addChild(button4)
    }
    
    private func setupTextField() {
        textFieldBackground.size = CGSize(width: 200, height: 50)
        textFieldBackground.position = CGPoint(x: parentView.frame.midX, y: parentView.frame.midY - 25)
        addChild(textFieldBackground)
        
        textField.backgroundColor = UIColor.red
        textField.keyboardType = .numberPad
        textField.placeholder = "INPUT YOUR TOKEN"
        textField.isUserInteractionEnabled = false
        textField.textAlignment = .center
        
        textField.textColor = .black
        textField.frame = textFieldBackground.frame
        parentView.addSubview(textField)
    }
    
    func removeTextField() -> Bool {
        textField.removeFromSuperview()
        return isCorrect
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if let nodeName = touchedNode.name {
            if textField.text?.count ?? 0 < 4 {
                textField.text = (textField.text ?? "") + nodeName
                if textField.text?.count == 4 && textField.text == "2234" {
                    isCorrect = true
                }
            }
            else {
                if textField.text == "2234" {
                    isCorrect = true
                }
                else {
                    isCorrect = false
                }
            }
        }
    }
}
