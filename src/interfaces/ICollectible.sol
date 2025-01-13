// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface ICollectible {
    function ownerOf(uint256 tokenId) external view returns (address owner);

    function getApproved(
        uint256 tokenId
    ) external view returns (address operator);

    function transferFrom(address from, address to, uint256 tokenId) external;

    function mint(uint256 quantity,address token) external;

    function totalSupply() external returns (uint);

    function setApprovalForAll(address operator, bool approved) external;

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);

    function mintAsFreeMinter(uint256 quantity) external;

}