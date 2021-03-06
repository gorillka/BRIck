Pod::Spec.new do |s|

  s.name         = 'BRI'
  s.version      = '2.0.1'
  s.summary      = 'BRIck is mobile architecture.'

  s.description  = <<-DESC
  BRIck is mobile architecture based on RIBs but without RxSwift.
                   DESC

  s.homepage     = 'https://github.com/gorillka/BRIck'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { 'Artem Orynko' => 'a.orynko@gmail.com' }
 
  s.platform = :ios, '10.0'
  
  s.ios.deployment_target = '10.0'
  
  s.source       = { :git => 'https://github.com/gorillka/BRIck.git', :tag => s.version.to_s }
  s.source_files  = 'Sources/BRIck/*.h', 'Sources/BRIck/**/*.swift'

  s.swift_version = '5.1'
  

end
