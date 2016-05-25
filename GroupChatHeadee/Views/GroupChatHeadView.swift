import UIKit
let iPhoneChatCardRect = CGRect(x: 10, y: 30, width: 180, height: 215)

extension UIView {
    
    func addCircularShadow() {
        let path = UIBezierPath(roundedRect: self.frame, cornerRadius: self.bounds.width / 2)
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.shadowRadius = 7
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowOpacity = 0.4
        layer.fillColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        layer.zPosition = -1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        if let suprView = self.superview {
            suprView.layer.addSublayer(layer)
        }
    }
    
    func addShadow(shadowColor: UIColor, opacity: Float, shadowRadius: Float, shadowOffset: CGSize ) {
        let path = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: self.bounds.size), cornerRadius: self.layer.cornerRadius)
        let layer = self.layer
        layer.shadowPath = path.CGPath
        layer.shadowColor = shadowColor.CGColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = CGFloat(shadowRadius)
        layer.shadowOffset = shadowOffset
    }
    
}

enum Myself {
    case Include, Exclude
    
    func isIncluded() -> Bool {
        switch self {
        case .Include:
            return true
        case .Exclude:
            return false
        }
    }
}

class GroupChatView: UIView {
    
    private var chatRoom: GroupChatRoom!
    
    var chatHeadImageCV: RoundedView!
    var titleLabel: UILabel!
    var onlineAgo: UILabel!
    var memberLabel: UILabel!
    var chatHeadImages: [UIImageView] = []
    
    var imageCollectionWidth: CGFloat = 150
    
