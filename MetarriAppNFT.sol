// Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: ISC

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MetarriAppNFT
 * @dev Set App NFTs and their owners
 */
contract MetarriAppNFT is ERC721, Ownable {
    //-- begin: declarations

    string contractName = "MetarriAppNFT";
    address private contractOwner = 0xba09cB7833395627B9f8D57EC5fF61e520551569;

    struct AppNFTStruct {
        string appID;
        uint256 tokenId;
        uint256 sellingPrice;
        address owner;
        bool isSellingOut;
    }

    /**
     * An array of all the app NFTs
     */
    AppNFTStruct[] public appsAndOwners;

    /**
     * event for EVM logging
     */
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    event APPNFTAdded(address indexed owner, uint256 price);

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
        emit OwnerSet(address(0), contractOwner);
    }

    //-- End: declarations, begin: NFT array-manipulatng functions

    function mintAppNFT(address recipient, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);

        return newItemId;
    }

    function updateAppNFT(string memory appID) public returns (bool) {
        return true;
    }

    function getAppNFTData(string memory appID) public returns (bool) {
        return true;
    }

    function revokeAppNFT() public returns (bool) {
        return true;
    }

    //---End: NFT array-manipulatng functions, begin: Contract Ownership functions

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     * @return address of the new owner
     */
    function setContractOwner(address newOwner)
        public
        isContractOwner
        returns (address)
    {
        emit OwnerSet(contractOwner, newOwner);
        contractOwner = newOwner;

        return newOwner;
    }

    /**
     * @dev Returns owner address
     * @return address of owner
     */
    function getContractOwner() public view returns (address) {
        return contractOwner;
    }

    function terminateOwnership() public isContractOwner returns (bool) {
        return true;
    }

    //-- End: Contract Ownership functions
    
}
