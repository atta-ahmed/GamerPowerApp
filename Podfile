target 'GamerPowerApp' do
  use_frameworks!

  pod 'Alamofire', '5.10.2'
  pod 'Moya', '~> 15.0'
  pod 'Kingfisher', '8.2.0'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if ['Alamofire', 'Moya', 'Kingfisher'].include?(target.name)
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
  end
end
