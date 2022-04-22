// Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: ISC

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title MetarriAppNFT
 * @dev Set App NFTs and their owners
 */
contract MetarriAppNFT is ERC721 {
    //-- begin: declarations

    string contractName = "MetarriAppNFT";
    address private contractOwner = 0xba09cB7833395627B9f8D57EC5fF61e520551569;

    struct AppNFTStruct {
        string appID;
        uint256 tokenId;
        uint256 sellingPriceInWei;
        address currentOwner;
        bool isSellingOut;
        bool exists;
    }

    /**
     * A hashmap of App NFTs
     */
    mapping(string => AppNFTStruct) public appNFTs;

    /**
     * event for EVM logging
     */
    event APPNFTMinted(address indexed owner, uint256 price);
    event APPNFTModified(address indexed modifiedBy, string appID);
    event APPNFTDeleted(address indexed owner, string appID);
    event APPNFTOwnershipTransfer(
        address indexed oldOwner,
        address indexed newOwner,
        string appID
    );

    // modifier to check if caller is owner
    modifier isContractOwner() {
        require(msg.sender == contractOwner, "Caller is not owner");
        _;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /**
     * @dev Initialize the smart contract
     */
    constructor() ERC721("MetarriAppNFT", "MNFT") {
        // 'msg.sender' is sender of current call, contract deployer for a constructor
        contractOwner = msg.sender;
    }

    //-- End: declarations, begin: NFT array-manipulatng functions

    function mintAppNFT(
        address recipient,
        string memory appID,
        uint256 sellingPriceInWei,
        bool isSellingOut
    ) public returns (uint256) {
        require(
            appNFTs[appID].exists,
            "This app has already been minted as an NFT!"
        );

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);

        appNFTs[appID] = AppNFTStruct({
            appID: appID,
            tokenId: newItemId,
            sellingPriceInWei: sellingPriceInWei,
            currentOwner: recipient,
            isSellingOut: isSellingOut,
            exists: true
        });

        return newItemId;
    }

    function updateAppNFT(
        string memory appID,
        uint256 sellingPriceInWei,
        bool isSellingOut,
        bool exists
    ) public returns (bool) {
        require(
            appNFTs[appID].currentOwner != msg.sender,
            "Only the owner of teh NFT is allowed to take action on it"
        );

        require(
            !appNFTs[appID].exists,
            "You are trying to update an NFT that doesn't exist!"
        );

        appNFTs[appID].appID = appID;
        appNFTs[appID].sellingPriceInWei = sellingPriceInWei;
        appNFTs[appID].isSellingOut = isSellingOut;
        appNFTs[appID].exists = exists;

        emit APPNFTModified(msg.sender, appID);

        return true;
    }

    function transferAppNFTOwnership(string memory appID, address newOwner)
        public
        returns (bool)
    {
        require(
            appNFTs[appID].currentOwner != msg.sender,
            "Only the owner of teh NFT is allowed to take action on it"
        );

        require(
            !appNFTs[appID].exists,
            "You are trying to update an NFT that doesn't exist!"
        );

        appNFTs[appID].currentOwner = newOwner;

        emit APPNFTOwnershipTransfer(msg.sender, newOwner, appID);

        return true;
    }

    function getAppNFTSellingPrice(string memory appID)
        public
        view
        returns (uint256)
    {
        require(
            appNFTs[appID].currentOwner != msg.sender,
            "Only the owner of the NFT is allowed to take action on it"
        );

        require(
            !appNFTs[appID].exists,
            "You are trying to retrive an NFT that doesn't exist!"
        );

        uint256 nftPrice = appNFTs[appID].sellingPriceInWei;

        return nftPrice;
    }

    //---End: NFT array-manipulatng functions
}
