//
//  TaskTableViewCell.swift
//  PPMS
//
//  Created by Jansen on 2/22/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit

protocol TaskTableViewCellDelegate {
    // indicates that the given item has been deleted
    func toDoItemDeleted(todoItem: ToDoItem)
    // Indicates that the edit process has begun for the given cell
    func cellDidBeginEditing(editingCell: TaskTableViewCell)
    // Indicates that the edit process has committed for the given cell
    func cellDidEndEditing(editingCell: TaskTableViewCell)
}


class TaskTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    let gradientLayer = CAGradientLayer()
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var completeOnDragRelease = false
    
    var label: StrikeThroughText = StrikeThroughText()
    var itemCompleteLayer = CALayer()
    
    var tickLabel: UILabel
    var crossLabel: UILabel
    
    // The object that acts as delegate for this cell.
    var delegate: TaskTableViewCellDelegate?
    // The item that this cell renders.
    var toDoItem: ToDoItem? {
        didSet {
            label.text = toDoItem!.text
            label.strikeThrough = toDoItem!.completed
            itemCompleteLayer.isHidden = !label.strikeThrough
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.tickLabel = UILabel()
        self.crossLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initWithUI()

    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")\
        
        // utility method for creating the contextual cues
        func createCueLabel() -> UILabel {
            let label = UILabel(frame: CGRect.null)
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 32.0)
            label.backgroundColor = UIColor.clear
            return label
        }
        
        // tick and cross labels for context cues
        tickLabel = createCueLabel()
        tickLabel.text = "\u{2713}"
        tickLabel.textAlignment = .right
        crossLabel = createCueLabel()
        crossLabel.text = "\u{2717}"
        crossLabel.textAlignment = .left
        
        super.init(coder: aDecoder)
        
        
        
        //        self.addSubview(tickLabel)
        //        self.addSubview(crossLabel)
        
        // create a label that renders the to-do item text
        initWithUI()
        
    }
    func initWithUI() {
        label = StrikeThroughText(frame: CGRect.null)
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        
        
        //Gradient Layer
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
        let color3 = UIColor.clear.cgColor as CGColor
        let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
        
        
        
        itemCompleteLayer = CALayer(layer: layer)
        itemCompleteLayer.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0,
                                                    alpha: 1.0).cgColor
        itemCompleteLayer.isHidden = true
        layer.insertSublayer(itemCompleteLayer, at: 0)
        
        addSubview(label)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)

    }
    
    
    // utility method for creating the contextual cues
    //    func createCueLabel() -> UILabel {
    //        let label = UILabel(frame: CGRect.null)
    //        label.textColor = UIColor.whiteColor()
    //        label.font = UIFont.boldSystemFontOfSize(32.0)
    //        label.backgroundColor = UIColor.clearColor()
    //        return label
    //    }
    
    let kLabelLeftMargin: CGFloat = 15.0
    let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 50.0
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        // ensure the gradient layer occupies the full bounds
        gradientLayer.frame = bounds
        itemCompleteLayer.frame = bounds
        label.frame = CGRect(x: kLabelLeftMargin, y: 0,
                             width: bounds.size.width - kLabelLeftMargin,
                             height: bounds.size.height)
        
        
        tickLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0,
                                 width: kUICuesWidth, height: bounds.size.height)
        crossLabel.frame = CGRect(x: bounds.size.width - kUICuesWidth, y: 0,
                                  width: kUICuesWidth, height: bounds.size.height)
        tickLabel.isHidden = true
        crossLabel.isHidden = true
    }
    
    //MARK: - horizontal pan gesture methods
    func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            completeOnDragRelease = frame.origin.x > frame.size.width / 2.0
            
            // fade the contextual clues
            //            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)
            //            tickLabel.alpha = cueAlpha
            //            crossLabel.alpha = cueAlpha
            // indicate when the user has pulled the item far enough to invoke the given action
            tickLabel.textColor = completeOnDragRelease ? UIColor.green : UIColor.white
            crossLabel.textColor = deleteOnDragRelease ? UIColor.red : UIColor.white
            tickLabel.isHidden = false
            crossLabel.isHidden = false
        }
        // 3
        if recognizer.state == .ended {
            // the frame this cell had before user dragged it
            
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if deleteOnDragRelease {
                if delegate != nil && toDoItem != nil {
                    // notify the delegate that this item should be deleted
                    delegate!.toDoItemDeleted(todoItem: toDoItem!)
                }
            } else if completeOnDragRelease {
                if toDoItem != nil {
                    toDoItem!.completed = !((toDoItem?.completed)!)
                    Task().AddOrUpdate(toDoItem: toDoItem!)
                }
                label.strikeThrough = (toDoItem?.completed)!
                itemCompleteLayer.isHidden = !((toDoItem?.completed)!)
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            } else {
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            }
            
            tickLabel.isHidden = true
            crossLabel.isHidden = true
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // close the keyboard on Enter
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // disable editing of completed to-do items
        if toDoItem != nil {
            return !toDoItem!.completed
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if toDoItem != nil {
            toDoItem!.text = textField.text!
            Task().AddOrUpdate(toDoItem: toDoItem!)
        }
        if delegate != nil {
            delegate!.cellDidEndEditing(editingCell: self)
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if delegate != nil {
            delegate!.cellDidBeginEditing(editingCell: self)
        }
    }
    
    
    
    
}
