Pod::Spec.new do |s|
  s.name = 'Boilerplate'
  s.version = '1.1.5'
  s.license = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.summary = 'Swift boilerplate code library with tons of useful stuff, including Linux compatibility layers'
  s.homepage = 'https://github.com/crossroadlabs/Boilerplate'
  s.social_media_url = 'https://github.com/crossroadlabs/Boilerplate'
  s.authors = { 'Daniel Leping' => 'daniel@crossroadlabs.xyz' }
  s.source = { :git => 'https://github.com/crossroadlabs/Boilerplate.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Sources/Boilerplate/*.swift'
  
  s.dependency 'Result', '~> 3.2'

  s.requires_arc = true
end
