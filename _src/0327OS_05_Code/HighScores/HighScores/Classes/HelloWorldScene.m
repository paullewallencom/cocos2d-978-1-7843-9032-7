//
//  HelloWorldScene.m
//  HighScores
//
//  Created by Ben Trengrove on 13/08/2014.
//  Copyright Ben Trengrove 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@interface HelloWorldScene () <CCTableViewDataSource>

@property (nonatomic, strong) NSArray *scores;

@end

@implementation HelloWorldScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;

    self.scores = @[@"5050", @"3500", @"3400", @"2300", @"1100", @"500"];
    
    CCTableView* table = [CCTableView node];
    table.dataSource = self; // make our class the data source
    table.block = ^(CCTableView* table) {
        NSLog(@"Cell %d was pressed", (int) table.selectedRow);
    };

    [self addChild:table];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];

    
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
#pragma mark - CCTableViewDataSource
// -----------------------------------------------------------------------

- (CCTableViewCell*)tableView:(CCTableView *)tableView nodeForRowAtIndex:(NSUInteger)index {
    CGSize cellSize = CGSizeMake(150.0f, 50.0f);
    
    CCTableViewCell* cell = [CCTableViewCell node];
    cell.contentSize = cellSize;
    
    float colorAdjust = (index / (float)self.scores.count);
    CCNodeColor* colorNode = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.1f green:0.1f blue:(0.5f + 0.5f * colorAdjust) ] width:cellSize.width height:cellSize.height];
    
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:self.scores[index] fontName:@"Marker Felt" fontSize:22.0f];
    scoreLabel.position = ccp(colorNode.boundingBox.size.width/2, colorNode.boundingBox.size.height/2);
    scoreLabel.anchorPoint = ccp(0.5, 0.5);
    [colorNode addChild:scoreLabel];
    
    [cell addChild:colorNode];
    return cell;
}

- (NSUInteger)tableViewNumberOfRows:(CCTableView *)tableView {
    return self.scores.count;
}

- (float) tableView:(CCTableView*)tableView heightForRowAtIndex:(NSUInteger) index {
    return 50.0f;
}

// -----------------------------------------------------------------------
@end
