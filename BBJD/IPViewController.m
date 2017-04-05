//
//  IPViewController.m
//  BBJD
//
//  Created by cbwl on 17/2/13.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "IPViewController.h"
#import "RootViewController.h"
@interface IPViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textIP;

@end

@implementation IPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _textIP.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"ip"];
    ;
}
- (IBAction)goNext:(id)sender {
    if (_textIP.text>0) {
        
        [[NSUserDefaults standardUserDefaults]setObject:_textIP.text forKey:@"ip"];

        RootViewController *root=[[RootViewController alloc]init];
        UIWindow  * window=  [[UIApplication sharedApplication].delegate window] ;
        window.rootViewController=root;

        [ window makeKeyAndVisible];

    }
}
- (IBAction)SelectBtn:(UIButton *)sender {
    if (sender.tag==10){//阿里云测试
        [[NSUserDefaults standardUserDefaults]setObject:@"121.41.114.230:8082" forKey:@"ip"];

    }
    else if (sender.tag==11){//本地测试
        [[NSUserDefaults standardUserDefaults]setObject:@"192.168.11.142:8082" forKey:@"ip"];

    }
    else if  (sender.tag==12){//线上生产
        [[NSUserDefaults standardUserDefaults]setObject:@"121.40.86.46:8082" forKey:@"ip"];

    }
    
    RootViewController *root=[[RootViewController alloc]init];
    UIWindow  * window=  [[UIApplication sharedApplication].delegate window] ;
    window.rootViewController=root;
    
    [ window makeKeyAndVisible];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
