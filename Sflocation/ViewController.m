//
//  ViewController.m
//  Sflocation
//
//  Created by JQT-MACMini on 15/4/8.
//  Copyright (c) 2015年 Tianjin JQT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
NSString *nowLongitude=@"";
NSString *nowLatitude=@"";
NSTimer *timer;
BMKPointAnnotation* annotation;
bool state=TRUE;
-(CLLocationManager *)locMgr
{
    if (_locMgr==nil) {
        //1.创建位置管理器（定位用户的位置）
        self.locMgr=[[CLLocationManager alloc]init];
        //2.设置代理
        self.locMgr.delegate=self;
    }
    return _locMgr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _username_tf.delegate=self;
    _password_tf.delegate=self;
    NSString *value=[self getCache:1 andID:1];
    annotation=[[BMKPointAnnotation alloc]init];
//    [pausesLocationUpdatesAutomatically NO];
    if (value) {
        _username_tf.text=value;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    __mapView.zoomLevel=17;
    
    //_locService = [[BMKLocationService alloc]init];
    //适配ios7
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
//    {
//        self.navigationController.navigationBar.translucent = NO;
//    }
    /*百度地图方法
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    
    __mapView.showsUserLocation = NO;//先关闭显示的定位图层
//    __mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    __mapView.userTrackingMode = BMKUserTrackingModeFollow;
    __mapView.showsUserLocation = YES;//显示定位图层
    NSNotificationCenter *nc2 = [NSNotificationCenter defaultCenter]; // 成为听众一旦有广播就来调用self recvBcast:函数
    [nc2 addObserver:self selector:@selector(activeLocation:) name:@"LocationTheme" object:nil];
    */
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        
        //每隔多少米定位一次（这里的设置为任何的移动）
        self.locMgr.distanceFilter=kCLDistanceFilterNone;
        //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
        self.locMgr.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
        self.locMgr.pausesLocationUpdatesAutomatically=NO;
        [self.locMgr requestAlwaysAuthorization];
        //开始定位用户的位置
        [self.locMgr startUpdatingLocation];
    }else{
        NSLog(@"location failed");
        //不能定位用户的位置
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
    }
}

