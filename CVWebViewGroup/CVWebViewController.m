//
//  CVWebViewController.m
//  CVWebView
//
//  Created by 范玉杰 on 2017/3/31.
//  Copyright © 2017年 范玉杰. All rights reserved.
//

#import "CVWebViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "NSString+Other.h"
@interface CVWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView * webView; /// web view

@property (nonatomic,strong) NSMutableArray * urlArray; //链接数组
@property (nonatomic,strong) NSMutableString * currentUrl; //当前的链接

// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;  /// 进度条

@property (nonatomic, strong) NSTimer *fakeProgressTimer;  /// 时间戳
@property (nonatomic, assign) BOOL uiWebViewIsLoading; /// 是否加载
@property (nonatomic, strong) NSURL *uiWebViewCurrentURL;  /// 当前URL
@property (nonatomic, copy) NSString *dealStr;  /// 截取的数据

@property (nonatomic,assign)  BOOL  isSettingColor;

@end

@implementation CVWebViewController

#pragma mark - LIFE CYCLE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = UIColor.whiteColor;
    
    _urlArray = @[].mutableCopy;
    _currentUrl = @"".mutableCopy;
    
}

#pragma mark - GET && SET

-(void)setTitleName:(NSString *)titleName{
    _titleName = titleName;
    self.title = _titleName;
}
-(void)setWebViewString:(NSString *)webViewString{
    _webViewString = webViewString;
    
    [self loadBodyView];
    /// 加载 webview
}
-(void)setProgressColor:(UIColor *)progressColor{
    self.isSettingColor = YES;
    _progressColor = progressColor;
    [self.progressView setTintColor:_progressColor];
}
-(void)cVWebViewDealMethodWithLink:(NSString *)linkUrl block:(void (^)())block{
//    !block ?: block();
    
    _dealStr = linkUrl;
    self.dealBlock = block;
}

#pragma mark - LOAD VIEW

-(void)loadBodyView{
    
    /// 初始化 webview
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
    
    
    /// 初始化进度条
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    [self.progressView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.progressView.frame.size.height)];
    
    
    //设置进度条颜色
    
    [self.progressView setTintColor:self.progressColor ? self.progressColor : [UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000]];
    [self.view addSubview:self.progressView];
    
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewString]]];
}

#pragma mark - WEB VIEW DELEGATE

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (isStringEmpty(self.dealStr)) {
        NSString * str = [request.URL absoluteString];
        _currentUrl = [NSMutableString stringWithFormat:@"%@",str];
        
        //进度条
        self.uiWebViewCurrentURL = request.URL;
        self.uiWebViewIsLoading = YES;
        
        [self fakeProgressViewStartLoading];
        
        return YES;
    }
    else{
        if ([[request.URL absoluteString] containsString:self.dealStr]){
            /// 需要截取的逻辑代码
            self.dealBlock();
            return NO;
        }else{
            NSString * str = [request.URL absoluteString];
            _currentUrl = [NSMutableString stringWithFormat:@"%@",str];
            
            //进度条
            self.uiWebViewCurrentURL = request.URL;
            self.uiWebViewIsLoading = YES;
            
            [self fakeProgressViewStartLoading];
            
            return YES;
        }
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(!self.webView.isLoading){
        self.uiWebViewIsLoading = NO;
        [self fakeProgressBarStopLoading];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(!self.webView.isLoading){
        self.uiWebViewIsLoading = NO;
        [self fakeProgressBarStopLoading];
    }
}

#pragma mark - Fake Progress Bar Control (UIWebView)
- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.fakeProgressTimer) {
        self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    }
}

- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self.webView isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}

#pragma mark - 返回按钮时间处理

-(BOOL)navigationShouldPopOnBackButton{
    if ([_currentUrl isEqualToString:_webViewString] || ([_currentUrl hasSuffix:@"/"] && _currentUrl.length - _webViewString.length == 1)){
        [self.navigationController popViewControllerAnimated:YES];
        return YES;
    }
    else{
        [self.webView goBack];
        return NO;
    }
}
@end
