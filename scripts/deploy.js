const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('Dangerous')
    const dangerousContract = await nftContractFactory.deploy()
    await  dangerousContract.deployed()
    console.log('Dangerous Contract deployed to: ', dangerousContract.address)

    for (let i = 1; i <= 2; i++) {
        let transaction = await dangerousContract.mintDangerousNFT()
        await transaction.wait()
        console.log(`Minted NFT # ${i}`)
    }
}

const runMain = async () => {
    try {
        await main()
        process.exit(0)
    } catch (e) {
        console.log(e)
        process.exit(1)
    }
}

runMain().then()
