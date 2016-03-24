//
//  CameraViewController.h
//  ImgSampler
//
//  Created by Hartisan on 15/10/2.
//  Copyright © 2015年 Hartisan. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgproc/types_c.h>
#import <CoreMotion/CoreMotion.h>

@interface CameraViewController : UIViewController <CvVideoCameraDelegate> {
    
    // OpenCV摄像机
    CvVideoCamera* _videoCamera;
    
    // CoreMotion
    CMMotionManager* _motionManager;
    
    // 控件
    IBOutlet UIImageView* _imgView;
    IBOutlet UIButton* _btnCamera;
    IBOutlet UIButton* _btnCapture;
    IBOutlet UILabel* _labelXTheta;
    IBOutlet UILabel* _labelYTheta;
    IBOutlet UILabel* _labelZTheta;
    
    // 状态
    bool _cameraOn;
    bool _captureOn;
}

@property (nonatomic, strong) CvVideoCamera* _videoCamera;
@property (nonatomic, strong) IBOutlet UIImageView* _imgView;
@property (nonatomic, strong) IBOutlet UIButton* _btnCamera;
@property (nonatomic, strong) IBOutlet UIButton* _btnCapture;
@property (nonatomic, strong) IBOutlet UILabel* _labelXTheta;
@property (nonatomic, strong) IBOutlet UILabel* _labelYTheta;
@property (nonatomic, strong) IBOutlet UILabel* _labelZTheta;
@property (nonatomic, strong) CMMotionManager* _motionManager;
@property bool _cameraOn;
@property bool _captureOn;

-(IBAction) btnCameraPressed:(id)sender;
-(IBAction) btnCapturePressed:(id)sender;

@end
