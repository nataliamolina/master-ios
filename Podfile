# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def commons
  pod 'SimpleBinding'
  pod 'Simple-Networking'
  pod 'Kingfisher', '~> 5.0'
  pod 'NotificationBannerSwift', '~> 3.0.0'
  pod 'Hero'
  pod 'Firebase/Analytics'
  pod 'Localize'
end

target 'Master' do
  use_frameworks!
  commons
end 

target 'MasterTests' do
  inherit! :search_paths
  commons
end
