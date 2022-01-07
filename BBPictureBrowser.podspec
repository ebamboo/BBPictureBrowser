Pod::Spec.new do |spec|

  spec.name         = "BBPictureBrowser"
  spec.version      = "2.1.0"
  spec.license      = "MIT"
  spec.summary      = "一个轻量级的图片浏览器"
  spec.author       = { "ebamboo" => "1453810050@qq.com" }
  
  spec.homepage     = "https://github.com/ebamboo/BBPictureBrowser"
  spec.source       = { :git => "https://github.com/ebamboo/BBPictureBrowser.git", :tag => spec.version }

  spec.source_files = "BBPictureBrowser/BBPictureBrowser/*.{h,m}"
  spec.resource     = "BBPictureBrowser/BBPictureBrowser/Resources/*"
  
  spec.platform     = :ios, "11.0"
  spec.requires_arc = true
  spec.dependency "SDWebImage"
  
end
