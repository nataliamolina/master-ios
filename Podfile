# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def firebase
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Messaging'

end

def commons
  pod 'EasyBinding', '~> 0.2.1'
  pod 'Simple-Networking', '~> 0.3.4'
  pod 'SimpleKeychain'
  pod 'Kingfisher', '~> 5.0'
  pod 'NotificationBannerSwift', '~> 3.0.0'
  pod 'Hero'
  pod 'Localize'
  pod 'GoogleSignIn'
  pod 'SideMenu', '~> 6.0'
  pod 'SwiftLint'
  pod 'lottie-ios'
  firebase
end

target 'Master' do
  commons
end 

target 'MasterTests' do
  commons
end
