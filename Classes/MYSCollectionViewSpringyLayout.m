//
//  ASHSpringyCollectionViewFlowLayout.m
//  ASHSpringyCollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

/*
 
 This implementation is based on https://github.com/TeehanLax/UICollectionView-Spring-Demo
 which I developed at Teehan+Lax. Check it out.
 
 */

#import "MYSCollectionViewSpringyLayout.h"


@implementation MYSCollectionViewSpringyLayout

- (void)addedItemNeedsBehavior:(UICollectionViewLayoutAttributes *)item
{
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];

    CGPoint center = item.center;
    UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];

    springBehaviour.length      = 0.0f;
    springBehaviour.damping     = 0.9f;
    springBehaviour.frequency   = 2.0f;

    // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
    if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
        CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat scrollResistance = yDistanceFromTouch / 1500.0f;

        if (self.latestDelta < 0) {
            center.y += MAX(self.latestDelta, self.latestDelta * scrollResistance);
        }
        else {
            center.y += MIN(self.latestDelta, self.latestDelta * scrollResistance);
        }
        item.center = center;
    }

    [self.dynamicAnimator addBehavior:springBehaviour];
    [self.visibleIndexPathsSet addObject:item.indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    self.latestDelta = delta;
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat scrollResistance = yDistanceFromTouch / 1500.0f;
        
        UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
        CGPoint center = item.center;
        if (delta < 0) {
            center.y += MAX(delta, delta * scrollResistance);
        }
        else {
            center.y += MIN(delta, delta * scrollResistance);
        }
        item.center = center;

        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];

    return NO;
}

@end
