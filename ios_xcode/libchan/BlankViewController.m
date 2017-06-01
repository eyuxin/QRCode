//
//  BlankViewController.m
//  ioschan
//
//  Created by 李经国 on 2016/10/20.
//  Copyright © 2016年 Shanghai Mew Intelligence Tech. Com., Ltd. All rights reserved.
//
#import <CoreImage/CoreImage.h>
#import "BlankViewController.h"

@interface BlankViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)UIViewController *imagePickerController;

@end

@implementation BlankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePickerController.delegate = self;
    [self displayContentController:imagePickerController];
    self.imagePickerController = imagePickerController;
    // Do any additional setup after loading the view.
    
    
}
- (void)testBtn:(UIViewController*) content {
    [self displayContentController:self.imagePickerController];
    NSLog(@"111");
}

- (void) displayContentController: (UIViewController*) content {
    [self addChildViewController:content];
    content.view.frame = self.view.frame ;
    [self.view addSubview: content.view];
    [content didMoveToParentViewController:self];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:true completion:nil];
    CIDetector* det = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    UIImage* img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    CIImage* ciImg = [[CIImage alloc]initWithImage:img];
    NSArray* features = [det featuresInImage:ciImg];
    NSObject* first = features.firstObject;
    if (first){
        CIQRCodeFeature* fet = (CIQRCodeFeature *)first;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self executeMewchanCommand: @{
                                           @"command": @"response",
                                           @"value": fet.messageString
                                           }];
        });
    }
}

@end
