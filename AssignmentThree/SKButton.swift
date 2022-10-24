//
//  SKButton.swift
//  AssignmentThree
//
//  Created by Simon on 10/23/22.
//

import UIKit
import SpriteKit

// Wrapper around SKLabelNode to access touch events
class SKButton: SKLabelNode {
    
    var touchBeganCallback: (() -> Void)?
    var touchEndedCallback: (() -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchBeganCallback?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEndedCallback?()
    }
}
