const main = async () => {
  const myEpicGameContractFactory = await hre.ethers.getContractFactory(
    "GodOfWarBattle"
  );
  const myEpicGame = await myEpicGameContractFactory.deploy(
    [
      "Angel Pepe",
      "Devil Pepe",
      "Doctor Pepe",
      "Hulk Pepe",
      "Robot Pepe",
      "Transformer Pepe",
    ], // Names
    [
      "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/angel_pepe.png", // Images
      "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/devil_pepe.png",
      "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/doctor_pepe.png",
      "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/hulk_pepe.png",
      "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/robot_pepe.png",
      "https://bafybeif4juhqio5534y6hvhb7flrcgl73mocze4xvf2tkppwaajeppd3ei.ipfs.dweb.link/transformer_pepe.png",
    ],
    [100, 200, 50, 150, 125, 300], // HP values
    [90, 100, 60, 100, 90, 150] // Attack damage values
  );

  await myEpicGame.deployed();
  console.log(`MyEpicGame contract deployed to:  ${myEpicGame.address}`);

  const index = randomInteger(1, 5);

  const txn = await myEpicGame.mintCharacterNFT(index);
  await txn.wait();
};

function randomInteger(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
};

runMain();
