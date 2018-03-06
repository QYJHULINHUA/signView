//
//  ViewController.m
//  ElectronicSignature
//
//  Created by 李志华 on 2017/4/1.
//  Copyright © 2017年 李志华. All rights reserved.
//

#import "ViewController.h"
#import "SignView.h"

@interface ViewController ()
{
    SignView *signView;
}
@property (nonatomic, nonatomic)  UIImageView *signImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    signView = [[SignView alloc] initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width-20, 200)];
    signView.signPlaceHoalder = @"手写签名";
    //    signView.signViewColor = [UIColor colorWithRed:23/255.f green:56/255.f blue:76/255.f alpha:1];
    [self.view addSubview:signView];
    
    UIButton *CreenDone = [UIButton buttonWithType:UIButtonTypeCustom];
    CreenDone.frame = CGRectMake(70, 300, 100, 50);
    CreenDone.layer.borderColor = [UIColor redColor].CGColor;
    CreenDone.layer.borderWidth = 1.0;
    [CreenDone setTitle:@"清除" forState:UIControlStateNormal];
    [CreenDone setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [CreenDone addTarget:self action:@selector(createaction) forControlEvents:UIControlEventTouchUpInside];
    CreenDone.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:CreenDone];
    
    
    UIButton *signDone = [UIButton buttonWithType:UIButtonTypeCustom];
    signDone.frame = CGRectMake(200, 300, 100, 50);
    signDone.layer.borderColor = [UIColor redColor].CGColor;
    signDone.layer.borderWidth = 1.0;
    [signDone setTitle:@"完成" forState:UIControlStateNormal];
    [signDone setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [signDone addTarget:self action:@selector(signDoneAction:) forControlEvents:UIControlEventTouchUpInside];
    signDone.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:signDone];
    
    UIImageView *signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 400, 100, 45)];
    signImageView.layer.borderColor = [UIColor redColor].CGColor;
    signImageView.layer.borderWidth = 1.0;
    [self.view addSubview:signImageView];
    
    [signView signResultWithBlock:^(UIImage *signImage) {
        signImageView.image = signImage;
    }];
    
}


- (void)signDoneAction:(UIButton *)btn{
    [signView signDone];
}

- (void)createaction{
    [signView clearSignAction];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
