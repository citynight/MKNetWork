# MKNetWork

> 这个对网络请求进行的封装暂且称之为轮子吧,是参考[YTKNetwork](https://github.com/yuantiku/YTKNetwork)和[RTNetworking](https://github.com/casatwy/RTNetworking)代码实现,拜读了[iOS应用架构谈 网络层设计方案](http://casatwy.com/iosying-yong-jia-gou-tan-wang-luo-ceng-she-ji-fang-an.html)和猿题库的两篇使用介绍并根据根据个人理解修改部分功能实现.功能并不完善,还在逐渐添加中.目的就是为了更好的理解网络层到底应该怎么设计,并根据项目需求制作出符合当前项目需求的网络请求轮子.

# MKNetWork简介
用户版最新版本我将替换成最新的网络请求封装,这次我将封装一些常用的东西到网络请求中,让网络请求独立出一层,避免所有网络请求都写在控制器中.
目录结构:

* **MKBaseRequest**     :所有的网络请求类需要继承于 `MKBaseRequest` 类，每一个`MKBaseRequest` 类的子类代表一种专门的网络请求。
MKBaseRequest 的基本的思想是把每一个网络请求封装成对象。所以使用 MKNetWork，你的每一种请求都需要继承 MKBaseRequest类，通过覆盖父类的一些方法来构造指定的网络请求。把每一个网络请求封装成对象其实是使用了设计模式中的 Command 模式。
每一种网络请求继承 MKBaseRequest 类后，需要用方法覆盖（overwrite）的方式，来指定网络请求的具体信息。例如:

```
// 重写接口名称
-(NSString *)requestUrl {
    return @"geocode/regeo";
}
// 重写请求方式
-(MKRequestMethod)requestMethod {
    return MKRequestMethodGet;
}
// 重写想要的放回数据解析方式
-(MKRequestSerializerType)requestSerializerType {
    return MKRequestSerializerTypeHTTP;
}
```
目前没有添加返回参数格式验证,如有需要可以在base中添加,让继承者重写.

* **MKNetWorkAgent**    :MKNetWorkAgent最基础的网络请求封装,目前封装的AFN,如有必要可以替换
* **MKNetworkConfig**   :用于统一设置网络请求的服务器和 CDN 的地址。在实际业务中，我们的测试需要切换不同的服务器地址来测试。统一设置服务器地址到 MKNetworkConfig 类中，也便于我们统一切换服务器地址。

```
 - (void)setupRequestFilters {
    // 这里用高德Api进行测试
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    MKNetworkConfig *config = [MKNetworkConfig sharedInstance];
    config.baseUrl = @"http://restapi.amap.com/v3/";
    MKUrlArgumentsFilter *urlFilter = [MKUrlArgumentsFilter filterWithArguments:@{@"version": appVersion}];
    [config addUrlFilter:urlFilter];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupRequestFilters];
    
    return YES;
} 
```

* **MKChainRequest**    :用于管理有相互依赖的网络请求，它实际上最终可以用来管理多个拓扑排序后的网络请求。

例如，我们有一个需求，需要用户在注册时，先发送注册的Api，然后:
1. 如果注册成功，再发送读取用户信息的Api。并且，读取用户信息的Api需要使用注册成功返回的用户id号。
2. 如果注册失败，则不发送读取用户信息的Api了。



**不足:**
1. 目前没有做缓存,由于项目中url是根据时间戳,可以使用已有的缓存作为补充.也可以写到网络层封装中.
2. 串行网络请求封装了,但是由于默认就是并行网络请求,所以没有封装.如果需要限制最大并发数量,可以在`MKNetWorkAgent`中设置.
3. 木有大量测试,可能存在bug

**注意事项:**
基本没有啥需要注意的...,具体使用方法可以参见Demo,关于参数可以实现代理方法,也可以直接传参.如果直接传参,会覆盖掉代理中的数据源.  Demo中实现了简单的下拉加载中关于page的封装.扩展功能我都写成代理,然后需要什么功能实现以下就可以了,避免`MKBaseRequest`中包含太多功能,这样可以实现自定义组成自己需要的功能.


