const { readFileSync } = require("fs");
// eslint-disable-next-line node/no-missing-require
const solgraph = require("solgraph");

try {
  const solgraphDataDot = solgraph(readFileSync("contracts/MyEpicGame.sol"));
  console.log(solgraphDataDot);
} catch (err) {
  console.log("some error while reading the file ", err);
}
