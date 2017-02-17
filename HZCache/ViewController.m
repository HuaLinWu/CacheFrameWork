//
//  ViewController.m
//  HZCache
//
//  Created by Steven on 17/2/9.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "ViewController.h"
#import "HZDiskCache.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tagertImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark archiver imag button
- (IBAction)archiverButtonClick:(id)sender {
    HZDiskCache *diskCache = [[HZDiskCache alloc] init];
    UIImage *image = [UIImage imageNamed:@"04.jpg"];
    [diskCache setObject:image forKey:@"image04"];
    
    
}
#pragma mark unArchiver image button
- (IBAction)unArchiverButtonClick:(id)sender {
    HZDiskCache *diskCache = [[HZDiskCache alloc] init];
    UIImage *image = (UIImage *)[diskCache objectForKey:@"image04"];
    self.tagertImageView.image = image;
}
@end
