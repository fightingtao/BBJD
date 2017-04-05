//
//  BDMapVController.m
//  BBJD
//
//  Created by cbwl on 16/8/29.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "BDMapVController.h"
#import "publicResource.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件BMKMapViewDelegate
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
@interface BDMapVController ()<BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView *_mapView;
    
    BMKPoiSearch *_searcher;//搜索对象
    
    BMKPoiSearch *_poisearch;//初始化检索服务
    
    NSMutableDictionary *dataarr;
    
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geocodesearch;
 CLLocationCoordinate2D coor;
}
@end

@implementation BDMapVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
    
    self.hidesBottomBarWhenPushed=YES;
    self.tabBarController.tabBar.hidden=YES;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _mapView.delegate = nil; // 不用时，置nil
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataarr=[[NSMutableDictionary alloc]init];
    
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
    _mapView.scrollEnabled = YES;
    _mapView .zoomEnabled = YES;
    _mapView.userInteractionEnabled = YES;
//    //设定是否显示定位图层
    [_mapView setShowsUserLocation:YES];
    //打开代理
    _mapView.delegate =self;
    _mapView.mapType =BMKMapTypeStandard;
    [self.view addSubview:_mapView];
    
    //这个是卫星地图
    //[_mapView setMapType:BMKMapTypeSatellite];
    //这个是普通地图
    [_mapView setMapType:BMKMapTypeStandard];
    //这个是实时路况 yes是开启 no是关闭
    //[_mapView setTrafficEnabled:YES];
    //这个是百度城市热力图层 yes是开启 no是关闭
    //[_mapView setBaiduHeatMapEnabled:YES];
    
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
   
//    coor.latitude = 39.915;
//    coor.longitude = 116.404;
    annotation.coordinate = coor;
    annotation.title = @"这里是北京";
    annotation.subtitle=@"来吧";
    [_mapView addAnnotation:annotation];
    
    // 添加折线覆盖物
    CLLocationCoordinate2D coors[2] = {0};
    coors[0].latitude = 39.315;
    coors[0].longitude = 116.304;
    coors[1].latitude = 39.515;
    coors[1].longitude = 116.504;
    BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:2];
    [_mapView addOverlay:polyline];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 20.0f, 80.0f, 40.0f);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
    _locService = [[BMKLocationService alloc]init];
    _locService.desiredAccuracy =kCLLocationAccuracyBest;
    //    设定定位的最小更新距离。默认为kCLDistanceFilterNone
    _locService.distanceFilter =10.0;
    
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];

    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    //编码服务的初始化(就是获取经纬度,或者获取地理位置服务)
    _geocodesearch.delegate = self;//设置代理为self
    
    //热点检索
    _poisearch =[[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    //    //路线检索
    //    _routeSearch = [[BMKRouteSearch alloc]init];
    //    _routeSearch.delegate = self;
    
    

}
-(void)buttonTouch
{
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    //设置当前地图缩放比例
    _mapView.zoomLevel =16;

    DLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    
    CLLocation *loca = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
    //编码
    CLGeocoder *coder = [[CLGeocoder alloc]init];
    
    [coder reverseGeocodeLocation:loca completionHandler:^(NSArray *placemarks, NSError *error) {
        
        [placemarks enumerateObjectsUsingBlock:^(CLPlacemark *mark, NSUInteger idx, BOOL *stop) {
            
            DLog(@"name>>>%@city>>>>>%@country>>>>>>%@",mark.name,mark.locality,mark.country);
            
        }];
        
    }];
    
}

//实现PoiSearchDeleage处理回调结果 简单的搜索结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        //在此处理正常结果
        
        //BMKPoiSearch里面有一个数组属性poiResultList,里面存放的是搜索结果
        NSArray *resultArr=poiResultList.poiInfoList;
        
        for (BMKPoiInfo *info in resultArr)
        {
            
            DLog(@"name>>>>>>%@,address>>>>>%@,",info.name,info.address);
            //uid获取方法 方便查询详情的时候使用
            [dataarr setObject:info.uid forKey:info.name];
            
            BMKPointAnnotation *annotation=[[BMKPointAnnotation alloc]init];
            annotation.coordinate=info.pt;
            annotation.title=info.name;
            annotation.subtitle=info.address;
            [_mapView addAnnotation:annotation];
            
            DLog(@"uid>>>>>>>>>>>%@",info.uid);
            
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD)
    {
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        DLog(@"起始点有歧义");
    }
    else
    {
        DLog(@"抱歉，未找到结果");
    }
    
    
}




@end
