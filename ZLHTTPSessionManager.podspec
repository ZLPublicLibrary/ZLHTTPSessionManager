Pod::Spec.new do |s|

s.name         = "ZLHTTPSessionManager"
s.version      = "4.1.0"
s.summary      = "基于AFNetworking的马甲库"
s.description  = "对AFNetworking的请求进行了一层封装，集成了打印日志、检测网络状态、筛除NULL、转换基本数据类型为字符串、将ERROR进行分类等。"

s.homepage     = "https://github.com/ZLPublicLibrary/ZLHTTPSessionManager"
s.license      = "MIT"
s.author             = { "Mr.Zhao" => "itzhaolei@foxmail.com" }
s.ios.deployment_target = "9.0"
s.source       = { :git => "https://github.com/ZLPublicLibrary/ZLHTTPSessionManager.git", :tag => s.version }

s.public_header_files = 'ZLHTTPSessionManager/Classes/ZLHTTPSessionHeader.h'
s.source_files = 'ZLHTTPSessionManager/Classes/*.{h,m}'

s.framework  = "UIKit","Foundation"

s.dependency "AFNetworking", "~> 4.0.1"

end
