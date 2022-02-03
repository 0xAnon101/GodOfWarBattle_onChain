const main = async () => {
  const myEpicGameContractFactory = await hre.ethers.getContractFactory(
    "GodOfWarBattle"
  );

  const CHARDATA_NAME = [
    "Angel Pepe",
    "Devil Pepe",
    "Doctor Pepe",
    "Hulk Pepe",
    "Robot Pepe",
    "Transformer Pepe",
  ]; // character names
  const CHARDATA_URI = [
    "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/angel_pepe.png", // Images
    "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/devil_pepe.png",
    "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/doctor_pepe.png",
    "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/hulk_pepe.png",
    "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/robot_pepe.png",
    "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/transformer_pepe.png",
  ]; // characters URI
  const CHARDATA_HP = [100, 200, 50, 150, 125, 300]; // HP values
  const CHARDATA_DMG = [90, 100, 60, 100, 90, 150]; // Attack damage values
  const CHARDATA_SUPERDMG = [
    90 + 30,
    100 + 30,
    60 + 30,
    100 + 30,
    90 + 30,
    150 + 30,
  ]; // super attack damage
  const CHARDATA_DEFENSE = [10, 15, 5, 17, 13, 20]; // defense shield

  // Deploy the contract with character and boss data
  const myEpicGame = await myEpicGameContractFactory.deploy(
    CHARDATA_NAME,
    CHARDATA_URI,
    CHARDATA_HP,
    CHARDATA_DMG,
    CHARDATA_SUPERDMG,
    CHARDATA_DEFENSE,
    "Dragon Pepe", // boss name
    "https://bafybeiarybsu5yljlnvzgr36iokr2hhz3dldiaqvmdtu6wwrvu6bthtymy.ipfs.dweb.link/", // boss URI
    "5000", // boss HP value
    "50" // boss attack damage value
  );

  await myEpicGame.deployed();
  console.log(`MyEpicGame contract deployed to:  ${myEpicGame.address}`);

  let txn = await myEpicGame.mintCharacterNFT(0);
  await txn.wait();
  console.log("Minted NFT #1");

  txn = await myEpicGame.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #2");

  txn = await myEpicGame.mintCharacterNFT(2);
  await txn.wait();
  console.log("Minted NFT #3");

  txn = await myEpicGame.mintCharacterNFT(3);
  await txn.wait();
  console.log("Minted NFT #4");

  txn = await myEpicGame.mintCharacterNFT(4);
  await txn.wait();
  console.log("Minted NFT #5");

  txn = await myEpicGame.mintCharacterNFT(5);
  await txn.wait();
  console.log("Minted NFT #6");

  // caller attacking boss
  // txn = await myEpicGame.attackBoss();
  // await txn.wait();

  // txn = await myEpicGame.attackBoss();
  // await txn.wait();

  // Get the value of the NFT's URI.
  const returnedTokenUri = await myEpicGame.tokenURI(1);
  console.log("Token URI:", returnedTokenUri);
};

// function randomInteger(min, max) {
//   return Math.floor(Math.random() * (max - min + 1)) + min;
// }

const runMain = async () => {
  try {
    await main();
    // process.exit(0);
  } catch (err) {
    console.log(err);
    // process.exit(1);
  }
};

runMain();
