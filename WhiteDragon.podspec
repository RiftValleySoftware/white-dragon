Pod::Spec.new do |spec|
    spec.name                       = 'White Dragon Cocoa SDK'
    spec.summary                    = 'A Cocoa Framework that Provides an Application-Level Interaction With a BAOBAB Server.'
    spec.description                = 'The White Dragon Cocoa Framework is a Swift shared framework designed to allow easy development of iOS/MacOS Great Rift Valley Platform apps. It completely abstracts the connection to BAOBAB Servers, including administration functions.'
    spec.version                    = '1.0.0'
    spec.platform                   = :ios, '10.0'
    spec.homepage                   = 'https://riftvalleysoftware.com'
    spec.social_media_url           = 'https://twitter.com/LilGreenViper'
    spec.author                     = { 'The Great Rift Valley Software Company' => 'chris@littlegreenviper.com' }
    spec.documentation_url          = 'https://riftvalleysoftware.com'
    spec.license                    = { :type => 'MIT', :file => 'LICENSE' }
    spec.source                     = { :git => 'https://github.com/LittleGreenViper/white-dragon.git', :tag => spec.version.to_s }
    spec.source_files               = 'WhiteDragon/Classes/**/*'
    spec.dependency                'SwiftLint', '~> 0.24'
end

