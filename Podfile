#source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'HappyHome' do

pod 'MJRefresh', '~> 3.1.2’
pod 'ReactiveCocoa' , '~> 4.2.2'
pod 'MBProgressHUD', '~> 1.0.0'
pod 'SnapKit', '~> 0.22.0'
pod 'Alamofire', '3.5.1'
pod 'LTMorphingLabel' , '0.3.0'
pod 'SQLite.swift', '~> 0.10.1'
pod 'HandyJSON', '0.4.0'
pod 'SDWebImage', '~>3.8'
pod 'CXAlertView'
pod 'UMengAnalytics'
pod 'JPush-iOS-SDK', '~> 2.1.9'
pod 'mp3lame-for-ios'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
