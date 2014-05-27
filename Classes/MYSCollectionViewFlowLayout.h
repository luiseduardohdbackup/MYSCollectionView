//
//  MYSCollectionViewFlowLayout.h
//  MYSForms
//
//  Created by Adam Kirk on 5/19/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//



@interface MYSCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@property (nonatomic, assign) CGFloat latestDelta;

@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;

@property (nonatomic, assign) BOOL isDynamicsEnabled;

- (void)reset;

#pragma mark - Override

- (void)addedItemNeedsBehavior:(UICollectionViewLayoutAttributes *)item;

- (void)didBeginUpdates;

- (void)didFinishUpdates;

@end
