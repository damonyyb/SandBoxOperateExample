//
//  ViewController.m
//  SandBoxOperateExample
//
//  Created by yyb on 16/5/19.
//  Copyright © 2016年 yyb. All rights reserved.
//

#import "ViewController.h"
#import "SandBoxOperate.h"

#define LINZHILIN @"linzhilin"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong,nonatomic) SandBoxOperate *sandBoxOperate;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@end

@implementation ViewController
- (IBAction)savePhoto {
    self.sandBoxOperate =[SandBoxOperate createCachesPathWithType:PhotoType Folder:@"MyPhotos"];
    UIImage *image =[UIImage imageNamed:@"2"];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    __block typeof (self) weakSelf = self;
    
    [self.sandBoxOperate  addFileToCachesPath:data andName:LINZHILIN andResultBlock:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"保存图片成功");
            weakSelf.successLabel.hidden = NO;
            weakSelf.successLabel.text = @"保存图片成功";
        }else{
            NSLog(@"%@",error);
            weakSelf.successLabel.hidden = NO;
            weakSelf.successLabel.text = [NSString stringWithFormat:@"%@",error.domain];
        }
    }];
    
    
}
- (IBAction)readPhoto:(id)sender {
    if (self.sandBoxOperate) {
      NSData *data=  [self.sandBoxOperate readFileFromCachesPath:LINZHILIN];
        UIImage *image =[UIImage imageWithData:data];
        if (image) {
            [self.imgView setImage:image];
        }else{
            self.successLabel.hidden = NO;
            self.successLabel.text = @"没有对应文件";
        }
    }
    
}

- (IBAction)calauateFoladerSize {
    long long  KB =  [self.sandBoxOperate cachesSize];
    double  Mb  = KB / (1024.0*1024.0);
    NSLog(@"%g",Mb);
    self.successLabel.hidden = NO;
    self.successLabel.text = [NSString stringWithFormat:@"大小为%gMB",Mb];
    
}

- (IBAction)cleanCaches {
    __block typeof (self) weakSelf = self;
    [self.sandBoxOperate clearCaches:^(BOOL success, NSError *error, long long cachesSize) {
        if (success) {
            long long  KB =  cachesSize;
            double  Mb  = KB / (1024.0*1024.0);
            NSLog(@"%g",Mb);
            weakSelf.successLabel.hidden = NO;
            weakSelf.successLabel.text = [NSString stringWithFormat:@"已清理%gMB缓存",Mb];
            self.imgView.image = nil;
            
        }else{
            NSLog(@"%@",error);
            weakSelf.successLabel.hidden = NO;
            weakSelf.successLabel.text = [NSString stringWithFormat:@"%@",error.domain];
        }
    }];
    
}
@end
