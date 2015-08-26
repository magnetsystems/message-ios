# Taken from https://github.com/priteshshah1983/StaticLibDemo.git

def xcodebuild(sdk, archs, iphoneos_deployment_target, products_dir)
  library_search_paths = "$(inherited) \"$(PROJECT_DIR)/Pods/build-$(CURRENT_ARCH)\""
  if archs == 'armv7 armv7s'
    library_search_paths = "$(inherited) \"$(PROJECT_DIR)/Pods/build-arm\""
  end
  sh "xcodebuild -workspace 'MMX.xcworkspace' -scheme 'MMX' -configuration 'Release' -sdk '#{sdk}' clean build ARCHS='#{archs}' VALID_ARCHS='#{archs}' IPHONEOS_DEPLOYMENT_TARGET='#{iphoneos_deployment_target}' TARGET_BUILD_DIR='#{products_dir}' BUILT_PRODUCTS_DIR='#{products_dir}' LIBRARY_SEARCH_PATHS='#{library_search_paths}'| xcpretty --color; exit ${PIPESTATUS[0]}"
end

desc "Build arm"
task :build_arm do
  xcodebuild('iphoneos', 'armv7 armv7s', '7.0', 'build-arm')
end

desc "Build arm64"
task :build_arm64 do
  xcodebuild('iphoneos', 'arm64', '7.0', 'build-arm64')
end

desc "Build i386"
task :build_i386 do
  xcodebuild('iphonesimulator', 'i386', '7.0', 'build-i386')
end

desc "Build x86_64"
task :build_x86_64 do
  xcodebuild('iphonesimulator', 'x86_64', '7.0', 'build-x86_64')
end

desc "Build fat"
task :build_fat => [:build_arm, :build_arm64, :build_i386, :build_x86_64] do

  FRAMEWORK_VERSION = "A"
  FRAMEWORK_NAME = "MMX"
  STATIC_LIB_NAME = "libMMX.a"
  INSTALL_DIR = "#{FRAMEWORK_NAME}.framework"
  BUNDLE_DIR = "#{FRAMEWORK_NAME}.bundle"

  # Creates the final product folder.
  sh "mkdir -p #{BUNDLE_DIR}"
  sh "mkdir -p #{INSTALL_DIR}"
  sh "mkdir -p #{INSTALL_DIR}/Versions"
  sh "mkdir -p #{INSTALL_DIR}/Versions/#{FRAMEWORK_VERSION}"
  sh "mkdir -p #{INSTALL_DIR}/Versions/#{FRAMEWORK_VERSION}/Headers"

  # Creates the internal links.
  # It MUST use relative paths, otherwise will not work when the folder is copied/moved.
  sh "ln -s #{FRAMEWORK_VERSION} #{INSTALL_DIR}/Versions/Current"
  sh "ln -s Versions/Current/Headers #{INSTALL_DIR}/Headers"
  sh "ln -s Versions/Current/#{FRAMEWORK_NAME} #{INSTALL_DIR}/#{FRAMEWORK_NAME}"

  # Copy binary
  sh "lipo -create ./build-arm/#{STATIC_LIB_NAME} ./build-arm64/#{STATIC_LIB_NAME} ./build-i386/#{STATIC_LIB_NAME} ./build-x86_64/#{STATIC_LIB_NAME} -output #{INSTALL_DIR}/Versions/Current/#{FRAMEWORK_NAME}"
  # Copy Headers
  sh "rm -rf #{INSTALL_DIR}/Versions/Current/Headers/*"
  sh "cp -Rv ./build-arm64/include/#{FRAMEWORK_NAME}/* #{INSTALL_DIR}/Versions/Current/Headers"
  sh "lipo -info #{INSTALL_DIR}/Versions/Current/#{FRAMEWORK_NAME}"
  sh "cp -Rv ./build-arm64/MMX.bundle/* #{BUNDLE_DIR}"
end

desc "Create Documentation"
task :doc do
  sh "mkdir -p tempheaders"
  sh "cp ./Source/Public/MMX.h ./tempheaders/MMX.h"
  sh "cp ./Source/Public/MMXChannel.h ./tempheaders/MMXChannel.h"
  sh "cp ./Source/Public/MMXInvite.h ./tempheaders/MMXInvite.h"
  sh "cp ./Source/Public/MMXInviteResponse.h ./tempheaders/MMXInviteResponse.h"
  sh "cp ./Source/Public/MMXMessage.h ./tempheaders/MMXMessage.h"
  sh "cp ./Source/Public/MMXMessageTypes.h ./tempheaders/MMXMessageTypes.h"
  sh "cp ./Source/Public/MMXNotificationConstants.h ./tempheaders/MMXNotificationConstants.h"
  sh "cp ./Source/Public/MMXRemoteNotification.h ./tempheaders/MMXRemoteNotification.h"
  sh "cp ./Source/Public/MMXUser.h ./tempheaders/MMXUser.h"
  sh 'appledoc .'
  sh '[ -d Documentation ] || mkdir Documentation'
  sh 'cp -fR ~/Library/Developer/Shared/Documentation/DocSets/com.magnet.iOS.MagnetMessage.docset/Contents/Resources/Documents/ ./Documentation/'
  sh 'rm -rf tempheaders'
end

desc "Clean"
task :clean do
  sh 'rm -rf Build'
  sh 'rm -rf build-*'
  sh 'rm -rf Pods/build-*'
end

desc "Clean binary"
task :distclean => [:clean] do
  sh 'rm -rf MMX.framework'
  # sh 'rm -rf libMMX.a'
  sh 'rm -rf MMX.bundle'
end

desc "Run tests"
task :test do
  sh "xcodebuild -workspace 'MMX.xcworkspace' -scheme 'MMX' -sdk 'iphonesimulator' test | xcpretty --test --color --report junit; exit ${PIPESTATUS[0]}"
end

task :default => [:distclean, :build_fat]
