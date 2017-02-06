//
//  StoreViewModel.m
//  MVVMTest
//
//  Created by ios on 2017/1/5.
//  Copyright © 2017年 c. All rights reserved.
//

#import "StoreViewModel.h"
#import "StoreModel.h"

@implementation StoreViewModel

-(instancetype) init{
    if([super init]){
        [self setupRACCommand];
    }
    return self;
}

#pragma mark - @weakify(self) 是RAC对__weak typeof(self) weakSelf = self的宏定义
#pragma mark - @strongify(self) 是RAC对__strong __typeof(self) strongSelf = weakSelf的宏定义
-(void) setupRACCommand{
    
    //@weakify(self);
    _fetchStoreModelCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //@strongify(self);
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"StoreData.json" ofType:@""];
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = [StoreModel mj_objectArrayWithKeyValuesArray:dic[@"datas"]];
            [subscriber sendNext:array];
            [subscriber sendCompleted];
            return nil;
            
#if 0
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
            [manager GET:(NSString *)input parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //NSLog(@"----%@",responseObject);
                if([responseObject[@"code"] integerValue] == 200){
                    NSArray *array = [StoreModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"]];
                    [subscriber sendNext:array];
                    [subscriber sendCompleted]; //数据传递完成信号,不然命令会一直执行
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                [subscriber sendError:error];
            }];

            return nil;
#endif
        }];

    }];
}

@end
