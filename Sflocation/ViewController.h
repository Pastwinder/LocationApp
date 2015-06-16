//
//  ViewController.h
//  Sflocation
//
//  Created by JQT-MACMini on 15/4/8.
//  Copyright (c) 2015年 Tianjin JQT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "AFNetWorking.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate>{
    BMKLocationService* _locService;
}
@property(nonatomic,strong)CLLocationManager *locMgr;
@property (weak, nonatomic) IBOutlet BMKMapView* _mapView;
- (IBAction)gensuistart:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *test_tf;
- (IBAction)getNumber:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *password_tf;
@property (weak, nonatomic) IBOutlet UITextField *username_tf;
- (IBAction)saveUserName:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *state_btn;


@end

