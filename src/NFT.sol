// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

error ZeroAddress();
error EmptyURI();

contract PROJECT is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {
    /**
     * @dev Private variable to track the number of tokens minted.
     */
    uint256 private _tokenIds;

    mapping(uint256 => uint256) public nftToNGO; // Mapping to store NFT ID against NGO registration numbers
    mapping(uint256 => uint256[]) public ngoToNFTs; // Mapping to store NFT IDs against NGO registration numbers
    mapping(uint256 => uint256) public nft_To_Max_Donations; // Mapping to store maximum donation for a single project
    mapping(uint256 => uint256) public nft_To_Donation;

    constructor() ERC721("PROJECT", "PRJ") Ownable(msg.sender) {}

    event campaignCreated(
        string tokenURI,
        address owner,
        uint256 registrationNo,
        uint256 tokenId
    );

    function createCampaign(
        string memory _tokenURI,
        uint256 registrationNo,
        uint256 _max_donation
    ) external returns (uint256) {
        if (!(msg.sender != address(0))) {
            revert ZeroAddress();
        }
        if (!(bytes(_tokenURI).length > 0)) {
            revert EmptyURI();
        }
        _tokenIds++;
        nftToNGO[_tokenIds] = registrationNo;
        ngoToNFTs[registrationNo].push(_tokenIds); // Store the NFT ID in the array associated with the NGO registration number

        _mint(msg.sender, _tokenIds);
        _setTokenURI(_tokenIds, _tokenURI);

        nft_To_Max_Donations[_tokenIds] = _max_donation * (10 ** 18);

        emit campaignCreated(_tokenURI, msg.sender, registrationNo, _tokenIds);
        return _tokenIds;
    }

    function makeDonations(uint256 _campaignId) public payable {
        require(msg.value > 0, "Donations amount must be greater than zero");

        require(
            nft_To_Donation[_campaignId] + msg.value <=
                nft_To_Max_Donations[_campaignId],
            "The donation amount exceded"
        );
        nft_To_Donation[_campaignId] += msg.value;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}
