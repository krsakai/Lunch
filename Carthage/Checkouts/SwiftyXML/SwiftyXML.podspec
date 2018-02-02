Pod::Spec.new do |s|
  s.name        = "SwiftyXML"
  s.version     = "1.1.0"
  s.summary     = "The most swifty way to deal with XML data in swift 3"
  s.homepage    = "https://github.com/chenyunguiMilook/SwiftyXML"
  s.license     = { :type => "MIT" }
  s.authors     = { "chenyunguiMilook" => "286224043@qq.com" }

  s.requires_arc = true
  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source   = { :git => "https://github.com/chenyunguiMilook/SwiftyXML.git", :tag => s.version }
  s.source_files = "Source/*.swift"
  s.pod_target_xcconfig =  {
        'SWIFT_VERSION' => '3.0',
  }
end
