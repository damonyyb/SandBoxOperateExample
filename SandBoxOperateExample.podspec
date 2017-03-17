
Pod::Spec.new do |s|
  s.name         = "SandBoxOperateExample"
  s.version      = "0.0.1"
  s.summary      = "An Cashe manager Tool."
  s.description  = "An Cashe manager Tool easyUSE."
  s.homepage     = "https://github.com/damonyyb/SandBoxOperateExample"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "damonyyb" => "961355618@qq.com" }
  s.source       = { :git => "https://github.com/damonyyb/SandBoxOperateExample.git", :tag => "#{s.version}" }
  s.ios.deployment_target = '8.0'
  s.source_files = "SandBoxOperate/*.{h,m}"
  s.frameworks   = "Foundation", "UIKit"
  s.requires_arc = true
end
