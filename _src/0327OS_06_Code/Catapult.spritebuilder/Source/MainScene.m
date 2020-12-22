//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@interface MainScene ()

@property (nonatomic, strong) CCPhysicsNode *physicsNode;
@property (nonatomic, strong) CCNode *catapultArm;
@property (nonatomic, strong) CCNode *touchNode;
@property (nonatomic, strong) CCPhysicsJoint *touchJoint;

@property (nonatomic, strong) CCNode *brick;
@property (nonatomic, strong) CCPhysicsJoint *brickJoint;

@end

@implementation MainScene

- (void)didLoadFromCCB {
    self.physicsNode.debugDraw = YES;
    self.userInteractionEnabled = YES;
    
    self.touchNode.physicsBody.collisionMask = @[];
}

- (void)touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    
    //Is the touch location in the catapult arm?
    if (CGRectContainsPoint(self.catapultArm.boundingBox, touchLocation)) {
        //Move the touch node to the position of the touch.
        self.touchNode.position = touchLocation;
        
        //Attach a spring between the touch node and the catapult arm
        self.touchJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:self.touchNode.physicsBody bodyB:self.catapultArm.physicsBody anchorA:ccp(0, 0) anchorB:ccp(15, 15) restLength:0.0f stiffness:3000.0f damping:150.0f];
        
        //Setup the brick
        CCNode *brick = [CCBReader load:@"Brick"];
        CGPoint brickPosition = [self.catapultArm convertToWorldSpace:ccp(35, 35)];
        brick.position = brickPosition;
        [self.physicsNode addChild:brick];
        self.brick.physicsBody.collisionMask = @[];
        self.brick.physicsBody.allowsRotation = NO;
        self.brick = brick;
        
        self.brickJoint = [CCPhysicsJoint connectedPivotJointWithBodyA:brick.physicsBody bodyB:self.catapultArm.physicsBody anchorA:ccp(15, 15)];
    }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    self.touchNode.position = touchLocation;
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self fireCatapult];
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self fireCatapult];
}

- (void)fireCatapult {
    if (self.touchJoint) {
        [self.touchJoint invalidate];
        self.touchJoint = nil;
        
        [self.brickJoint invalidate];
        self.brickJoint = nil;
        
        self.brick.physicsBody.collisionMask = nil;
        self.brick.physicsBody.allowsRotation = YES;
    }
}

@end
