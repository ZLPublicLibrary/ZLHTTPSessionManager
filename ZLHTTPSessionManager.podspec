Pod::Spec.new do |s|

s.name         = "ZLHTTPSessionManager"
s.version      = "4.0.2.0"
s.summary      = "基于AFNetworking的优化库"
s.description  = "对AFNetworking的请求进行了一层封装。- 集成了打印日志\n- 检测网络状态\n- 替换NULL\n- 转换基本数据类型为字符串\n"

s.homepage     = "https://gitee.com/ZLKits/ZLHTTPSessionManager"
s.license      = "MIT"
s.author             = { "Mr.Zhao" => "itzhaolei@foxmail.com" }
s.ios.deployment_target = "11.0"
s.requires_arc = true
s.source       = { :git => "https://gitee.com/ZLKits/ZLHTTPSessionManager.git", :tag => s.version }


s.public_header_files = 'ZLHTTPSessionManager/Classes/ZLHTTPSessionHeader.h'
s.source_files = 'ZLHTTPSessionManager/Classes/ZLHTTPSessionHeader.h'

s.subspec 'Request' do |ss|
    ss.source_files = 'ZLHTTPSessionManager/Classes/Request/*.{h,m}'
    ss.dependency "ZLHTTPSessionManager/ReplaceNull"
end

s.subspec 'ReplaceNull' do |ss|
    ss.source_files = 'ZLHTTPSessionManager/Classes/ReplaceNull/*.{h,m}'
end

s.framework  = "UIKit","Foundation"
s.dependency "AFNetworking", "~> 4.0.1"

end
