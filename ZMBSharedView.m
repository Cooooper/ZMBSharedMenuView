//
//  ZMBSharedView.m
//  ZhongMeBan
//
//  Created by Han Yahui on 16/3/9.
//  Copyright © 2016年 Han Yahui. All rights reserved.
//

#import "ZMBSharedView.h"

#define kBGColor  kRGBAColor(160, 160, 160, 0)

@interface ZMBSharedView ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSArray *items;

@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIView *backgroundView;

@end

@implementation ZMBSharedView


-(instancetype)initWithSharedItems:(NSArray *)items
{
  self = [super init];
  if (self) {
    
    self.items = items;
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = kBGColor;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(hiddenView)];
    [self addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;

    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 180)];
    self.backgroundView.backgroundColor = kBackgroundColor;
    [self addSubview:self.backgroundView];
    
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:kWhiteColor];
    [self.cancelButton addTarget:self action:@selector(hiddenView)];
    [self.backgroundView addSubview:self.cancelButton];
    
    [self.cancelButton addBorderWithColor:kSeparatorColor width:0.5];
    
    ZMBSharedItem *lastItem = nil;
    
    for (ZMBSharedItem *item in items) {
      
      if (item.image) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapOnItem:)];
        [item addGestureRecognizer:tap];
      }
      
      [self.backgroundView addSubview:item];
      
      [item remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView);
        make.bottom.equalTo(self.cancelButton.top);
        if (lastItem) {
          
          make.left.equalTo(lastItem.right);
          make.width.equalTo(lastItem);
          
        }
        else {
          make.left.equalTo(0);
        }
      }];
      
      lastItem = item;
    }
    
    ZMBSharedItem *firstItem = [items firstObject];
    
    [firstItem makeConstraints:^(MASConstraintMaker *make) {
      make.width.equalTo(lastItem);
    }];
    
    [lastItem makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.backgroundView);
    }];

    [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
      
      make.left.right.bottom.equalTo(self.backgroundView);
      make.height.equalTo(50);
    }];
    
  }
  
  return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  if([touch.view isKindOfClass:[self class]]){
    return YES;
  }
  return NO;
}

- (void)hiddenView
{
  [UIView animateWithDuration:0.3 animations:^{
    self.backgroundView.y = kScreenHeight;
    self.alpha = 0;
  } completion:^(BOOL finished) {
    if (finished) {
      [self removeFromSuperview];
    }
  }];
  
  if ([self.delegate respondsToSelector:@selector(sharedViewDidCancel:)]) {
    [self.delegate sharedViewDidCancel:self];
  }
  
}

- (void)showInView:(UIViewController *)viewController
{
  if(viewController==nil){
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
  }else{
    [viewController.view addSubview:self];
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    self.backgroundColor = [kBGColor colorWithAlphaComponent:0.4];
    self.backgroundView.y = kScreenHeight - self.backgroundView.frame.size.height;
  }];
}

- (void)tapOnItem:(UITapGestureRecognizer *)tapGestureRecognizer
{
  ZMBSharedItem *item = (ZMBSharedItem *)tapGestureRecognizer.view;
  NSInteger index = [self.items indexOfObject:item];
  
  if ([self.delegate respondsToSelector:@selector(sharedView:didClickItemIndex:)]) {
    [self.delegate sharedView:self didClickItemIndex:index];
  }
  [self hiddenView];
}

@end

@interface ZMBSharedItem ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel     *titleLabel;

@end

@implementation ZMBSharedItem

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    self.titleColor = [UIColor blackColor];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = self.titleColor;
    self.titleLabel.font = kFont(14);
    [self addSubview:self.titleLabel];
    
    [self.imageView remakeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self);
      make.top.equalTo(self).offset(kPaddingHorizontal * 2);
      make.size.equalTo(CGSizeMake(50, 50));
      
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.imageView);
      make.top.equalTo(self.imageView.bottom).offset(kPaddingHorizontal/2);
      make.width.equalTo(self);
      make.height.equalTo(25);
    }];
    
  }
  return self;
}

- (void)setTitle:(NSString *)title
{
  _title = title;
  self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor
{
  _titleColor = titleColor;
  self.titleLabel.textColor = titleColor;
}

- (void)setImage:(UIImage *)image
{
  _image = image;
  self.imageView.image = image;
}


@end


