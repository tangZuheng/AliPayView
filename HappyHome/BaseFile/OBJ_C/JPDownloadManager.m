//
//  JPDownloadManager.m
//  JPVideoPlayer
//
//  Created by lava on 16/8/18.
//  Hello! I am NewPan from Guangzhou of China, Glad you could use my framework, If you have any question or wanna to contact me, please open https://github.com/Chris-Pan or http://www.jianshu.com/users/e2f2d779c022/latest_articles


#import "JPDownloadManager.h"

@interface JPDownloadManager()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, assign) long long curOffset;

@property (nonatomic) NSUInteger fileLength;

@property (nonatomic, strong) NSString *mimeType;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, assign) NSUInteger downLoadingOffset;

@property (nonatomic, assign) BOOL once;

@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, strong) NSString *tempPath;

/** 
 * Suggest File Name
 * 文件名 
 */
@property(nonatomic, strong)NSString *suggestFileName;

@end


@implementation JPDownloadManager

#pragma mark --------------------------------------------------
#pragma mark Public

- (void)setUrl:(NSURL *)url offset:(long long)offset{
    
    _url = url;
    _curOffset = offset;
    _downLoadingOffset = 0;
    
    // Check is already exist cache of this file(url) or not
    // 检查有没有缓存
    NSString *urlString = [url absoluteString];
    self.suggestFileName = [urlString lastPathComponent];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *savePath = [self fileSavePath];
    savePath = [savePath stringByAppendingPathComponent:self.suggestFileName];
    if ([manager fileExistsAtPath:savePath]) {
        
        // If cache is existed, then return the save path by Delegate-Method
        // 已经存在这个下载好的文件了, 返回文件地址
        
        if ([self.delegate respondsToSelector:@selector(manager:fileExistedWithPath:)]) {
            [self.delegate manager:self fileExistedWithPath:savePath];
        }
        return;
    }

    [self startLoading];
}

-(void)cancel{
    [self.session invalidateAndCancel];
}


#pragma mark --------------------------------------------------
#pragma mark NSURLSessionDataDelegate

// ReceiveResponse
// 接收到服务器响应的时候
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    NSLog(@"ReceiveResponse, 开始下载");
    _isFinishLoad = NO;
    _mimeType = @"video/caf";
    
    // Combine temporary file save path
    // 拼接临时文件存储路径
    self.tempPath = [self fileCachePath];
    
    // Get the total length of file
    // 获取文件总长度. 如果响应头里有文件长度数据, 就取这个长度; 如果没有, 就取代理方法返回给我们的长度
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *dic = (NSDictionary *)[httpResponse allHeaderFields] ;
    NSString *content = [dic valueForKey:@"Content-Range"];
    NSArray *array = [content componentsSeparatedByString:@"/"];
    NSString *length = array.lastObject;
    NSUInteger fileLength;
    if ([length integerValue] == 0) {
        fileLength = (NSUInteger)httpResponse.expectedContentLength;
    }
    else {
        fileLength = [length integerValue];
    }
    self.fileLength = fileLength;
    
    if ([self.delegate respondsToSelector:@selector(manager:didReceiveVideoLength:mimeType:)]) {
        [self.delegate manager:self didReceiveVideoLength:self.fileLength mimeType:self.mimeType];
    }
    
    self.outputStream = [[NSOutputStream alloc]initToFileAtPath:_tempPath append:YES];
    [self.outputStream open];
    
    // For Test  NSLog(@"%@", self.tempPath);
    
    completionHandler(NSURLSessionResponseAllow);
}

// ReceiveData
// 接收到服务器返回数据的时候调用,会调用多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    _downLoadingOffset += data.length;
    [self.outputStream write:data.bytes maxLength:data.length];
    
    // For Test NSLog(@"%lf", 1.0 * _downLoadingOffset / self.videoLength);
    
    if ([self.delegate respondsToSelector:@selector(manager:didReceiveData:downloadOffset:tempFilePath:)]) {
        [self.delegate manager:self didReceiveData:data downloadOffset:_downLoadingOffset tempFilePath:_tempPath];
    }
}

// Request Finished(Success|Fail)
// 请求结束的时候调用(成功|失败),如果失败那么error有值
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (!error) { // 下载成功
        [self downloadSuccessWithURLSession:session task:task];
    }
    else{ // 下载失败
        [self downloadFailedWithURLSession:session task:task error:error];
    }
}


#pragma mark --------------------------------------------------
#pragma mark Handle Request Finished(Success|Fail)

-(void)downloadSuccessWithURLSession:(NSURLSession *)session task:(NSURLSessionTask *)task{
    
    // If download success, then move the complete file from temporary path to cache path
    // 如果下载完成, 就把文件移到缓存文件夹
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *savePath = [self fileSavePath];
    savePath = [savePath stringByAppendingPathComponent:self.suggestFileName];
    
    if ([fileManager fileExistsAtPath:self.tempPath]) {
        [fileManager moveItemAtPath:self.tempPath toPath:savePath error:nil];
        if ([self.delegate respondsToSelector:@selector(didFinishLoadingWithManager:fileSavePath:)]) {
            [self.delegate didFinishLoadingWithManager:self fileSavePath:savePath];
        }
        [self.outputStream close];
        self.outputStream = nil;
    }
}

-(void)downloadFailedWithURLSession:(NSURLSession *)session task:(NSURLSessionTask *)task error:(NSError *)error{
    
    //网络中断：-1005
    //无网络连接：-1009
    //请求超时：-1001
    //服务器内部错误：-1004
    //找不到服务器：-1003
    
    if (error.code == -1001 && !_once) {
        
        // Network timeout, connect again
        // 网络超时，重连一次
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startLoading];
            _once = YES;
        });
    }
    
    if ([self.delegate respondsToSelector:@selector(didFailLoadingWithManager:WithError:)]) {
        [self.delegate didFailLoadingWithManager:self WithError:error];
    }
    
    if (error.code == -1009) {
        NSLog(@"No Connect 无网络连接");
    }
}


#pragma mark --------------------------------------------------
#pragma mark Private

// Combine temporary file path
// 拼接临时文件缓存存储路径
-(NSString *)fileCachePath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:jp_tempPath];
    
    // Make folder
    // 创建文件夹
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    path = [path stringByAppendingPathComponent:self.suggestFileName];
    
    if ([fileManager fileExistsAtPath:path] && !self.once) {
        [fileManager removeItemAtPath:path error:nil];
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    else {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

// Combine complete file path
// 拼接完整文件存储路径
-(NSString *)fileSavePath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:jp_savePath];
    
    // Make folder
    // 创建文件夹
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

- (void)clearData{
    [self.session invalidateAndCancel];
    [self.outputStream close];
    self.outputStream = nil;
    
    // delete temporary file
    // 移除临时文件
    [[NSFileManager defaultManager] removeItemAtPath:_tempPath error:nil];
}

-(void)startLoading{
    
    // Fix scheme
    // 替代NSMutableURL, 可以动态修改scheme
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:_url resolvingAgainstBaseURL:NO];
    actualURLComponents.scheme = @"http";
    
    // Create request
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[actualURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    // fix offset of request
    // 修改请求数据范围
    if (_curOffset > 0 && self.fileLength > 0) {
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)_curOffset, (unsigned long)self.fileLength - 1] forHTTPHeaderField:@"Range"];
    }
    
    // Reset
    // 重置
    [self.session invalidateAndCancel];
    
    // Create session, set delegate at the same time
    // 创建Session，并设置代理
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // create dataTask
    // 创建会话对象
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    
    // Start download
    // 开始下载
    [dataTask resume];
}

@end
