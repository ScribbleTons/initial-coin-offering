//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {
    //price of one crypto dev token
    uint256 public constant tokenPrice = 0.001 ether;

    //token per NFT
    uint256 public constant tokenPerNFT = 10 * 10**18;

    //total supply of tokens
    uint256 public constant maxTotalSupply = 10000 * 10**18;

    //Crypto Dev NFT contract instance
    ICryptoDevs CryptoDevsNFT;

    //mapping to keep track of claimed tokens
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsNFT) ERC20("Crypto Dev Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsNFT);
    }

    //Mint amount, number, of token- to CryptoDevTokens
    //msg.value should be equal or greater than tokenPrice * amount

    function mint(uint256 amount) public payable {
        //the value of the ether should be equal or greater than token price
        uint256 _requiredAmount = tokenPrice * amount;
        require(
            msg.value >= _requiredAmount,
            "Not enough ether to mint tokens"
        );

        //mint the token if the amount sent is less than maxTotalSupply, else revert
        uint256 amountWithDecimals = amount * 10**18;
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply,
            "Exceeds the max total supply"
        );

        //call the internal function to mint the token
        _mint(msg.sender, amountWithDecimals);
    }

    /**
     * @dev Mints tokens based on the number of NFT's held by the sender
     * Requirements:
     * balance of Crypto Dev NFT's owned by the sender should be greater than 0
     * Tokens should have not been claimed for all the NFTs owned by the sender
     */
    function claim() public {
        address sender = msg.sender;

        //get the number of Crypto Dev NFT's owned by the sender
        uint256 balance = CryptoDevsNFT.balanceOf(sender);


        //if balance is zero, revert the transaction
        require(balance > 0, "You don't own any Crypto Dev NFTs");

        //keep track of unclaimed token
        uint256 amount = 0;

        //loop through all the NFT's owned by the sender
        for (uint256 i = 0; i < balance; i++) {
            //get the token ID of the NFT
            uint256 tokenId = CryptoDevsNFT.tokenByOwnerByIndex(sender, i);

            //if the token has not been claimed, claim it
            if (!tokenIdsClaimed[tokenId]) {
                amount++;
                tokenIdsClaimed[tokenId] = true;
            }
        }

        //if all the token Ids have been claimed, revert transaction
        require(amount > 0, "You have already claimed all the tokens");

        //mint the tokens
        _mint(sender, amount * tokenPerNFT);
    }

    //function to receive Ether. msg.data must be empty
    receive() external payable {}

    //Fallback function us called when msg.data is not empty
    fallback() external payable {}
}
