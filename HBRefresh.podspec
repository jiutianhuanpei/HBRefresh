Pod::Spec.new do |s|

	s.name		= "HBRefresh"
	s.version	= "0.0.1"
	s.summary	= "下拉刷新控件"
	s.description = <<-DESC
	Swift 版本的下拉刷新控件，预留方便自定义的接口
					DESC
	s.homepage	= "http://shenhongbang.cc"
	s.license	= "MIT"
	s.author	= { "沈红榜" => "shenhongbang@163.com" }
	s.platform	= :ios
	s.source	= { :git => "https://github.com/jiutianhuanpei/HBRefresh.git", :tag => "#{s.version}" }

	s.source_files	= "HBRefresh/HBRefresh/*"
	s.ios.deployment_target = '16.0'
	s.swift_version = '6.0'

end	