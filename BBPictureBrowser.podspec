Pod::Spec.new do |spec|

  spec.name         = "BBPictureBrowser"
  spec.version      = "1.0.0"
  spec.license      = 'MIT'
  spec.summary      = "iOS 开发中的图片浏览器."
  spec.author       = { "姚旭" => "1453810050@qq.com" }
  
  spec.homepage     = "https://github.com/ebamboo/BBPictureBrowser"
  spec.source       = { :git => "https://github.com/ebamboo/BBPictureBrowser.git", :tag => spec.version }

  spec.source_files  = "BBPictureBrowser/BBPictureBrowser/*.{h,m}"

  spec.platform     = :ios, "11.0"
  spec.requires_arc = true
  spec.dependency 'SDWebImage'
  
end
