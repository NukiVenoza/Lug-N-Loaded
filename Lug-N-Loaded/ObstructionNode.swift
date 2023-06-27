import Foundation
import SpriteKit

class ObstructionNode: SKNode {
    var background : SKSpriteNode!
    var container : SKSpriteNode!
    var parentView: SKView!
    var instruction: SKSpriteNode!
    var player : String!
    
    var textFieldBackground = SKSpriteNode()
    var textFieldBackground2 = SKSpriteNode()
    var textFieldBackground3 = SKSpriteNode()
    var textFieldBackground4 = SKSpriteNode()
    
    var textField: UITextField!
    var textField2: UITextField!
    var textField3: UITextField!
    var textField4: UITextField!
    
    var isCorrect = false
    
    var button1 = SKSpriteNode(imageNamed: "1.png")
    var button2 = SKSpriteNode(imageNamed: "2.png")
    var button3 = SKSpriteNode(imageNamed: "3.png")
    var button4 = SKSpriteNode(imageNamed: "4.png")
    
    var inputText = ""
    
    init(player: String, size: CGSize, parentView: SKView) {
        super.init()
        
        self.player = player
        self.parentView = parentView
        self.textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        self.textField2 = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        self.textField3 = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        self.textField4 = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        setupBackground(size: size)
        setupContainer()
        setupInstruction()
        
        if player == "Player1"{
            setupButtons()
            setupTextField()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupInstruction() {
        if player == "Player1" {
            instruction = SKSpriteNode(imageNamed: "obsInstruction1.png")
            instruction.setScale(0.05)
            instruction.zPosition = 3000
            instruction.position = CGPoint(x: -250, y: 125)
            addChild(instruction)
        } else {
            instruction = SKSpriteNode(imageNamed: "obsInstruction2.png")
            instruction.setScale(0.05)
            instruction.zPosition = 3000
            instruction.position = CGPoint(x: -250, y: 125)
            addChild(instruction)
        }
    }
    
    private func setupBackground(size: CGSize) {
        background = SKSpriteNode(imageNamed: "obsBackground.png")
        background.size = size
        background.alpha = 0.9
        background.zPosition = -100
        addChild(background)
    }
    
    private func setupContainer() {
        if player == "Player1" {
            container = SKSpriteNode(imageNamed: "Alarm1.png")
            container.size = CGSize(width: 210, height: 280)
            container.position.y = 90
            container.zPosition = 1000
            addChild(container)
        } else {
            container = SKSpriteNode(imageNamed: "Telecomunicator.png")
            container.size = CGSize(width: 280, height: 333)
            container.position.y = 60
            container.zPosition = 1000
            addChild(container)
        }
    }
    
    private func setupButtons() {
            button1.size = CGSize(width: 60, height: 60)
            button1.position = CGPoint(x: -150, y: -100)
            button1.name = "1"
            button1.zPosition = 1000
            
            button2.size = CGSize(width: 60, height: 60)
            button2.position = CGPoint(x: -50, y: -100)
            button2.name = "2"
            button2.zPosition = 1000
            
            button3.size = CGSize(width: 60, height: 60)
            button3.position = CGPoint(x: 50, y: -100)
            button3.name = "3"
            button3.zPosition = 1000
            
            button4.size = CGSize(width: 60, height: 60)
            button4.position = CGPoint(x: 150, y: -100)
            button4.name = "4"
            button4.zPosition = 1000
            
            addChild(button1)
            addChild(button2)
            addChild(button3)
            addChild(button4)
    }
    
    private func setupTextField() {
//        if player == "Player1" {
            textFieldBackground.size = CGSize(width: 20, height: 50)
            textFieldBackground.position = CGPoint(x: parentView.frame.midX - 80, y: parentView.frame.midY - 15)
            textFieldBackground.zPosition = 1000
            
            textFieldBackground2.size = CGSize(width: 20, height: 50)
            textFieldBackground2.position = CGPoint(x: parentView.frame.midX - 25, y: parentView.frame.midY - 15)
            textFieldBackground2.zPosition = 1000

            textFieldBackground3.size = CGSize(width: 20, height: 50)
            textFieldBackground3.position = CGPoint(x: parentView.frame.midX + 30, y: parentView.frame.midY - 15)
            textFieldBackground3.zPosition = 1000

            textFieldBackground4.size = CGSize(width: 20, height: 50)
            textFieldBackground4.position = CGPoint(x: parentView.frame.midX + 85, y: parentView.frame.midY - 15)
            textFieldBackground4.zPosition = 1000

            addChild(textFieldBackground)
            addChild(textFieldBackground2)
            addChild(textFieldBackground3)
            addChild(textFieldBackground4)
            
            let newFontSize: CGFloat = 40.0
            let newFont = UIFont.systemFont(ofSize: newFontSize)
            
            textField.text = ""
            textField.keyboardType = .numberPad
            textField.isUserInteractionEnabled = false
            textField.textAlignment = .center
            textField.textColor = .black
            textField.frame = textFieldBackground.frame
            textField.font = newFont
            parentView.addSubview(textField)
            
            textField2.text = ""
            textField2.keyboardType = .numberPad
            textField2.isUserInteractionEnabled = false
            textField2.textAlignment = .center
            textField2.textColor = .black
            textField2.frame = textFieldBackground2.frame
            textField2.font = newFont
            parentView.addSubview(textField2)
            
            textField3.text = ""
            textField3.keyboardType = .numberPad
            textField3.isUserInteractionEnabled = false
            textField3.textAlignment = .center
            textField3.textColor = .black
            textField3.frame = textFieldBackground3.frame
            textField3.font = newFont
            parentView.addSubview(textField3)
            
            textField4.text = ""
            textField4.keyboardType = .numberPad
            textField4.isUserInteractionEnabled = false
            textField4.textAlignment = .center
            textField4.textColor = .black
            textField4.frame = textFieldBackground4.frame
            textField4.font = newFont
            parentView.addSubview(textField4)
//        } else {
//            return
//        }
    }
    
    func removeTextField() -> Bool {
        textField.removeFromSuperview()
        textField2.removeFromSuperview()
        textField3.removeFromSuperview()
        textField4.removeFromSuperview()
        return isCorrect
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if let nodeName = touchedNode.name {
            if textField.text == "" {
                textField.text = nodeName
                inputText = inputText + (textField.text ?? nodeName)
            } else if textField.text != "" && textField2.text == "" {
                textField2.text = nodeName
                inputText = inputText + (textField2.text ?? nodeName)
            } else if textField2.text != "" && textField3.text == "" {
                textField3.text = nodeName
                inputText = inputText + (textField3.text ?? nodeName)
            } else if textField3.text != "" && textField4.text == "" {
                textField4.text = nodeName
                inputText = inputText + (textField4.text ?? nodeName)
                checkEligibility()
            }
            
            // Add animation to the button
            touchedNode.run(SKAction.sequence([
                SKAction.scale(to: 0.9, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ]))
        }
    }
    
    func checkEligibility(){
        if inputText == "3214" {
            isCorrect = true
        } else {
            textField.text = ""
            textField2.text = ""
            textField3.text = ""
            textField4.text = ""
            inputText = ""
        }
    }
}
