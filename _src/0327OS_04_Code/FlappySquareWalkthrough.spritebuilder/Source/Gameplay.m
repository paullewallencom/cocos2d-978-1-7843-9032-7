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

@property (assign) CGFloat timeSinceLastTouch;

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
    
    self.timeSinceLastTouch += delta;
    self.character.rotation = clampf(self.character.rotation, -30.f, 90.f);
    if (self.character.physicsBody.allowsRotation) {
        float angularVelocity = clampf(self.character.physicsBody.angularVelocity, -2.f, 1.f);
        self.character.physicsBody.angularVelocity = angularVelocity;
    }
    if ((self.timeSinceLastTouch > 0.5f)) {
        [self.character.physicsBody applyAngularImpulse:-40000.f*delta];
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self flap];

    self.timeSinceLastTouch = 0.0f;
}

- (void)flap {
    CGPoint forceDirection = ccp(0.0, 1.0);
    CGPoint force = ccpMult(forceDirection, 800);
    [self.character.physicsBody applyImpulse:force];
    [self.character.physicsBody applyAngularImpulse:10000.f];
    
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"FlapParticles"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the characters
    explosion.position = self.character.position;
    // add the particle effect to the same parent as the character
    [self.character.parent addChild:explosion];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(CCNode *)nodeA obstacle:(CCNode *)nodeB {
    CCLOG(@"Game over");
    [[CCDirector sharedDirector] popScene];
    return YES;
}

@end
