//
//  HttpNetworkManager.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HttpNetworkManager.h"
#import <AFNetworking.h>
#import "ServersPositionAnnotionsModel.h"
#import <MJExtension.h>
#import "PositionUtil.h"
#import "MethodResult.h"
#import "WorkTypeInfoModel.h"
#import "BRServiceUnit.h"
#import <Pingpp.h>
#import <AVFoundation/AVFoundation.h>

#define kUrlScheme  @"wx8b40ee373b8d6864"

@interface HttpNetworkManager()

@property (nonatomic, strong) AFHTTPRequestOperationManager* manager;

@property (nonatomic, strong) AFHTTPRequestOperationManager *sharedClient;

@end

//static NSString * const AFHTTPRequestOperationBaseURLString = @"http://222.18.159.51:8080/zkwebservice/webservice/";
//static NSString * const AFHTTPRequestOperationBaseURLString = @"http://222.18.159.34:8080/zkwebservice/webservice/";
static NSString * const AFHTTPRequestOperationBaseURLString = @"http://zkwebservice.witaction.com:808/zkwebservice/webservice/";



@implementation HttpNetworkManager


#pragma mark - setter & getter
-(AFHTTPRequestOperationManager*)manager
{
    if (_manager == nil)
    {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
        //_manager.requestSerializer = [NSSet setWithArray:@[@"text/plain",@"text/html",@"text/json"]];
        _manager.requestSerializer=[AFJSONRequestSerializer serializer];
       // _manager.responseSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];;
    }
    return _manager;
}

#pragma mark - setter &getter
-(AFHTTPRequestOperationManager *)sharedClient
{
    if (_sharedClient == nil) {
        _sharedClient = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:AFHTTPRequestOperationBaseURLString]];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/json", @"text/html", nil];
    }
    return _sharedClient;
}

#pragma mark - baseURL
+ (NSString *)baseURL
{
    return AFHTTPRequestOperationBaseURLString;
}

#pragma mark - Public Methods
+(instancetype)getInstance{
    static HttpNetworkManager* sharedNetworkHttpManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedNetworkHttpManager = [[HttpNetworkManager alloc] init];
    });
    return sharedNetworkHttpManager;
}


#pragma mark - Public Methods
-(void)verifyPhoneNumber:(NSString*)phoneNum resultBlock:(HCDictionaryResultBlock)resultBlock;
{
    NSString *url = [NSString stringWithFormat:@"http://lt.witaction.com:8080/uuc/servlet/login?phone_num=%@&type=auth_code&debug=true",phoneNum];//false
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        resultBlock(responseObject,nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        resultBlock(nil,error);
    }];

}

-(void)vertifyPhoneNumber:(NSString*)phoneNum VertifyCode:(NSString*)code resultBlock:(HCDictionaryResultBlock)resultBlock
{
    NSString* url = [NSString stringWithFormat:@"http://lt.witaction.com:8080/uuc/servlet/login?phone_num=%@&type=phoneNumValidate&auth_code=%@&gen_uuid=true&uuid_timeout=%lld", phoneNum,code,(long long)7*24*3600*3600];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        resultBlock(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        resultBlock(nil, error);
    }];
}

-(void)loginWithUuid:(NSString*)uuid UuidTimeOut:(NSString*)uuidTimeout resultBlock:(HCDictionaryResultBlock)resultBlock{
    NSString* url = [NSString stringWithFormat:@"http://lt.witaction.com:8080/uuc/servlet/login?type=uuid_validate&uuid_timeout=%@&uuid=%@", uuidTimeout,uuid];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        resultBlock(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        resultBlock(nil, error);
    }];
}

#pragma mark - 获得当前位置服务点信息
// 获得当前位置服务点信息
- (void)getNearbyServicePointsWithCLLocation:(CLLocationCoordinate2D)location resultBlock:(HCArrayResultBlock)resultBlock
{
    NSString *url = [NSString stringWithFormat:@"servicePoint/findByPosition?longitude=%lf&latitude=%lf&tolerance=0.05", location.longitude, location.latitude];
    [self.sharedClient GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *servicePositionsArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in responseObject) {
            ServersPositionAnnotionsModel *servicePosition = [ServersPositionAnnotionsModel mj_objectWithKeyValues:dict];
            
            // 将gps坐标转换为百度坐标
            PositionUtil *posit = [[PositionUtil alloc]init];
            CLLocationCoordinate2D coor = [posit wgs2bd:servicePosition.positionLa lon:servicePosition.positionLo];
            // 覆盖原先的位置
            servicePosition.positionLa = coor.latitude;
            servicePosition.positionLo = coor.longitude;
            
            [servicePositionsArray addObject:servicePosition];
        }
        if (resultBlock) {
            resultBlock(servicePositionsArray, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (resultBlock) {
            resultBlock(nil, error);
        }
    }];
}

#pragma mark -创建或更新用户信息
// 创建或更新用户信息
- (void)createOrUpdateUserinformationwithInfor:(NSDictionary *)personinfo resultBlock:(void (^)(BOOL, NSError *))block
{
    NSString *url = [NSString stringWithFormat:@"customer/createOrUpdate"];
    [self.sharedClient POST:url parameters:personinfo success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (block) {
            block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (block) {
            block(NO, error);
        }
    }];
}