#pragma mark-CLLocationManagerDelegate
/**
 *  当定位到用户的位置时，就会调用（调用的频率比较频繁）
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    [__mapView   removeAnnotation:annotation];
    CLLocation *loc = [locations firstObject];
    CLLocationCoordinate2D mylocation = loc.coordinate;//手机GPS
    //mylocation=[self hhTrans_bdGPS:mylocation];
    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(mylocation,BMK_COORDTYPE_COMMON);
    //转换GPS坐标至百度坐标
    testdic = BMKConvertBaiduCoorFrom(mylocation,BMK_COORDTYPE_GPS);
    mylocation=BMKCoorDictionaryDecode(testdic);
    //维度：loc.coordinate.latitude
    //经度：loc.coordinate.longitude
    __mapView.centerCoordinate=mylocation;
    annotation.coordinate = mylocation;
    annotation.title = @"员工位置";
    [__mapView   addAnnotation:annotation];
    NSLog(@"纬度=%f，经度=%f",mylocation.latitude,mylocation.longitude);
    NSLog(@"%lu",(unsigned long)locations.count);
    nowLatitude = [NSString stringWithFormat:@"%f", mylocation.latitude];
    nowLongitude = [NSString stringWithFormat:@"%f", mylocation.longitude];
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    //    [self.locMgr stopUpdatingLocation];
    
}
/**
 *  当定位失败时，就会调用
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error

{
    
    NSLog(@"error: %@",error);
    
}

- (void) activeLocation:(NSNotification *)notify {
    [_locService stopUserLocationService];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [__mapView viewWillAppear];
    __mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [__mapView viewWillDisappear];
    __mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
- (void)dealloc {
    if (__mapView) {
        __mapView = nil;
    }
}

- (IBAction)gensuistart:(id)sender {
    NSLog(@"进入跟随态");
    
    //[timer fire];
    
//    if (state) {
//        [_state_btn setTitle:@"停止" forState:UIControlStateSelected];
//        [timer fire];
//        state=FALSE;
//    }else{
//        [_state_btn setTitle:@"启动" forState:UIControlStateNormal];
//        [timer invalidate];
//        state=true;
//    }
}
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [__mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [__mapView updateLocationData:userLocation];
    nowLatitude = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
    nowLongitude = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
    NSLog(@"locate success");
//    [_locService stopUserLocationService];
    
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}
#pragma mark hidekeyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _password_tf) { // _textField_QQ和_textField_password已被设为属性,判断键盘的第一响应者,如果是QQ输入框
        
        return [_username_tf becomeFirstResponder]; //点击右下角的Next按钮,则将键盘第一响应者设为_textField_password,即密码输入框
        
    }else{
        NSString *str=[NSString stringWithFormat:@"http://ceshi.com/denglu.do?%@%@&%@%@&%@%@",@"checkusername=",_username_tf.text,@"m_username=",_test_tf.text,@"m_password=",_password_tf.text];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //去除两边的空格和回车
            NSString *html = [operation.responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
            NSRange range = [html rangeOfString:@"shifangdingwei"];//判断字符串是否包含
            if(range.length>0){
                NSLog(@"true");
                [self saveCache:1 andID:1 andString:_username_tf.text];
                _password_tf.text=@"";
            }
            else{
                NSLog(@"false");
            }
            NSLog(@"获取到的管理员数据为：%@",html);
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发生错误！%@",error);
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
        return [_username_tf resignFirstResponder]; //否则(键盘第一响应者为密码输入框),则使键盘失去第一响应者,即消失
        
    }
    
}
/**
 *在点击输入框所在的view的时候收起键盘
 *@param event 点击事件
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_username_tf isExclusiveTouch]) {
        [_username_tf resignFirstResponder];
    }
    if (![_password_tf isExclusiveTouch]) {
        [_password_tf resignFirstResponder];
    }
}
#pragma mark 底图手势操作
/**
 *点中底图标注后会回调此接口
 *@param mapview 地图View
 *@param mapPoi 标注点信息
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
    [_username_tf resignFirstResponder];
    NSLog(@"onClickedMapPoi-%@",mapPoi.text);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了底图标注:%@,\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", mapPoi.text,mapPoi.pt.longitude,mapPoi.pt.latitude, (int)__mapView.zoomLevel,__mapView.rotation,__mapView.overlooking];
    //_test_tf.text = showmeg;
}
/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    [_username_tf resignFirstResponder];
    NSLog(@"onClickedMapBlank-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了地图空白处(blank click).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)__mapView.zoomLevel,__mapView.rotation,__mapView.overlooking];
    //_test_tf.text = showmeg;
}
/**
 *双击地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回双击处坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate
{
    [_username_tf resignFirstResponder];
    NSLog(@"onDoubleClick-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    NSString* showmeg = [NSString stringWithFormat:@"您双击了地图(double click).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)__mapView.zoomLevel,__mapView.rotation,__mapView.overlooking];
    //_test_tf.text = showmeg;
}

/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"onLongClick-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    NSString* showmeg = [NSString stringWithFormat:@"您长按了地图(long pressed).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)__mapView.zoomLevel,__mapView.rotation,__mapView.overlooking];
    //_test_tf.text = showmeg;
    
}

- (IBAction)getNumber:(id)sender {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [timer fire];
}

- (IBAction)saveUserName:(id)sender {
    NSString *str=[NSString stringWithFormat:@"http://ceshi.com/denglu.do?%@%@&%@%@&%@%@",@"checkusername=",_username_tf.text,@"m_username=",_test_tf.text,@"m_password=",_password_tf.text];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //去除两边的空格和回车
        NSString *html = [operation.responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
         NSRange range = [html rangeOfString:@"shifangdingwei"];//判断字符串是否包含
        if(range.length>0){
            NSLog(@"true");
            [self saveCache:1 andID:1 andString:_username_tf.text];
            _username_tf.text=@"";
            _password_tf.text=@"";
        }
        else{
            NSLog(@"false");
        }
        NSLog(@"获取到的管理员数据为：%@",html);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}
#pragma mark 定时发送位置
- (void)timerFired{
//    _locService=nil;
//    _locService = [[BMKLocationService alloc]init];
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    
    __mapView.zoomLevel=17;
    __mapView.showsUserLocation = NO;//先关闭显示的定位图层
    //    __mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    __mapView.userTrackingMode = BMKUserTrackingModeFollow;
    __mapView.showsUserLocation = YES;//显示定位图层
    NSLog(@"ssss");
    NSString *value=[self getCache:1 andID:1];
    if (value) {
        //NSLog(value);
        
//        NSString *str=[NSString stringWithFormat:@"http://192.168.1.62:8080/jofficev3/system/mobileSaveUserPoint.do?%@%@&%@%@&%@%@",@"m_username=",value,@"xpoint=",nowLatitude,@"ypoint=",nowLongitude];
        NSString *str=[NSString stringWithFormat:@"http://ceshi.com/savepoint.do?%@%@&%@%@&%@%@",@"m_username=",value,@"xpoint=",nowLatitude,@"ypoint=",nowLongitude];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            //        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            NSLog(@"获取到的定位数据为：%@",html);
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发生错误！%@",error);
            
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
        
    }else{
        NSLog(@"请先设置定位用户！");
    }
    
}
#pragma mark 缓存数据
- (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str;
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    [setting setObject:str forKey:key];
    [setting synchronize];
}
- (NSString *)getCache:(int)type andID:(int)_id
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    
    NSString *value = [settings objectForKey:key];
    return value;
}

@end
