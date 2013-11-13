//
//  MyScene.m
//  AnimatedBear
//
//  Created by Артем Новичков on 11/13/13.
//  Copyright (c) 2013 Артем Новичков. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
{
    
    SKSpriteNode *_bear;
    NSArray *_bearWalkingFrames;
    
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor blackColor];

        NSMutableArray * walkFrames = [NSMutableArray array];
        SKTextureAtlas * bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"BearImages"];
        int numImages = bearAnimatedAtlas.textureNames.count;
        for (int i=1; i <= numImages/2; i++) {
            NSString * textureName = [NSString stringWithFormat:@"bear%d", i];
            SKTexture * temp = [bearAnimatedAtlas textureNamed:textureName];
            [walkFrames addObject:temp];
        }
        _bearWalkingFrames = walkFrames;
        SKTexture *temp = _bearWalkingFrames[0];
        _bear = [SKSpriteNode spriteNodeWithTexture:temp];
        _bear.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:_bear];
        [self walkingBear];
    }
    return self;
}

-(void)walkingBear
{
    [_bear runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:_bearWalkingFrames
                                       timePerFrame:0.1f
                                             resize:NO
                                            restore:YES]] withKey:@"walkingInPlaceBear"];
    return;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInNode:self];
    CGFloat multiplierForDirection;
    CGSize screenSize = self.frame.size;
    float bearVelocity = screenSize.width/3.0;
    CGPoint moveDifference = CGPointMake(location.x - _bear.position.x, location.y - _bear.position.y);
    float distanceToMove = sqrtf(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y);
    float moveDuration = distanceToMove / bearVelocity;
    if (moveDifference.x < 0) {
        multiplierForDirection = 1;
    } else {
        multiplierForDirection = -1;
    }
    _bear.xScale = fabs(_bear.xScale) * multiplierForDirection;
    
    if ([_bear actionForKey:@"bearMoving"]) {
        [_bear removeActionForKey:@"bearMoving"];
    }
    
    if (![_bear actionForKey:@"walkingInPlaceBear"]) {
        [self walkingBear];
    }
    
    SKAction *moveAction = [SKAction moveTo:location duration:moveDuration];
    SKAction *doneAction = [SKAction runBlock:(dispatch_block_t)^() {
        [self bearMoveEnded];
    }];
    
    SKAction *moveActionWithDone = [SKAction sequence:@[moveAction,doneAction]];
    
    [_bear runAction:moveActionWithDone withKey:@"bearMoving"];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) bearMoveEnded
{
    [_bear removeAllActions];
}
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
