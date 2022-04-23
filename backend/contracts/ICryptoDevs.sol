//SPDX-License-Identifier: MIT

pragma solidity  ^0.8.0;


interface ICryptoDevs {
   
   //returns token ID owned by caller at index
   function tokenByOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId);


   //returns the number of tokens owned by caller
    function balanceOf(address _owner) external view returns (uint256 _balance);
}