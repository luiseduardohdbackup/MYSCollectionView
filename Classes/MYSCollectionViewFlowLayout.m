//
//  MYSCollectionViewFlowLayout.m
//  MYSForms
//
//  Created by Adam Kirk on 5/19/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSCollectionViewFlowLayout.h"


@implementation MYSCollectionViewFlowLayout

- (void)commonInit
{
    self.minimumInteritemSpacing    = 0;
    self.minimumLineSpacing         = 5;
    self.visibleIndexPathsSet       = [NSMutableSet new];
    self.dynamicAnimator            = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.isDynamicsEnabled          = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];

    // Need to overflow our actual visible rect slightly to avoid flickering.
    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size},
                                     -100,
                                     -100);

    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];

    // update dynamic animator items and behaviors on insert/delete
    if (!self.isDynamicsEnabled) {
        [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
            UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
            for (UICollectionViewLayoutAttributes *attributes in itemsInVisibleRectArray) {
                if ([attributes.indexPath isEqual:item.indexPath]) {
                    if ([itemsInVisibleRectArray count] != [self.dynamicAnimator.behaviors count] ||
                        item.frame.size.width != self.collectionView.bounds.size.width) {
                        item.frame = attributes.frame;
                        [self.dynamicAnimator updateItemUsingCurrentState:item];
                    }
                    springBehaviour.anchorPoint = attributes.center;
                }
            }
        }];
    }

    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];

    // Step 1: Remove any behaviours that are no longer visible.
    NSArray *noLongerVisibleBehaviours = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[[[behaviour items] firstObject] indexPath]] != nil;
        return !currentlyVisible;
    }]];

    [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [self.dynamicAnimator removeBehavior:obj];
        [self.visibleIndexPathsSet removeObject:[[[obj items] firstObject] indexPath]];
    }];

    // Step 2: Add any newly visible behaviours.
    // A "newly visible" item is one that is in the itemsInVisibleRect(Set|Array) but not in the visibleIndexPathsSet
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        BOOL currentlyVisible = [self.visibleIndexPathsSet member:item.indexPath] != nil;
        return !currentlyVisible;
    }]];


    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        [self addedItemNeedsBehavior:item];
    }];

}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (self.isDynamicsEnabled) {
        return [self.dynamicAnimator itemsInRect:rect];
    }
    else {
        return [super layoutAttributesForElementsInRect:rect];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isDynamicsEnabled) {
        return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    }
    else {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
}

- (void)reset
{
    [self.dynamicAnimator removeAllBehaviors];
    [self.visibleIndexPathsSet removeAllObjects];
}




#pragma mark - Override

- (void)addedItemNeedsBehavior:(UICollectionViewLayoutAttributes *)item
{

}

- (void)didBeginUpdates
{
    self.isDynamicsEnabled = NO;
}

- (void)didFinishUpdates
{
    self.isDynamicsEnabled = YES;
}

@end
