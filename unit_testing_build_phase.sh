echo "<<UNIT_TEST_MARKER>>"
test_bundle_path="$BUILT_PRODUCTS_DIR/$PRODUCT_NAME.$WRAPPER_EXTENSION"
environment_args="--setenv DYLD_INSERT_LIBRARIES=/../../Library/PrivateFrameworks/IDEBundleInjection.framework/IDEBundleInjection --setenv XCInjectBundle=$test_bundle_path --setenv XCInjectBundleInto=$TEST_HOST"
ios-sim launch $(dirname $TEST_HOST) $environment_args --args -SenTest All $test_bundle_path
echo "<<UNIT_TEST_MARKER>>"