    convenience init(groupChatRoom: GroupChatRoom) {
        self.init(frame: iPhoneChatCardRect)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 2
        self.modelInit(groupChatRoom, frame: frame)
        self.imageCollectionInit()
        self.detailInit()
        
        self.addShadow(UIColor.blackColor(), opacity: 0.1, shadowRadius: 5, shadowOffset: CGSize.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func modelInit(groupChatRoom: GroupChatRoom, frame: CGRect) {
        self.chatRoom = groupChatRoom
        self.imageCollectionWidth = frame.width * 0.4
    }

    func imageCollectionInit() {
        let imageCollectionRect = CGRect(x: self.bounds.midX - imageCollectionWidth / 2, y: self.bounds.minY +  imageCollectionWidth / 4, width: imageCollectionWidth, height: imageCollectionWidth)
        chatHeadImageCV = RoundedView(frame: imageCollectionRect)
        chatHeadImageCV.clipsToBounds = true
        for imageView in populateChatHeadImage() {
            self.chatHeadImageCV.addSubview(imageView)
        }
        self.addSubview(chatHeadImageCV)
        chatHeadImageCV.addCircularShadow()
    }
    
    func populateChatHeadImage() -> [UIImageView]{
        switch chatRoom.personArray.count {
        case 1:
            return initializeChatHeadWithSelf()
        case 2:
            return initializeChatHeadWithTwo()
        case 3:
            return initializeChatHeadWithThree()
        case 4:
            return initializeChatHeadWithFour(Myself.Include)
        default:
            return initializeChatHeadWithFour(Myself.Exclude)
        }
    }

    func detailInit() {
        self.titleLabel = UILabel(frame: CGRect(x: 10, y: self.chatHeadImageCV.frame.maxY + 10, width: self.frame.width - 20, height: 30))
        self.titleLabel.text = self.chatRoom.title
        self.titleLabel.textAlignment = .Center
        self.titleLabel.font = self.titleLabel.font.fontWithSize(14)
        self.addSubview(titleLabel)
        
        self.onlineAgo = UILabel(frame: CGRect(x: 10, y: self.titleLabel.frame.maxY - 10, width: self.frame.width - 20, height: 20))
        self.onlineAgo.text = self.chatRoom.lastOnline
        self.onlineAgo.textAlignment  = .Center
        self.onlineAgo.font = self.onlineAgo.font.fontWithSize(11)
        self.onlineAgo.textColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        self.addSubview(self.onlineAgo)
        
        let line = UIView(frame: CGRect(x: self.onlineAgo.frame.origin.x, y: self.onlineAgo.frame.maxY + 10, width: self.frame.width - 20, height: 1))
        line.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        line.layer.cornerRadius = 1
        self.addSubview(line)
        
        self.memberLabel = UILabel(frame: CGRect(x: 15, y: line.frame.maxY + 10, width: self.frame.width - 30, height: 30))
        self.memberLabel.text = getMemberString(self.chatRoom.personArray)
        self.memberLabel.textAlignment = .Center
        self.memberLabel.textColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        self.memberLabel.font = self.titleLabel.font.fontWithSize(11)
        self.addSubview(memberLabel)
    }
    
    func getMemberString(personArray: [Person]) -> String {
        var resultNames: String = ""
        var totalMember = personArray.count
        
        for person in personArray {
            if totalMember == personArray.count && person.name != "Bored to death"{
                resultNames += person.name
            } else {
                resultNames += ",\(person.name)"
            }
            totalMember -= 1
        }
        return resultNames
    }
    
    func initializeChatHeadWithSelf() -> [UIImageView] {
        var chatHeadImageViewArray: [UIImageView] = []
        let imageView1 = UIImageView(frame: self.chatHeadImageCV.bounds)
        imageView1.image = UIImage(named: "emptyChatRoom")
        chatHeadImageViewArray.append(imageView1)
        return chatHeadImageViewArray
    }
    
    func initializeChatHeadWithTwo() -> [UIImageView] {
        var chatHeadImageViewArray: [UIImageView] = []
        for person in chatRoom.personArray {
            if person.name != "Bored to death" { //the other person
                let imageView1 = UIImageView(frame: self.chatHeadImageCV.bounds)
                imageView1.image = person.image
                chatHeadImageViewArray.append(imageView1)
                break
            }
        }
        return chatHeadImageViewArray
    }
    
    func initializeChatHeadWithThree() -> [UIImageView] {
        var chatHeadImageViewArray: [UIImageView] = []
        var populatedCount = 0
        for person in chatRoom.personArray {
            switch populatedCount {
            case 0:
                let imageView1 = UIImageView(frame: CGRect(x: -self.chatHeadImageCV.bounds.width / 2 - 0.5, y: self.chatHeadImageCV.bounds.minY, width: self.chatHeadImageCV.bounds.width, height: self.chatHeadImageCV.bounds.height))
                imageView1.image = person.image
                chatHeadImageViewArray.append(imageView1)
            case 1:
                let imageView2 = UIImageView(frame: CGRect(x: self.chatHeadImageCV.bounds.width / 2 + 0.5, y: self.chatHeadImageCV.bounds.minY, width: self.chatHeadImageCV.bounds.width / 2, height: self.chatHeadImageCV.bounds.height / 2))
                imageView2.image = person.image
                chatHeadImageViewArray.append(imageView2)
            case 2:
                let imageView3 = UIImageView(frame: CGRect(x: self.chatHeadImageCV.bounds.width / 2 + 0.5, y: self.chatHeadImageCV.bounds.height / 2 + 0.5, width: self.chatHeadImageCV.bounds.width / 2, height: self.chatHeadImageCV.bounds.height / 2))
                imageView3.image = person.image
                chatHeadImageViewArray.append(imageView3)
            default: break
            }
            populatedCount += 1
            if populatedCount == chatRoom.personArray.count {
                break
            }
        }
        return chatHeadImageViewArray
    }
    
    func initializeChatHeadWithFour(myself: Myself) -> [UIImageView] {
        var chatHeadImageViewArray:[UIImageView] = []
        var populatedCount = 0
        for person in chatRoom.personArray {
            if person.name != "Bored to death" || myself.isIncluded() {
                switch populatedCount {
                case 0:
                    let imageView1 = UIImageView(frame: CGRect(x: -0.5, y: -0.5, width: self.chatHeadImageCV.bounds.width / 2, height: self.chatHeadImageCV.bounds.height / 2))
                    imageView1.image = person.image
                    chatHeadImageViewArray.append(imageView1)
                case 1:
                    let imageView2 = UIImageView(frame: CGRect(x: self.chatHeadImageCV.bounds.width / 2 + 0.5, y: -0.5, width: self.chatHeadImageCV.bounds.width / 2, height: self.chatHeadImageCV.bounds.height / 2))
                    imageView2.image = person.image
                    chatHeadImageViewArray.append(imageView2)
                case 2:
                    let imageView3 = UIImageView(frame: CGRect(x: -0.5, y: self.chatHeadImageCV.bounds.height / 2 + 0.5, width: self.chatHeadImageCV.bounds.width / 2, height: self.chatHeadImageCV.bounds.height / 2))
                    imageView3.image = person.image
                    chatHeadImageViewArray.append(imageView3)
                    
                case 3:
                    let imageView4 = UIImageView(frame: CGRect(x: self.chatHeadImageCV.bounds.width / 2 + 0.5, y: self.chatHeadImageCV.bounds.height / 2 + 0.5, width: self.chatHeadImageCV.bounds.width / 2, height: self.chatHeadImageCV.bounds.height / 2))
                    imageView4.image = person.image
                    chatHeadImageViewArray.append(imageView4)
                default: break
                }
                
                populatedCount += 1
                if populatedCount == 4 {
                    break
                }
            }
        }
        return chatHeadImageViewArray
    }
    
}
