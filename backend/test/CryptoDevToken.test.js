const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CryptoDevToken", function () {
  let cryptoDevToken;
  beforeEach(async () => {
    const CryptoDevToken = await ethers.getContractFactory("CryptoDevToken");
    cryptoDevToken = await CryptoDevToken.deploy(
      "0x45088f180be6ef79d06a86085401bbeea67b7fc6"
    );
  });

  it("should deploy a CryptoDevToken contract", async () => {
    expect(cryptoDevToken.address).to.be.a("string");
    expect(cryptoDevToken.address).not.to.be.equal("0x0");
  });

  it("should have a name Crypto Dev Token", async () => {
    const name = await cryptoDevToken.name();
    expect(name).to.be.a("string");
    expect(name).to.be.equal("Crypto Dev Token");
  });

  it("should have a symbol CD", async () => {
    const symbol = await cryptoDevToken.symbol();
    expect(symbol).to.be.a("string");
    expect(symbol).to.be.equal("CD");
  });

  it("should have maximum supply of 10000*10**18", async () => {
    const maxSupply = await cryptoDevToken.maxTotalSupply();
    const supply = ethers.utils.formatEther(maxSupply);
    expect(supply).to.be.equal("10000.0");
  });

  it("Should not allow none holder of Crypto Dev NFT to claim token", async () => {
    const tx = await cryptoDevToken.claim();
    await tx.wait();
    expect.fail(tx);
  });
});
