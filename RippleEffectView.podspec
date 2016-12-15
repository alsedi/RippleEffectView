#
# Be sure to run `pod lib lint RippleEffectView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RippleEffectView'
  s.version          = '1.0.0'
  s.summary          = 'RippleEffectView - A Neat Rippling View Effect'

  s.description      = <<-DESC
                        RippleEffectView inspired by RayWenderlich.com article How To Create an Uber Splash Screen
                        Not only Uber-like animated loading screen background.
                        RippleEffectView inspired by [https://www.raywenderlich.com/133224/how-to-create-an-uber-splash-screen](RayWenderlich.com) article How To Create an Uber Splash Screen
                       DESC

  s.homepage         = 'https://github.com/alsedi/RippleEffectView'
  s.screenshots     = 'https://raw.githubusercontent.com/alsedi/RippleEffectView/master/rippleEffectView1.gif', 'https://raw.githubusercontent.com/alsedi/RippleEffectView/master/rippleEffectView2.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'Alex Sergev' => ' alex@alsedi.com' }
  s.source           = { :git => 'https://github.com/alsedi/RippleEffectView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'RippleEffectView/**/*'
  
  s.frameworks = 'UIKit'
end
