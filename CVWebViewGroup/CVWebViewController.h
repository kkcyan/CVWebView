//
//  CVWebViewController.h
//  CVWebView
//
//  Created by 范玉杰 on 2017/3/31.
//  Copyright © 2017年 范玉杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DealBlock)();

/// 代理
@protocol CVWebViewDelegate <NSObject>
@optional;
-(void)uWantToDealWithMethod;
@end

@interface CVWebViewController : UIViewController

/// 点击处理的时间 block
@property(nonatomic,copy) DealBlock dealBlock;

/// 要展示的链接
@property(nonatomic,strong) NSString * webViewString;

/// 要展示的标题
@property (nonatomic,strong) NSString  * titleName;

/// 进度条颜色  默认为蓝色
@property (nonatomic,strong) UIColor * progressColor;

/**
 截取某个链接   若linkUrl有值，请保证block里面有需要处理的内容

 @param linkUrl 链接
 @param block 回调 处理事件
 */
-(void)cVWebViewDealMethodWithLink:(NSString *)linkUrl block:(void(^)())block;
@end
