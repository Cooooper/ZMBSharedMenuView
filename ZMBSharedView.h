//
//  ZMBSharedView.h
//  ZhongMeBan
//
//  Created by Han Yahui on 16/3/9.
//  Copyright © 2016年 Han Yahui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZMBSharedView;

@protocol ZMBSharedViewDelegate <NSObject>

- (void)sharedView:(ZMBSharedView *)sharedView didClickItemIndex:(NSInteger )index;

- (void)sharedViewDidCancel:(ZMBSharedView *)sharedView;

@end

@interface ZMBSharedView : UIView

- (instancetype)initWithSharedItems:(NSArray *)items;

@property (nonatomic,strong) NSArray *sharedItems;

@property (nonatomic,weak) id<ZMBSharedViewDelegate> delegate;

- (void)showInView:(UIViewController *)viewController;


@end

@interface ZMBSharedItem : UIView

@property (nonatomic,copy)   NSString *title;
@property (nonatomic,strong) UIColor  *titleColor;

@property (nonatomic,strong) UIImage *image;


@end
