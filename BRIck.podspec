Pod::Spec.new do |s|

  s.name         = 'BRIck'
  s.version      = '1.0.1'
  s.summary      = 'BRIck is mobile architecture.'

  s.description  = <<-DESC
  BRIck is mobile architecture based on RIBs but without RxSwift.
                   DESC

  s.homepage     = 'https://github.com/gorillka/BRIck'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { 'Artem Orynko' => 'a.orynko@gmail.com' }
 
  s.platform = :ios, '10.0'
  
  s.ios.deployment_target = '10.0'
  
  s.source       = { :git => 'https://github.com/gorillka/BRIck.git', :tag => s.version.to_s }
  s.source_files  = 'BRIck/*.h', 'BRIck/**/*.swift'

  s.swift_version = '4.2'
  

end
