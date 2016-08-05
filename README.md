# MKNetWork

这个对网络请求进行的封装暂且称之为轮子吧,是参考[YTKNetwork](https://github.com/yuantiku/YTKNetwork)和[RTNetworking](https://github.com/casatwy/RTNetworking)代码实现,拜读了[iOS应用架构谈 网络层设计方案](http://casatwy.com/iosying-yong-jia-gou-tan-wang-luo-ceng-she-ji-fang-an.html)和猿题库的两篇使用介绍并根据根据个人理解修改部分功能实现.功能并不完善,还在逐渐添加中.目的就是为了更好的理解网络层到底应该怎么设计,并根据项目需求制作出符合当前项目需求的网络请求轮子.

##核心部分
`MKBaseRequest`这里面封装的AFN,如果想要替换的话只需要更改这里面的代码,目前这里面只提供了两个对外的方法:

```
/// 添加网络请求
- (void)addRequest:(MKBaseRequest *)baseRequest;
/// 取消网络请求
- (void)cancelRequest:(NSNumber *)requestID;
```

根据这两个可以进行网络请求和取消网络请求.

##离散型的API调用
因为有些接口可能很多控制器会调用,所以提供`MKBaseRequest`.这里面负责集约化的部分.继承自它的负责离散部分.目前已经有的功能:

```
/// 请求的URL
- (NSString *)requestUrl;

/// 请求的BaseURL
- (NSString *)baseUrl;

/// 请求的cdnURL
- (NSString *)cdnUrl;

/// 请求的连接超时时间，默认为60秒
- (NSTimeInterval)requestTimeoutInterval;

/// Http请求的方法
- (MKRequestMethod)requestMethod;

/// 请求的SerializerType
- (MKRequestSerializerType)requestSerializerType;

/// 是否使用cdn的host地址
- (BOOL)useCDN;
```
当然,还很不完善正在努力添加中.

##统一设置网络请求的服务器和 CDN 的地址
`MKNetworkConfig`这个目前还存在争议,不过根据我们的需求还是添加上比较好,老版本项目中使用宏定义来区分各个环境的host,切换的时候整个项目重新编译很慢.添加上这个只在初始化的时候设置下就好了,不用重新编译整个项目.并且如果是使用默认地址的也不用重写`MKBaseRequest`里面的`baseUrl`,能省下很多.
猿题库中说的很好

1. 按照设计模式里的 `Do Not Repeat Yourself`原则，我们应该把服务器地址统一写在一个地方。
2. 在实际业务中，我们的测试人员需要切换不同的服务器地址来测试。统一设置服务器地址到 YTKNetworkConfig(仿写成`MKNetworkConfig`) 类中，也便于我们统一切换服务器地址。

##其他功能正在逐渐添加中...


