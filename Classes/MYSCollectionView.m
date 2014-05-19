//
//  MYSCollectionView.m
//  MYSForms
//
//  Created by Adam Kirk on 5/19/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSCollectionView.h"
#import "MYSCollectionViewFlowLayout.h"


@interface MYSCollectionView ()
@property (nonatomic, assign) BOOL isInBatchUpdatesBlock;
@end


@implementation MYSCollectionView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _isInBatchUpdatesBlock = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isInBatchUpdatesBlock = NO;
    }
    return self;
}

- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion
{
    [self updatesWillBegin];
    self.isInBatchUpdatesBlock = YES;
    [super performBatchUpdates:updates completion:^(BOOL finished) {
        self.isInBatchUpdatesBlock = NO;
        if (completion) completion(finished);
        [self updatesDidFinish];
    }];
}

- (void)insertSections:(NSIndexSet *)sections
{
    if (self.isInBatchUpdatesBlock) {
        [super insertSections:sections];
    }
    else {
        [self performBatchUpdates:^{
            [super insertSections:sections];
        } completion:nil];
    }
}

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths
{
    if (self.isInBatchUpdatesBlock) {
        [super insertItemsAtIndexPaths:indexPaths];
    }
    else {
        [self performBatchUpdates:^{
            [super insertItemsAtIndexPaths:indexPaths];
        } completion:nil];
    }
}

- (void)deleteSections:(NSIndexSet *)sections
{
    if (self.isInBatchUpdatesBlock) {
        [super deleteSections:sections];
    }
    else {
        [self performBatchUpdates:^{
            [super deleteSections:sections];
        } completion:nil];
    }
}
- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths
{
    if (self.isInBatchUpdatesBlock) {
        [super deleteItemsAtIndexPaths:indexPaths];
    }
    else {
        [self performBatchUpdates:^{
            [super deleteItemsAtIndexPaths:indexPaths];
        } completion:nil];
    }
}




#pragma mark - Private

- (void)updatesWillBegin
{
    if ([self.collectionViewLayout respondsToSelector:@selector(didBeginUpdates)]) {
        [(MYSCollectionViewFlowLayout *)self.collectionViewLayout didBeginUpdates];
    }
}

- (void)updatesDidFinish
{
    if ([self.collectionViewLayout respondsToSelector:@selector(didFinishUpdates)]) {
        [(MYSCollectionViewFlowLayout *)self.collectionViewLayout didFinishUpdates];
    }
}

@end
