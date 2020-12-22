//
//  Gameplay.m
//  FlappySquareWalkthrough
//
//  Created by Ben Trengrove on 25/06/2014.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@interface Gameplay() <CCPhysicsCollisionDelegate>

@property (nonatomic) CCNode *character;

@property (nonatomic) NSMutableArray *obstacles;
@property (nonatomic) CCNode *obstacle1;
@property (nonatomic) CCNode *obstacle2;
@property (nonatomic) CCNode *obstacle3;

@property (nonatomic) CCPhysicsNode *physicsRootNode;

@end

@implementation Gameplay

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    self.obstacles = [NSMutableArray arrayWithObjects:self.obstacle1, self.obstacle2, self.obstacle3, nil];
    
    self.physicsRootNode.collisionDelegate = self;
    self.character.physicsBody.collisionType = @"character";
}

- (void)update:(CCTime)delta {
    // clamp velocity
    CGFloat yVelocity = clampf(self.character.physicsBody.velocity.y, -1 * MAXFLOAT, 200.f);
    self.character.physicsBody.velocity = ccp(0, yVelocity);
    
    //Move the obstacles across the screen
    for (CCNode *obstacle in self.obstacles) {
        obstacle.position = ccpSub(obstacle.position, ccp(3.0, 0));
        
        //Check if they have gone off screen, if they have reposition them
        if (obstacle.position.x < -obstacle.contentSize.width) {
            int y = -(arc4random_uniform(180)+70);
            obstacle.position = ccp(self.boundingBox.size.width * 2, y);
        }
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self flap];
}

- (void)flap {
    CGPoint forceDirection = ccp(0.0, 1.0);
    CGPoint force = ccpMult(forceDirection, 800);
    [self.character.physicsBody applyImpulse:force];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(CCNode *)nodeA obstacle:(CCNode *)nodeB {
    CCLOG(@"Game over");
    [[CCDirector sharedDirector] popScene];
    return YES;
}

@end