#pragma mark －创建或更新单位信息
// 创建或更新单位信息
- (void)createOrUpdateBRServiceInformationwithInfor:(NSDictionary *)BRServiceInfo resultBlock:(void (^)(BOOL, NSError *))block
{
    NSString *url = [NSString stringWithFormat:@"brServiceUnit/createOrUpdate"];
    [self.sharedClient POST:url parameters:BRServiceInfo success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (block) {
            block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (block) {
            block(NO, error);
        }
    }];
}

#pragma mark - 获得预约处理信息 包括个人，单位待处理项
// 获得预约处理信息 包括个人，单位待处理项
- (void)getCheckListWithBlock:(void (^)(NSArray *, NSArray *, NSError *))block
{
    NSInteger type = GetUserType;
    // 个人
    if (type == 1) {
        NSString *url = [NSString stringWithFormat:@"customerTest/findMyCheckList?customId=%@&cCheckType=1&linkPhone=%@", gPersonInfo.mCustCode, gPersonInfo.StrTel];
        [self.sharedClient GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSMutableArray *brArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in responseObject) {
                CustomerTest *custom = [CustomerTest mj_objectWithKeyValues:dict];
                [brArray addObject:custom];
            }
            if (block) {
                block(brArray, nil, nil);
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            if (block) {
                block(nil, nil, error);
            }
        }];
    }
    // 单位
    else if(type == 2){
        NSString *url = [NSString stringWithFormat:@"brContract/findMyCheckList?customId=%@&checkType=1", gCompanyInfo.cUnitCode];
        [self.sharedClient GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSMutableArray *brArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in responseObject) {
                BRContract *brCon = [BRContract mj_objectWithKeyValues:dict];
                [brArray addObject:brCon];
            }
            if (block) {
                block(nil, brArray, nil);
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            if (block) {
                block(nil, nil, error);
            }
        }];
    }
    else {
        if (block) {
            block(nil, nil, [NSError errorWithDomain:@"error" code:404 userInfo:[NSDictionary dictionaryWithObject:@"用户类型获取失败" forKey:@"error"]]);
        }
    }
}


#pragma mark 查询单位员工列表
// 查询单位员工列表
- (void)getWorkerCustomerDataWithcUnitCode:(NSString *)cUnitCode resultBlock:(HCArrayResultBlock)resultBlock;
{
    NSString *url = [NSString stringWithFormat:@"customer/queryByServiceUnit?cUnitCode=%@", cUnitCode];
    [self.sharedClient GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *customerArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in responseObject) {
            Customer *customer = [Customer mj_objectWithKeyValues:dict];
            [customerArray addObject:customer];
        }
        if (resultBlock) {
            resultBlock(customerArray, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (resultBlock) {
            resultBlock([NSArray array], error);
        }
    }];
}

- (void)getIndustryList:(NSString*)dataItemName resultBlock:(HCArrayResultBlock)resultBlock
{
    NSString *url = [NSString stringWithFormat:@"codeDataItem/findCodeDataItemConByName?dataItemName=%@", dataItemName];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.sharedClient GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *customerArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in responseObject) {
            WorkTypeInfoModel *workTypeInfoModel = [WorkTypeInfoModel mj_objectWithKeyValues:dict];
            [customerArray addObject:workTypeInfoModel];
        }
        if (resultBlock) {
            resultBlock(customerArray, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (resultBlock) {
            resultBlock([NSArray array], error);
        }
    }];
}

