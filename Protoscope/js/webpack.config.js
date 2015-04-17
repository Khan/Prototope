var webpack = require("webpack");

module.exports = {
    context: __dirname,
    entry: "./main.js",
    output: {
        path: __dirname + "/dist",
        filename: "protoscope-bundle.js",
        library: "Protoscope"
    },
    module: {
        noParse: /\/node_modules\/babel-core\/browser.js$/
    },
    node: {
        fs: "empty"
    }
};
