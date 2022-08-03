PRODUCT_NAME := FluxGithubApp
PROJECT_FILE_NAME := ${PRODUCT_NAME}.xcodeproj

# Initialize Set Up
.PHONY: setup
setup:
	$(MAKE) mint-install
	$(MAKE) generate-xcodeproj

# Install mint packages
.PHONY: mint-install
mint-install:
	mint bootstrap --overwrite y

# Generate project with XcodeGen
.PHONY: generate-xcodeproj
generate-xcodeproj:
	mint run xcodegen xcodegen generate
	
# Run swiftformat
.PHONY: swiftformat
swiftformat:
	mint run SwiftFormat swiftformat .
	
# Run xcconfig-extractor
.PHONY: xcconfig-extractor
xcconfig-extractor:
	mint run xcconfig-extractor ./${PROJECT_FILE_NAME} configs
