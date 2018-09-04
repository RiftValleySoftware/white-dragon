Pod::Spec.new do |spec|
    spec.name                       = 'WhiteDragon'
    spec.summary                    = 'An iOS Framework that provides a driver-level interaction with A BAOBAB Server.'
    spec.description                = 'The White Dragon iOS Framework is a Swift shared framework designed to allow easy development of iOS Great Rift Valley Platform apps. It completely abstracts the connection to BAOBAB Servers, including administration functions.'
    spec.version                    = '1.0.0'
    spec.platform                   = :ios, '10.0'
    spec.homepage                   = 'https://littlegreenviper.com'
    spec.social_media_url           = 'https://twitter.com/LilGreenViper'
    spec.author                     = { 'Little Green Viper Software Development LLC' => 'chris@littlegreenviper.com' }
    spec.documentation_url          = 'https://littlegreenviper.com'
    spec.license                    = { :type => 'MIT', :file => 'LICENSE' }
    spec.source                     = { :git => 'https://github.com/LittleGreenViper/white-dragon.git', :tag => spec.version.to_s }
    spec.source_files               = 'WhiteDragon/Framework Project/Classes/**/*'
    spec.dependency                'SwiftLint', '~> 0.24'
end