#pragma mark -上传客户头像
// 上传客户头像
- (void)customerUploadPhoto:(UIImage *)photo resultBlock:(HCBoolResultBlock)block
{
    NSData *imageData;
    NSString *imagetype;
    if(UIImagePNGRepresentation(photo) == nil){
        imageData = UIImageJPEGRepresentation(photo, 1);
        imagetype = @"jpeg";
    }
    else {
        imageData = UIImagePNGRepresentation(photo);
        imagetype= @"png";
    }

    NSString *url = [NSString stringWithFormat:@"customer/uploadPhoto"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:gPersonInfo.mCustCode forKey:@"cCustCode"];
    [self.sharedClient POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (block) {
            block(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (block) {
            block(NO, error);
        }
    }];
}



#pragma mark - 个人预约相关
// 个人预约相关
-(void)createOrUpdatePersonalAppointment:(CustomerTest*)customerTest resultBlock:(HCDictionaryResultBlock)resultBlock
{
    NSDictionary* dicInfo = customerTest.mj_keyValues;
    NSString *url = [NSString stringWithFormat:@"customerTest/createOrUpdate"];
    [self.sharedClient POST:url parameters:dicInfo success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (resultBlock) {
            resultBlock(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (resultBlock) {
            resultBlock(nil, error);
        }
    }];
}

-(void)customerUploadHealthyCertifyPhoto:(UIImage*)photo CusCheckCode:(NSString*)checkCode resultBlock:(HCDictionaryResultBlock)resultBlock
{
    NSData *imageData;
    NSString *imagetype;
    if(UIImagePNGRepresentation(photo) == nil){
        imageData = UIImageJPEGRepresentation(photo, 1);
        imagetype = @"jpeg";
    }
    else {
        imageData = UIImagePNGRepresentation(photo);
        imagetype= @"png";
    }
    
    NSString *url = [NSString stringWithFormat:@"customerTest/uploadPrintPhoto"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:checkCode forKey:@"cCheckCode"];
    [self.sharedClient POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (resultBlock) {
            resultBlock(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (resultBlock) {
            resultBlock(nil, error);
        }
    }];
}

#pragma mark - 单位预约
// 单位预约
- (void)createOrUpdateBRCoontract:(BRContract *)brcontract employees:(NSArray *)employees reslutBlock:(HCBoolResultBlock)block
{
    NSMutableString *url = [NSMutableString stringWithFormat:@"brContract/createOrUpdate?employeeStr="];
    if (employees.count != 0) {
        for (int i = 0; i < employees.count; i ++) {
            Customer *customer = employees[i];
            [url appendString:customer.custCode];
            if (i < employees.count - 1) {
                [url appendString:@"#"];
            }
        }
    }

    NSString *newurl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableDictionary *dict = [brcontract mj_keyValues];
    [self.sharedClient POST:newurl parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *error = nil;
        if ([[responseObject objectForKey:@"object"] isEqualToString:@"0"]) {
            error = [NSError errorWithDomain:@"error" code:0 userInfo:[NSDictionary dictionaryWithObject:@"预约异常失败，请重试" forKey:@"error"]];
        }
        else if ([[responseObject objectForKey:@"object"] isEqualToString:@"1" ]){
            error = [NSError errorWithDomain:@"error" code:1 userInfo:[NSDictionary dictionaryWithObject:@"已达到修改次数上限" forKey:@"error"]];
        }
        if (block) {
            block(YES, error);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (block) {
            block(NO, error);
        }
    }];
}

#pragma mark 根据名字模糊查询单位信息
- (void)fuzzQueryBRServiceUnitsByName:(NSString *)companyName resultBlock:(HCArrayResultBlock)block
{
    NSString *url = [NSString stringWithFormat:@"brServiceUnit/fuzzyQueryByName?name=%@&maxReturnSize=10", companyName];
    NSString *newurl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.sharedClient GET:newurl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in responseObject) {
            BRServiceUnit *brservice = [BRServiceUnit mj_objectWithKeyValues:dict];
            [dataArray addObject:brservice];
        }
        if (block) {
            block(dataArray, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}

#pragma mark -查询个人历史
// List<CustomerTest>
- (void)findCustomerTestHistoryRegByCustomId:(NSString *)customId resuluBlock:(HCArrayResultBlock)block
{
    NSString *url = [NSString stringWithFormat:@"customerTest/findHistoryReg?customId=%@", customId];
    [self.sharedClient GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in responseObject) {
            CustomerTest *customertest = [CustomerTest mj_objectWithKeyValues:dict];
            [dataArray addObject:customertest];
        }
        if (block) {
            block(dataArray, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}
#pragma mark - 查询单位预约历史记录
// List<BRContract>
- (void)findBRContractHistoryRegByCustomId:(NSString *)customId resuleBlock:(HCArrayResultBlock)block
{
    NSString *url = [NSString stringWithFormat:@"brContract/findHistoryReg?customId=%@",customId];
    [self.sharedClient GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in responseObject) {
            BRContract *brcontract = [BRContract mj_objectWithKeyValues:dict];
            [dataArray addObject:brcontract];
        }
        if (block) {
            block(dataArray, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}

#pragma mark -付款
- (void)payMoneyWithChargeParameter:(ChargeParameter *)chargeParame viewController:(UIViewController *)_self resultBlock:(void (^)(NSString *, NSError *))block
{

//    NSString *urlstr = [NSString stringWithFormat:@"%@charge/newCharge", [HttpNetworkManager baseURL]];
//    NSURL    *url = [NSURL URLWithString:urlstr];
//    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url];
    NSDictionary *dict = [chargeParame mj_keyValues];

//    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
//    [postRequest setHTTPMethod:@"POST"];
//    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//            // 网络连接出现失败
//            if (httpResponse.statusCode != 200 || connectionError != nil) {
//                block(@"网络出现错误，请检查网络", [NSError errorWithDomain:@"error" code:100 userInfo:[NSDictionary dictionaryWithObject:@"网络出现错误，请检查网络" forKey:@"error"]]);
//                return;
//            }
//            NSDictionary *resultObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            NSLog(@"resuleobject :%@", resultObject);
////            NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
////            NSLog(@"charge = %@", charge);
////            [Pingpp createPayment:charge viewController:_self appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
////                NSError *failerror = nil;
////                if (error != nil) {
////                    failerror = [NSError errorWithDomain:@"error" code:error.code userInfo:[NSDictionary dictionaryWithObject:[error getMsg] forKey:@"error"]];
////                }
////                block(result, failerror);
////            }];
//        });
//    }];

    NSString *url = @"charge/newCharge";

    [self.sharedClient POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"response:%@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
    }];
}
@end
