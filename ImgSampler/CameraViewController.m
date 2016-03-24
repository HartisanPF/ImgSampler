//
//  CameraViewController.m
//  ImgSampler
//
//  Created by Hartisan on 15/10/2.
//  Copyright © 2015年 Hartisan. All rights reserved.
//

#import "CameraViewController.h"

@implementation CameraViewController

@synthesize _imgView, _videoCamera, _btnCamera, _cameraOn, _btnCapture, _captureOn, _motionManager, _labelXTheta, _labelYTheta, _labelZTheta;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化摄像头
    CvVideoCamera* camera = [[CvVideoCamera alloc] initWithParentView:_imgView];
    self._videoCamera = camera;
    self._videoCamera.delegate = self;
    self._videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self._videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    self._videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    self._videoCamera.defaultFPS = 30;
    
    // 初始化状态
    self._cameraOn = false;
    self._captureOn = false;
    
    // CoreMotion
    self._motionManager = [[CMMotionManager alloc] init];
}


// 对每一帧图像进行处理
- (void) processImage:(cv::Mat &)image {
    
    if (!image.empty()) {
        
        if (self._captureOn) {
            
            // 先把图像保存到相册
            cv::Mat rgb;
            cv::cvtColor(image, rgb, CV_BGR2RGB);
            UIImage* img = MatToUIImage(rgb);
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
            
            // 获取手机的重力值在各个方向上的分量并计算夹角
            double gravityX = _motionManager.deviceMotion.gravity.x;
            double gravityY = _motionManager.deviceMotion.gravity.y;
            double gravityZ = _motionManager.deviceMotion.gravity.z;
            double xTheta = acos(-gravityY) / M_PI * 180.0;
            double yTheta = acos(gravityX) / M_PI * 180.0;
            double zTheta = acos(-gravityZ) / M_PI * 180.0;
            //NSLog(@"%f, %f, %f", xTheta, yTheta, zTheta);
            NSString* strX = [NSString stringWithFormat:@"%f", xTheta];
            NSString* strY = [NSString stringWithFormat:@"%f", yTheta];
            NSString* strZ = [NSString stringWithFormat:@"%f", zTheta];
            
            // 在主线程更新UI，可能跟ios9有关
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self._labelXTheta.text = strX;
                self._labelYTheta.text = strY;
                self._labelZTheta.text = strZ;
            });
            
            self._captureOn = false;
        }
    }
}


-(IBAction) btnCameraPressed:(id)sender {
    
    if (self._cameraOn) {
        
        [self._videoCamera stop];
        [self._btnCamera setTitle:@"Camera On" forState:UIControlStateNormal];
        [_motionManager stopDeviceMotionUpdates];
        
        self._cameraOn = false;
        
    } else {
        
        // 打开重力加速计
        _motionManager.accelerometerUpdateInterval = 0.01; // 更新频率是100Hz
        [_motionManager startDeviceMotionUpdates];
        
        [self._videoCamera start];
        [self._btnCamera setTitle:@"Camera Off" forState:UIControlStateNormal];
        
        self._cameraOn = true;
    }
}


-(IBAction) btnCapturePressed:(id)sender {
    
    self._captureOn = true;
}

@end
