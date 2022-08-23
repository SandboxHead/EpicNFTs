const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("You deployed the Contract at:", nftContract.address);

    let txn = await nftContract.makeAnEpicNFT();
    await txn.wait();

    let totalNFTs = await nftContract.getMintedNFTs();
    console.log("Total NFTs :", totalNFTs)

    txn = await nftContract.makeAnEpicNFT();
    await txn.wait();

    totalNFTs = await nftContract.getMintedNFTs();
    console.log("Total NFTs :", totalNFTs)

};

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    } catch(error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();