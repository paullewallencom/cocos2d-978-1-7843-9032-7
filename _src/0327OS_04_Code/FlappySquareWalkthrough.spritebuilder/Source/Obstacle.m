//
//  Obstacle.m
//  FlappySquareWalkthrough
//
//  Created by Ben Trengrove on 25/06/2014.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Obstacle.h"

@interface Obstacle()

@property (nonatomic) CCNode *topBlock;
@property (nonatomic) CCNode *bottomBlock;

@end

@implementation Obstacle

- (void)didLoadFromCCB {
    self.topBlock.physicsBody.collisionType = @"obstacle";
    self.topBlock.physicsBody.sensor = YES;
    self.bottomBlock.physicsBody.collisionType = @"obstacle";
    self.bottomBlock.physicsBody.sensor = YES;
}

@end
