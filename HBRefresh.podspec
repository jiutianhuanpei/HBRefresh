Pod::Spec.new do |spec|

  spec.name         = "HBRefresh"
  spec.version      = "0.0.1"
  spec.summary      = "下拉刷新控件"
  spec.description  = <<-DESC
  Swift 版本的下拉刷新控件，预留方便自定义的接口
                   DESC

  spec.homepage     = "http://shenhongbang.cc"
  spec.license      = "MIT (example)"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "沈红榜" => "shenhongbang@163.com" }
  spec.source       = { :git => "https://github.com/jiutianhuanpei/HBRefresh.git", :tag => "#{spec.version}" }


  spec.source_files  = "HBRefresh/HBRefresh/*"
  spec.swift_version = '6.0'

end
