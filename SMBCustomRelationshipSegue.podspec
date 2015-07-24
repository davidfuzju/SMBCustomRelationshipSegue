#
# Be sure to run `pod lib lint SMBCustomRelationshipSegue.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SMBCustomRelationshipSegue"
  s.version          = "0.1.0"
  s.summary          = "a simple implementation for custom relationship segue, enhance the custom container view controller in storyboard like UINavigationController or UITabbarController"
  s.description      = <<-DESC
                       DESC
  s.homepage         = "https://github.com/SuperMarioBean/SMBCustomRelationshipSegue"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "David Fu" => "david.fu.zju.dev@gmail.com" }
  s.source           = { :git => "git@github.com:SuperMarioBean/SMBCustomRelationshipSegue.git", :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SMBCustomRelationshipSegue' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
