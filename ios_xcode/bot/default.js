var path = require("path");

module.exports = {

    "options": {
        "xcodeProject": { "!valueType": "string", "!defaultValue": "libchan" }
    },

    "build": [

        [ 
            "xcodebuild", 
            "ONLY_ACTIVE_ARCH=NO", 
            "ARCHS=armv7 armv7s arm64", 
            "CONFIGURATION_BUILD_DIR=${build()}",
            "PROJECT_TEMP_DIR=${build()}",
            "PRODUCT_NAME=libchan-iphoneos", 
            "ENABLE_BITCODE=YES",
            "BITCODE_GENERATION_MODE=bitcode",
            "EXECUTABLE_PREFIX=",
            "-project", "${xcodeProject}.xcodeproj", 
            "-target", "${xcodeProject}", 
            "-configuration", "Release", 
            "-sdk", "iphoneos",
            "build"
        ],

        [ 
            "xcodebuild", 
            "ONLY_ACTIVE_ARCH=NO", 
            "ARCHS=i386 x86_64", 
            "CONFIGURATION_BUILD_DIR=${build()}",
            "PROJECT_TEMP_DIR=${build()}",
            "PRODUCT_NAME=libchan-iphonesimulator", 
            "ENABLE_BITCODE=YES",
            "BITCODE_GENERATION_MODE=bitcode",
            "EXECUTABLE_PREFIX=",
            "-project", "${xcodeProject}.xcodeproj", 
            "-target", "${xcodeProject}", 
            "-configuration", "Release", 
            "-sdk", "iphonesimulator",
            "build"
        ],

        [
            "libtool", 
            "-o", "${build('libchan.a')}", 
            "${build('libchan-iphoneos.a')}", 
            "${build('libchan-iphonesimulator.a')}"
        ],

        [ "mkdir", "-p", "${dist('include')}", "${dist('res')}", "${dist('lib')}" ],

        ((options) => {
            return @.async.all([
                "libchan/QRViewController.xib"
            ], function (item) {

                @.task.execute("xcrun", 
                    [ 
                        "ibtool", 
                        "--compile", 
                        path.resolve(options.path, "dist/res", path.basename(item, path.extname(item)) + ".nib"), 
                        item
                    ], 
                    true, 
                    this.test);

            });
        }),

        ((options) => {
            return @.async.all([], function (item) {

                @.task.execute("xcrun", 
                    [ 
                        "actool",
                        "--output-format", "human-readable-text",
                        "--notices",
                        "--warnings",
                        "--platform", "iphoneos",
                        "--minimum-deployment-target", "iphoneos8.0",
                        "--compile", 
                        path.resolve(options.path, "dist/res"), 
                        item
                    ], 
                    true, 
                    this.test);

            });
        })

    ],

    "dist": {
        "lib/libchan.a": "${build('libchan.a')}",
        "include": "!",
        "res": "res",
        "post":"post"
    }
    
};