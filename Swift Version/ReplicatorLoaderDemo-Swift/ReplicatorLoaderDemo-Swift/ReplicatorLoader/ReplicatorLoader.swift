//
//  ReplicatorLoader.swift
//  ReplicatorLoaderDemo-Swift
//
//  Created by Kitten Yang on 2/3/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

struct Options {
    var color: UIColor
    var alpha: Float = 1.0
}

enum LoaderType {
    case Pulse(option: Options)
    case DotsFlip(option: Options)
    case GridScale(option: Options)
    
    var replicatorLayer: Replicatable{
        switch self {
        case .Pulse(_):
            return PulseReplicatorLayer()
        case .DotsFlip(_):
            return DotsFlipReplicatorLayer()
        case .GridScale(_):
            return GridReplicatorLayer()
        }
    }
    
}

protocol Replicatable {
    func configureReplicatorLayer(layer: CALayer, option: Options)
}

class ReplicatorLoader: UIView {

    init(frame: CGRect, type: LoaderType) {
        super.init(frame: frame)
        setUp(type)
    }
    
    private func setUp(type: LoaderType) {
        switch type {
        case let .Pulse(option):
            type.replicatorLayer.configureReplicatorLayer(layer, option: option)
        case let .DotsFlip(option):
            type.replicatorLayer.configureReplicatorLayer(layer, option: option)
        case let .GridScale(option):
            type.replicatorLayer.configureReplicatorLayer(layer, option: option)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
