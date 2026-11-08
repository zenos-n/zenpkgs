import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { stripTypeScriptTypes } from "node:module";
import { runInNewContext } from "node:vm";

// Exercise the actual helper shipped in the package's renderer source map.
const map = JSON.parse(readFileSync(process.argv[2], "utf8"));
const index = map.sources.findIndex(source => source.endsWith("/webpack/patchWebpack.ts"));
assert.notEqual(index, -1, "renderer must include the Webpack patcher");
const source = map.sourcesContent[index];
const match = source.match(/this\.d = (function[\s\S]+?\n            });/);
assert.ok(match, "could not locate the export helper");
const defineExports = runInNewContext(stripTypeScriptTypes(`(${match[1]})`));

const exports = {};
let getterValue = 1;
class Logger {}
defineExports(exports, { getter: () => getterValue }, { Logger, empty: undefined });
assert.equal(exports.getter, 1);
getterValue = 2;
assert.equal(exports.getter, 2, "old getter exports must remain live");
assert.equal(exports.Logger, Logger, "new plain exports must retain their value");
assert.ok(Object.hasOwn(exports, "empty"));
assert.equal(new exports.Logger().constructor, Logger);
assert.equal(Object.getOwnPropertyDescriptor(exports, "Logger").configurable, true);
defineExports(exports, {}, { Logger: "replacement" });
assert.equal(exports.Logger, Logger, "existing exports must not be overwritten");
const valuesOnly = {};
defineExports(valuesOnly, undefined, { Logger });
assert.equal(valuesOnly.Logger, Logger);
defineExports({}, { oldStyle: () => 1 });
console.log("Vencord supports getter and plain-value Webpack exports");
