workspace 'Extensions'
project 'ExtensionApp/ExtensionApp'
use_frameworks!

target 'ExtensionApp' do
  platform :ios, '10.0'
  pod 'PubNub'

   target 'PubNubShareExtension' do
   	inherit! :search_paths
   end
   
#   target 'PubNubWatchExtension Extension' do
#       inherit! :search_paths
#       platform :watchos, '3.0'
#       pod 'PubNub'
#   end

end

target 'PubNubWatchExtension Extension' do
    platform :watchos, '3.0'
    pod 'PubNub'
end
