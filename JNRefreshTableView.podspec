Pod::Spec.new do |s|
  s.name          = "JNRefreshTableView"
  s.version       = "1.0"
  s.platform      = :ios, "8.0"
  s.license       = "MIT"
  s.requires_arc  = true
  s.author        = { "Yigol2008" => "yigol2008@163.com" }

  s.summary       = "集成刷新控件"
  s.description   = "集成刷新控件，无数据时显示默认的图片"

  s.homepage      = "https://github.com/Yigol2008/JNRefreshTableView"
  s.source        = { :git => "https://github.com/Yigol2008/JNRefreshTableView.git", :tag => "#{s.version.to_s}" }
  s.source_files  = "JNRefreshTableView/*.{h,m}"

#  s.module_name = "JNRefreshTableView" 

#  s.dependency "MJRefresh", "~> 3.1.0"
#  s.dependency "DZNEmptyDataSet", "~> 1.8"

end

