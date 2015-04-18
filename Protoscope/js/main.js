require("babel-core/polyfill");

var SourceMapConsumer = require("source-map").SourceMapConsumer;
var babel = require("babel-core/browser");

var Protoscope = {
    transform: function(code) {
        var result = babel.transform(code, {sourceMaps: true});

        var sourceMapConsumer;
        function originalSourcePositionFor(line, column) {
            if (!sourceMapConsumer) {
                // Lazily parse source map since we only need it in case of
                // exception
                sourceMapConsumer = new SourceMapConsumer(result.map);
            }
            var position = sourceMapConsumer.originalPositionFor({
                line: line,
                column: column
            });
            return position;
        }

        return {
            code: result.code,
            originalSourcePositionFor: originalSourcePositionFor
        };
    },
    normalizeError: function(rawError, sourceMappers) {
        var normalized = Object.create(Object.getPrototypeOf(rawError));
        normalized.message = rawError.message;
        normalized.line = rawError.line;
        normalized.column = rawError.column;

        if (rawError.sourceURL && sourceMappers[rawError.sourceURL] &&
                rawError.line && rawError.column) {
            var mapper = sourceMappers[rawError.sourceURL];
            if (mapper) {
                var info = mapper(rawError.line, rawError.column);
                normalized.line = info.line;
                normalized.column = info.column;
            }
        }

        if (rawError.stack) {
            normalized.stack = rawError.stack.replace(
                /@([^@]+):(\d+):(\d+)(?=\n|$)/g,
                function(match, file, line, column) {
                    var mapper = sourceMappers[file];
                    if (mapper) {
                        var info = mapper(+line, +column);
                        return "@" + file + ":" + info.line + ":" + info.column;
                    } else {
                        return match;
                    }
                }
            );
        }

        return normalized;
    }
};

module.exports = Protoscope;
