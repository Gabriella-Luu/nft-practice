const Web3 = require('web3')
const web3 = new Web3('http://127.0.0.1:7545')

const nftBuild = require('../build/contracts/NFT.json')
const nftContract = new web3.eth.Contract(nftBuild.abi, nftBuild.networks[5777].address)

const amountToMint = 1
const gas = 450000

const main = async () => {
    const allAccount = await web3.eth.getAccounts()

    console.log(`Attempting to mint NFT for ${allAccount[0]}...\n`)

    var tokenId = []
    var sum = 0
    tokenId[sum++] = await nftContract.methods.mintNFT(allAccount[0], `ipfs://QmThdTBCR8DsnXMViDGC13EH9NughYzJrk7VjaAsRBmhX8/1.jpg`).send({ from: allAccount[0], value: 0, gas: gas })
    tokenId[sum++] = await nftContract.methods.mintNFT(allAccount[0], `ipfs://QmThdTBCR8DsnXMViDGC13EH9NughYzJrk7VjaAsRBmhX8/2.jpg`).send({ from: allAccount[0], value: 0, gas: gas })
    tokenId[sum++] = await nftContract.methods.mintNFT(allAccount[1], `ipfs://QmThdTBCR8DsnXMViDGC13EH9NughYzJrk7VjaAsRBmhX8/3.jpg`).send({ from: allAccount[1], value: 0, gas: gas })
    tokenId[sum++] = await nftContract.methods.mintNFT(allAccount[1], `ipfs://QmThdTBCR8DsnXMViDGC13EH9NughYzJrk7VjaAsRBmhX8/4.jpg`).send({ from: allAccount[1], value: 0, gas: gas })
    tokenId[sum++] = await nftContract.methods.mintNFT(allAccount[1], `ipfs://QmThdTBCR8DsnXMViDGC13EH9NughYzJrk7VjaAsRBmhX8/5.jpg`).send({ from: allAccount[1], value: 0, gas: gas })

    for (var j = 0; j < allAccount.length; j++){
        const totalMinted = await nftContract.methods.walletOfOwner(allAccount[j]).call()
        console.log(`Total NFTs minted for account ${j}: ${totalMinted.length}`)
        for (var i = 0; i < totalMinted.length; i++) {
            const uri = await nftContract.methods.tokenURI(totalMinted[i]).call()
            console.log(`Metadata URI for token ${totalMinted[i]}: ${uri}`)
        }
        console.log(`\n`)
    }

    await nftContract.methods.like(allAccount[0], tokenId[3]);
    await nftContract.methods.like(allAccount[1], tokenId[0]);
    await nftContract.methods.like(allAccount[1], tokenId[2]);
    await nftContract.methods.like(allAccount[6], tokenId[2]);
    await nftContract.methods.dislike(allAccount[4], tokenId[3]);
    await nftContract.methods.dislike(allAccount[1], tokenId[0]);
    await nftContract.methods.dislike(allAccount[1], tokenId[2]);

    for (var j = 0; j < allAccount.length; j++){
        const totalMinted = await nftContract.methods.walletOfOwner(allAccount[j]).call()
        console.log(`Total NFTs minted for account ${j}: ${totalMinted.length}`)
        for (var i = 0; i < totalMinted.length; i++) {
            const likes = await nftContract.methods.getLikeCount(totalMinted[i]).call()
            const dislikes = await nftContract.methods.getDislikeCount(totalMinted[i]).call()
            console.log(`likes for token ${totalMinted[i]}\t: ${likes}`)
            console.log(`dislikes for token ${totalMinted[i]}\t: ${dislikes}`)
        }
        console.log(`\n`)
    }
}

main()