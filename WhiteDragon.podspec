Pod::Spec.new do |spec|
    spec.name                       = 'WhiteDragon'
    spec.summary                    = 'A Cocoa Framework that Provides an Application-Level Interaction With a BAOBAB Server.'
    spec.description                = 'The White Dragon Cocoa Framework is a Swift shared framework designed to allow easy development of iOS/MacOS Great Rift Valley Platform apps. It completely abstracts the connection to BAOBAB Servers, including administration functions.'
    spec.version                    = '1.0.0.1000'
    spec.ios.deployment_target      = '11.0'
    spec.osx.deployment_target      = '10.11'
    spec.homepage                   = 'https://littlegreenviper.com'
    spec.social_media_url           = 'https://twitter.com/LilGreenViper'
    spec.author                     = { 'The Great Rift Valley Software Company' => 'chris@littlegreenviper.com' }
    spec.documentation_url          = 'https://littlegreenviper.com'
    spec.license                    = { :type => 'MIT', :file => 'LICENSE.txt' }
    spec.source                     = { :git => 'https://github.com/LittleGreenViper/white-dragon.git', :tag => spec.version.to_s }
    spec.source_files               = 'WhiteDragon/Classes/**/*'
end

