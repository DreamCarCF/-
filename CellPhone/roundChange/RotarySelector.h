//
//  RotarySelector.h
//  RotarySeletor
//
//  Created by Yasir Lee on 13-4-2.
//  Copyright (c) 2013年 Xiaohui Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RotaryDelegate <NSObject>

@required

-(int)rotarySelectorCircleCount; //number of circle

-(UIImage *)rotarySelectorBackgroundImage; //rotarySelector's background image

-(UIImage *)rotarySelectorCircleImageAtIndx:(int)indx; //circle in indx's image

-(void)rotarySelectorDidChangeToIndx:(int)indx; //the rotary is rotate to indx position

-(void)rotarySelectorClickCircleAtIndx:(int)indx; //click cricle's image at indx

@optional

-(BOOL)rotarySelectorCircleHaveSameDirection; //If 'YES' rotary rotate,the circle's image alway toward top . defult 'NO'

-(UIColor *)rotarySelectorBackgroundColor; //the rotarySelector's background color defult [UIColor cleanColor]

@end

@interface RotarySelector : UIView<RotaryDelegate> {
    UIImageView     *backgroundView;
    NSMutableArray  *buttonList;
    BOOL            sameDirection;
    float           rotation;
    float           startRotation;
    float           maxSpeed;
    NSMutableArray *btntitleList;
}

- (void)addButton:(UIButton *)button;
- (void)showButtonList;
- (void)setBackgroundImage:(UIImage *)image;
- (void)roundPos;
- (void)setButtonListPosition;
-(void)reloadDataInfo;

@property(nonatomic,retain)id<RotaryDelegate>delegate;

@property (nonatomic, retain) UIImageView *backgroundView;

@end
