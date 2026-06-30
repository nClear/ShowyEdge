all:
	/usr/bin/python3 ../scripts/update_version.py
	bash run-xcodegen.sh
	xcodebuild -configuration Release -alltargets SYMROOT="$(CURDIR)/build"
	$(MAKE) codesign
	$(MAKE) -C .. clean-launch-services-database

clean: purge-swift-package-manager-cache
	rm -rf ShowyEdge.xcodeproj
	rm -rf build

codesign:
# Swift runtime
	if [ -e build/Release/ShowyEdge.app/Contents/Frameworks/libswiftCompatibilitySpan.dylib ]; then bash ../scripts/codesign.sh build/Release/ShowyEdge.app/Contents/Frameworks/libswiftCompatibilitySpan.dylib; fi
# Sparkle
	if [ -e build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework/Versions/B/XPCServices/Installer.xpc ]; then bash ../scripts/codesign.sh build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework/Versions/B/XPCServices/Installer.xpc; fi
	if [ -e build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework/Versions/B/XPCServices/Downloader.xpc ]; then bash ../scripts/codesign.sh build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework/Versions/B/XPCServices/Downloader.xpc $(CURDIR)/org.sparkle-project.Downloader.entitlements; fi
	if [ -e build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework/Versions/B/Autoupdate ]; then bash ../scripts/codesign.sh build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework/Versions/B/Autoupdate; fi
	if [ -e build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework/Versions/B/Updater.app ]; then bash ../scripts/codesign.sh build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework/Versions/B/Updater.app; fi
	if [ -e build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework ]; then bash ../scripts/codesign.sh build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework; fi
# ShowyEdge
	bash ../scripts/codesign.sh build/Release/ShowyEdge.app $(CURDIR)/ShowyEdge/ShowyEdgeTextPill.entitlements

purge-swift-package-manager-cache:
	rm -rf ~/Library/Developer/Xcode/DerivedData/ShowyEdge-*
	rm -rf ~/Library/Caches/org.swift.swiftpm/repositories/Sparkle-*

xcode:
	open ShowyEdge.xcodeproj

run:
	open build/Release/ShowyEdge.app

swift-format:
	find . -name '*.swift' -print0 | xargs -0 swift-format -i

install:
	rsync -a --delete build/Release/ShowyEdge.app /Applications
