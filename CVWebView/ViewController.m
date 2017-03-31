//
//  ViewController.m
//  CVWebView
//
//  Created by 范玉杰 on 2017/3/31.
//  Copyright © 2017年 范玉杰. All rights reserved.
//

#import "ViewController.h"
#import "CVWebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickBtn:(UIButton *)sender {
    
    CVWebViewController * web = [CVWebViewController new];
    web.progressColor = [UIColor redColor];
    web.titleName = @"CV Web View";
    web.webViewString = @"https://www.baidu.com";
    [web cVWebViewDealMethodWithLink:@"nuomi" block:^{
        NSLog(@"处理数据");
    }];
    [self.navigationController pushViewController:web animated:YES];
    
}
@end
