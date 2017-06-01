var fs = require("fs");
var path = require("path");

var postprocess = function(chanPath, options) {

    return @.async(function() {

        @.task.execute("plutil", [
            "-convert",
            "json",
            path.resolve(chanPath, options.projectFile, "ioschan/Info.plist"),
            "-o",
            path.resolve(chanPath, options.projectFile, "ioschan/Info.plist.json")
        ], this.test);

    }).then(function() {

        fs.readFile(path.resolve(chanPath, options.projectFile, "ioschan/Info.plist.json"), (error, content) => {

            if (error) {
                this.reject(error);
            } else {

                var config = null;
                try {
                    config = JSON.parse(content.toString("utf8"));
                } catch (error) {
                    this.reject(error);
                    return;
                }

                config["NSLocationWhenInUseUsageDescription"] = "NSLocationAlwaysUsageDescription";
                config["NSCameraUsageDescription"] = "访问相机";
                config["NSPhotoLibraryUsageDescription"] = "访问相册";
                config["NSMicrophoneUsageDescription"] = "访问麦克风";

                fs.writeFile(path.resolve(chanPath, options.projectFile, "ioschan/Info.plist.json"), JSON.stringify(config), this.test);

            }

        });

    }).then(function() {

        @.task.execute("plutil", [
            "-convert",
            "xml1",
            path.resolve(chanPath, options.projectFile, "ioschan/Info.plist.json"),
            "-o",
            path.resolve(chanPath, options.projectFile, "ioschan/Info.plist")
        ], this.test);

    }).then(function() {

        @.fs.deleteFile(path.resolve(chanPath, options.projectFile, "ioschan/Info.plist.json"), this.test);

    });

};

module.exports = {
    "postprocess": postprocess
};
