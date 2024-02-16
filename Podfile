# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'SMarket' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for SMarket
  post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
   end
  end
  
  pod 'IQKeyboardManagerSwift'
  pod 'KYDrawerController', '~> 2.0.4'
  pod 'Alamofire', '~> 4.7.3'
  pod 'SDWebImage', '~> 4.4.2'
  pod 'ImageSlideshow', '~> 1.9.0'
  pod 'SwiftSoup'
  pod 'KeychainSwift'
  pod 'ReCaptcha/RxSwift'
  pod 'RxCocoa', '~> 5.0'
  pod 'SwiftLint', '~> 0.33'
  
  # Firebase Notification
  #  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Auth'
  pod 'Firebase/Crashlytics'
  pod 'Firebase'
  
  # Google Sign in And Place
  pod 'GoogleSignIn'
  pod 'GooglePlaces'
  pod 'GooglePlacePicker'
  pod 'GoogleMaps'
  
  # Paymet Gatway
  pod 'Stripe', '~> 19.4.0'

   

end
