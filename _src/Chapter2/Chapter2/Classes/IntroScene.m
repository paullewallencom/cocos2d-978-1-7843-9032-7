//
//  IntroScene.m
//  Chapter2
//
//  Created by Ben Trengrove on 14/06/2014.
//  Copyright Ben Trengrove 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@interface IntroScene()

@property (nonatomic) CCNode *waterBucket;
@property (nonatomic) CCLabelTTF *scoreLabel;
@property (nonatomic) NSMutableArray *drops;

@property (nonatomic, assign) int bucketPosition;
@property (nonatomic, assign) int numberDropped;

@end

static const int kNumberOfPositions = 4;

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);

    self.userInteractionEnabled = YES;
    CCPositionType positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized, CCPositionReferenceCornerBottomLeft);
    
    //Create the water bucket
    CCNode *waterBucket = [CCNode node];
    
    CCSprite *bucketBottom = [CCSprite spriteWithImageNamed:@"bucket_bottom.png"];
    CCSprite *bucketTop = [CCSprite spriteWithImageNamed:@"bucket_top.png"];
    
    bucketBottom.positionType = positionType;
    bucketTop.positionType = positionType;
    
    bucketBottom.anchorPoint = ccp(0.5, 0.0);
    bucketBottom.position = ccp(0.5, 0.0);
    
    bucketTop.anchorPoint = ccp(0.5, 1.0);
    bucketTop.position = ccp(0.5, 1.0);
    
    [waterBucket addChild:bucketTop];
    [waterBucket addChild:bucketBottom];
    
    waterBucket.contentSize = CGSizeMake(bucketBottom.contentSize.width, bucketBottom.contentSize.height + bucketTop.contentSize.height);
    waterBucket.positionType = positionType;
    waterBucket.anchorPoint = ccp(0.5, 0.5);
    waterBucket.position = ccp(0.5, 0.15);
    [self addChild:waterBucket z:1];
    self.waterBucket = waterBucket;
    
    CCLabelTTF *score = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Marker Felt" fontSize:12.0];
    score.positionType = positionType;
    score.position = ccp(0.05, 0.95);
    score.anchorPoint = ccp(0, 0.5);
    [self addChild:score];
    self.scoreLabel = score;
    
    waterBucket.scale = 0.5;
    
    [self newGame];

	return self;
}

#pragma mark - Game Methods

- (void)update:(CCTime)delta {
    //Check every drop on screen
    for (int i = self.drops.count-1; i>=0; i--) {
        CCNode *drop = self.drops[i];
        //First check if the water drop has reached the bucket height
        if (drop.position.y <= self.waterBucket.position.y) {
            //Water drop is at bucket height
            //Next check if the bucket is in the correct position
            if (drop.position.x == self.waterBucket.position.x) {
                
                //If it it remove the drop from the screen
                [drop removeFromParent];
                [self.drops removeObject:drop];
                
                //Update the score
                self.scoreLabel.string = [NSString stringWithFormat:@"Score: %d", self.numberDropped];
                
                //Create a new drop
                [self spawnWaterDrop];
            } else {
                //The drop was missed, start a new game
                [self newGame];
            }
        }
    }
}

- (void)newGame {
    //Reset the properties
    self.numberDropped = 0;
    self.bucketPosition = 0;
    
    //If we already have drops, remove them from the parent
    if (self.drops) {
        for (CCNode *drop in self.drops) {
            [drop removeFromParent];
        }
    }
    
    //Setup a new drops array
    self.drops = [NSMutableArray array];
    
    //Reset the score label
    self.scoreLabel.string = @"Score: 0";
    
    [self spawnWaterDrop];
}

- (void)spawnWaterDrop {
    CCPositionType positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized, CCPositionReferenceCornerBottomLeft);
    
    CGFloat positionX = (1 + (float)arc4random_uniform(kNumberOfPositions)) / ((float)kNumberOfPositions + 1);
    
    CCSprite *waterDrop = [CCSprite spriteWithImageNamed:@"water_drop.png"];
    waterDrop.positionType = positionType;
    waterDrop.anchorPoint = ccp(0.5, 0.0);
    waterDrop.position = ccp(positionX, 1.0);
    [self addChild:waterDrop];
    
    CGFloat time = 3.0 - (self.numberDropped / 10.0);
    CCActionMoveTo *move = [CCActionMoveTo actionWithDuration:time position:ccp(positionX, 0)];
    [waterDrop runAction:move];
    
    [self.drops addObject:waterDrop];
    self.numberDropped++;
}

#pragma mark - Touch Methods

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    CGFloat halfWay = self.contentSize.width/2;
    
    if (touchLocation.x < halfWay) {
        self.bucketPosition--;
    } else {
        self.bucketPosition++;
    }
}

#pragma mark - Custom Setters/Getters

- (void)setBucketPosition:(int)bucketPosition {
    //Limit the values of this property
    if (bucketPosition < 0) {
        bucketPosition = 0;
    } else if (bucketPosition > kNumberOfPositions-1) {
        bucketPosition = kNumberOfPositions - 1;
    }
    
    //Update the position of the water bucket
    _bucketPosition = bucketPosition;
    CGFloat positionX = (float)(1 + bucketPosition) / ((float)kNumberOfPositions+1);
    
    self.waterBucket.position = ccp(positionX, self.waterBucket.position.y);
}

@end
