
Pod::Spec.new do |s|

  s.name         = "ZLHTTPSessionManager"
  s.version      = "1.0.1"
  s.summary      = "基于AFNetworking的马甲库"
  s.description  = "对AFNetworking的请求进行了一层封装，集成了打印日志、检测网络状态、筛除NULL、转换基本数据类型为字符串、将ERROR进行分类等。"

  s.homepage     = "https://gitee.com/ZLPublicKits/ZLHTTPSessionManager"
  s.license      = "MIT"
  s.author             = { "Mr.Zhao" => "itzhaolei@foxmail.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://gitee.com/ZLPublicKits/ZLHTTPSessionManager.git", :tag => s.version }

  s.public_header_files = 'ZLHTTPSessionManager/Classes/ZLHTTPSessionHeader.h'
  s.source_files = 'ZLHTTPSessionManager/Classes/ZLHTTPSessionHeader.h'

  s.framework  = "UIKit","Foundation"
  
  s.subspec 'Unit' do |ss|
      ss.vendored_framework = "ZLHTTPSessionManager/Classes/ZLHTTPSessionManager.framework"
      ss.dependency "AFNetworking", "~> 3.2.1"
  end
  
end
