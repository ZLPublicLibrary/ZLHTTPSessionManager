Pod::Spec.new do |s|

s.name         = "ZLHTTPSessionManager"
s.version      = "4.0.1.2"
s.summary      = "基于AFNetworking的马甲库"
s.description  = "对AFNetworking的请求进行了一层封装，集成了打印日志、检测网络状态、筛除NULL、转换基本数据类型为字符串、将ERROR进行分类等。"

s.homepage     = "https://gitee.com/ZLKits/ZLHTTPSessionManager"
s.license      = "MIT"
s.author             = { "Mr.Zhao" => "itzhaolei@foxmail.com" }
s.ios.deployment_target = "11.0"
s.requires_arc = true
s.source       = { :git => "https://gitee.com/ZLKits/ZLHTTPSessionManager.git", :tag => s.version }


s.public_header_files = 'ZLHTTPSessionManager/Classes/ZLHTTPSessionHeader.h'
#s.source_files = 'ZLHTTPSessionManager/Classes/*.{h,m}'
s.source_files = 'ZLHTTPSessionManager/Classes/ZLHTTPSessionHeader.h'



s.subspec 'Request' do |ss|
    ss.source_files = 'ZLHTTPSessionManager/Classes/Request/*.{h,m}'
end

s.subspec 'ReplaceNull' do |ss|
    ss.source_files = 'ZLHTTPSessionManager/Classes/ReplaceNull/*.{h,m}'
end

s.framework  = "UIKit","Foundation"
s.dependency "AFNetworking", "~> 4.0.1"

end
