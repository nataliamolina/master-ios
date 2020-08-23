# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

workspace 'Master'

def firebase
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Messaging'
  pod 'Firebase/Storage'
end

def commons
  pod 'EasyBinding', '~> 0.2.3'
  pod 'Simple-Networking', '~> 0.3.7'
  pod 'SimpleKeychain'
  pod 'Kingfisher', '~> 5.0'
  pod 'Hero'
  pod 'Localize'
  pod 'GoogleSignIn'
  pod 'SwiftLint'
  pod 'lottie-ios'
  pod 'FloatRatingView', '~> 4'
  pod 'MBRadioButton'
  pod 'SPAlert'
  firebase
end

target 'Master' do
  commons
end

target 'Dev' do
  commons
end

target 'Local' do
  commons
end

target 'MasterTests' do
  commons
end

#### Paymentez

target 'Paymentez' do
  project 'Paymentez/Paymentez.xcodeproj'
end
