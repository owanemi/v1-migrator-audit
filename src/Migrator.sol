// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import { AccessControlUpgradeable } from "lib/openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import { Initializable } from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import { SafeMathUpgradeable } from "lib/openzeppelin-contracts-upgradeable/contracts/utils/math/SafeMathUpgradeable.sol";
import { IERC20Upgradeable } from "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/IERC20Upgradeable.sol";
import { IERC721Receiver } from "./interfaces/IERC721Receiver.sol";
import { ICollectible } from "./interfaces/ICollectible.sol";

/**
 * @title Migrator
 * @notice Handles migration of ERC20 tokens and ERC721 NFTs from V1 to V2 versions.
 */
contract Migrator is Initializable, AccessControlUpgradeable, IERC721Receiver {
    using SafeMathUpgradeable for uint;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event TokenMigrationCompleted(
        address indexed user,
        address indexed token1,
        address indexed token2,
        uint amount1,
        uint amount2,
        uint date
    );
    event NFTMigrationCompleted(
        address indexed user,
        address indexed nft1,
        address indexed nft2,
        uint oldId,
        uint newId,
        uint date
    );
    event MigrationTokenSet(
        address indexed token1,
        address indexed token2,
        uint indexed price,
        uint date
    );

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error TransactionMessage(string message);

    /*//////////////////////////////////////////////////////////////
                           TYPE DECLARATIONS
    //////////////////////////////////////////////////////////////*/
    struct Requirement {
        address acre;
        address plot;
        address yard;
        address acreV2;
        address plotV2;
        address yardV2;
        address tokenV1;
        address tokenV2;
        uint price;
    }

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    Requirement public Requirements;

    mapping(address => uint) public lastAssetIdMinted;
    mapping(address => uint) public tokensMigrated;

    bytes32 public constant SIGNER_ROLE = keccak256("SIGNER_ROLE");

    /*//////////////////////////////////////////////////////////////
                      EXTERNAL & PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
   /*//////////////////////////////////////////////////////////////
                         INITIALIZATION FUNCTION
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Initializes the contract and sets the default admin role.
     */
    function initialize() external virtual initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        Requirements.price = 1; // Default price for ERC20 migration.
    }

    /**
     * @notice Migrates ERC20 tokens from token1 to token2.
     * @param _amount The amount of token1 to migrate.
     * @param _token1 The address of the source token.
     * @param _token2 The address of the destination token.
     * @return result Whether the migration was successful.
     */
    function migrateERC20Token(
        uint256 _amount,
        address _token1,
        address _token2
    ) external returns (bool result) {
        if (_amount == 0) revert TransactionMessage("Amount is zero");
        if (Requirements.tokenV1 != _token1) revert TransactionMessage("Invalid token1 address");
        if (Requirements.tokenV2 != _token2) revert TransactionMessage("Invalid token2 address");
        if (Requirements.price == 0) revert TransactionMessage("Invalid price set");

        // Verify allowance and balance
        uint allowance = IERC20Upgradeable(_token1).allowance(_msgSender(), address(this));
        if (_amount > allowance) revert TransactionMessage("Insufficient allowance");

        uint balance = IERC20Upgradeable(_token1).balanceOf(_msgSender());
        if (_amount > balance) revert TransactionMessage("Insufficient balance");

        // Calculate the amount of token2 to transfer
        uint tokenBToReceive = Requirements.price.mul(_amount);
        balance = IERC20Upgradeable(_token2).balanceOf(address(this));
        if (tokenBToReceive > balance) revert TransactionMessage("Insufficient token balance on migrator");

        // Perform token transfers
        bool success = IERC20Upgradeable(_token1).transferFrom(_msgSender(), address(this), _amount);
        if (!success) revert TransactionMessage("Transaction failed");

        success = IERC20Upgradeable(_token2).transfer(_msgSender(), tokenBToReceive);
        if (!success) revert TransactionMessage("Transaction failed");

        // Update migration data
        tokensMigrated[_token1] += _amount;
        tokensMigrated[_token2] += tokenBToReceive;

        emit TokenMigrationCompleted(_msgSender(), _token1, _token2, _amount, tokenBToReceive, block.timestamp);
        return true;
    }

    /**
     * @notice Migrates all assets (NFTs) in batch.
     * @param _acre Array of acre token IDs to migrate.
     * @param _plot Array of plot token IDs to migrate.
     * @param _yard Array of yard token IDs to migrate.
     * @return success Whether the migration was successful.
     */
    function migrateAllAsset(
        uint[] memory _acre,
        uint[] memory _plot,
        uint[] memory _yard
    ) external returns (bool success) {
        uint migrateable = _acre.length + _plot.length + _yard.length;
        if (migrateable == 0) revert TransactionMessage("Not enough NFTs to migrate");

        if (_acre.length > 0) {
            _migrateNFTBatch(Requirements.acre, Requirements.acreV2, _acre);
        }

        if (_plot.length > 0) {
            _migrateNFTBatch(Requirements.plot, Requirements.plotV2, _plot);
        }

        if (_yard.length > 0) {
            _migrateNFTBatch(Requirements.yard, Requirements.yardV2, _yard);
        }

        return true;
    }

    /**
     * @notice Confirms the contract's ability to receive ERC721 NFTs.
     * @inheritdoc IERC721Receiver
     */
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    /**
     * @notice Sets the requirements for ERC721 NFT migration.
     * @param _acre Address of the old Acre NFT.
     * @param _yard Address of the old Yard NFT.
     * @param _plot Address of the old Plot NFT.
     * @param _acreV2 Address of the new Acre NFT.
     * @param _yardV2 Address of the new Yard NFT.
     * @param _plotV2 Address of the new Plot NFT.
     * @return success Whether the operation succeeded.
     */
    function setERC721Requirements(
        address _acre,
        address _yard,
        address _plot,
        address _acreV2,
        address _yardV2,
        address _plotV2
    ) external returns (bool success) {
        _onlySigner();
        if (_acre != address(0)) Requirements.acre = _acre;
        if (_yard != address(0)) Requirements.yard = _yard;
        if (_plot != address(0)) Requirements.plot = _plot;
        if (_acreV2 != address(0)) Requirements.acreV2 = _acreV2;
        if (_yardV2 != address(0)) Requirements.yardV2 = _yardV2;
        if (_plotV2 != address(0)) Requirements.plotV2 = _plotV2;

        return true;
    }

    /**
     * @notice Sets the requirements for ERC20 token migration.
     * @param _tokenV1 Address of the old ERC20 token.
     * @param _tokenV2 Address of the new ERC20 token.
     * @param _price Conversion price between old and new tokens.
     */
    function setTokenInfo(
        address _tokenV1,
        address _tokenV2,
        uint _price
    ) external {
        _onlySigner();
        if (_tokenV1 != address(0)) Requirements.tokenV1 = _tokenV1;
        if (_tokenV2 != address(0)) Requirements.tokenV2 = _tokenV2;
        if (_price == 0) revert TransactionMessage("Price must be above zero");

        Requirements.price = _price;
        emit MigrationTokenSet(_tokenV1, _tokenV2, _price, block.timestamp);
    }

    /*//////////////////////////////////////////////////////////////
                    INTERNAL & PRIVATE FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Handles batch migration of NFTs.
     * @param _nft1 Address of the old NFT contract.
     * @param _nft2 Address of the new NFT contract.
     * @param _nfts Array of token IDs to migrate.
     */
    function _migrateNFTBatch(
        address _nft1,
        address _nft2,
        uint[] memory _nfts
    ) internal {
        for (uint i = 0; i < _nfts.length; i++) {
            _withdrawOldNFT(_nft1, _nfts[i]);
        }
        _mintNewNFT(_nft1, _nft2, _msgSender(), _nfts.length, _nfts);
    }

    /**
     * @notice Withdraws an old NFT from the user.
     * @param _nft1 Address of the old NFT contract.
     * @param _tokenId ID of the token to withdraw.
     * @return success Whether the operation succeeded.
     */
    function _withdrawOldNFT(
        address _nft1,
        uint256 _tokenId
    ) private returns (bool success) {
        if (ICollectible(_nft1).ownerOf(_tokenId) != _msgSender())
            revert TransactionMessage("Invalid NFT owner");

        if (!ICollectible(_nft1).isApprovedForAll(_msgSender(), address(this)))
            revert TransactionMessage("Migrator lacks approval");

        ICollectible(_nft1).transferFrom(_msgSender(), address(this), _tokenId);
        return true;
    }

    /**
     * @notice Mints new NFTs for the user during migration.
     * @param _nft1 Address of the old NFT contract.
     * @param _nft2 Address of the new NFT contract.
     * @param _user Address of the user receiving new NFTs.
     * @param _quantity Number of NFTs to mint.
     * @param _nfts Array of old token IDs being migrated.
     * @return result Whether the minting succeeded.
     */
    function _mintNewNFT(
        address _nft1,
        address _nft2,
        address _user,
        uint _quantity,
        uint[] memory _nfts
    ) internal returns (bool result) {
        ICollectible nftObj = ICollectible(_nft2);
        nftObj.mintAsFreeMinter(_quantity);

        uint totalSupply = nftObj.totalSupply();
        uint quantityMinted;
        uint newLastMintedID;
        uint counter;

        for (uint index = lastAssetIdMinted[_nft2]; index < totalSupply; ++index) {
            if (nftObj.ownerOf(index) == address(this)) {
                nftObj.transferFrom(address(this), _user, index);
                newLastMintedID = index;
                emit NFTMigrationCompleted(_user, _nft1, _nft2, _nfts[counter], index, block.timestamp);
                ++counter;
                if (++quantityMinted >= _quantity) break;
            }
        }

        lastAssetIdMinted[_nft2] = newLastMintedID;
        return true;
    }

    /**
     * @notice Ensures the caller has the SIGNER_ROLE.
     */
    function _onlySigner() private view {
        if (!hasRole(SIGNER_ROLE, _msgSender())) revert TransactionMessage("Unauthorized");
    }
}
