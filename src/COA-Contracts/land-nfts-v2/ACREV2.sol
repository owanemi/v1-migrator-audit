// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { ERC721A } from "./ERC721A.sol";
import { IERC20Upgradeable } from "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/IERC20Upgradeable.sol";
import { AccessControlUpgradeable } from "lib/openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol";

/**
 * @title PLOT
 * @notice ERC721A-based NFT contract with batch minting functionality and payment integration.
 * @dev Optimized for gas and secure against common vulnerabilities.
 */
contract ACREV2 is ERC721A, AccessControlUpgradeable {
    /*//////////////////////////////////////////////////////////////
                            TYPE DECLARATIONS
    //////////////////////////////////////////////////////////////*/
    struct Batch {
        uint256 price;
        uint256 quantity;
        uint256 startIndex;
        uint256 batchId; 
        bool active; 
    }

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    address public paymentToken;
    address public feeCollector;

    uint256 public txFeeAmount;
    uint256 public maxBuyAmount;
    uint256 public nextBatchId;

    Batch public currentBatch;

    string private baseUri;

    mapping(address => bool) public freeParticipantControllers;
    mapping(address => bool) public freeParticipants;
    mapping(uint256 => Batch) public allBatches;

    bytes32 public constant SIGNER_ROLE = keccak256("SIGNER_ROLE");

    /*//////////////////////////////////////////////////////////////
                            EVENTS
    //////////////////////////////////////////////////////////////*/
    event NewBatchCreated(uint256 indexed batchStartIndex);

    /*//////////////////////////////////////////////////////////////
                            ERRORS
    //////////////////////////////////////////////////////////////*/
    error Unauthorized();
    error InvalidParameter();
    error NoMoreTokensLeft();
    error CurrentBatchNotActive();
    error QuantityMustBeAboveZero();
    error MaxBuyAmountLimitReached();
    error PaymentFailed();

    /*//////////////////////////////////////////////////////////////
                            INITIALIZER
    //////////////////////////////////////////////////////////////*/
    function initialize(address _paymentToken) public initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        ERC721A.ERC721A_Initialize("EVT Acre", "aEVT");

        paymentToken = _paymentToken;
        feeCollector = _msgSender();
        txFeeAmount = 0;
        maxBuyAmount = 10;
    }

    /*//////////////////////////////////////////////////////////////
                      PUBLIC & EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function setBaseURI(string memory newUri) external {
        _onlySigner();
        baseUri = newUri;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721A, AccessControlUpgradeable)
        returns (bool)
    {
        return ERC721A.supportsInterface(interfaceId) || super.supportsInterface(interfaceId);
    }

    function mint(uint256 quantity) external {
        if (currentBatch.quantity == 0) revert NoMoreTokensLeft();
        if (!currentBatch.active) revert CurrentBatchNotActive();
        if (quantity == 0) revert QuantityMustBeAboveZero();

        address sender = _msgSender();
        if (quantity > maxBuyAmount && !hasRole(SIGNER_ROLE, sender)) revert MaxBuyAmountLimitReached();

        if (!freeParticipants[sender]) {
            if (!_pay(sender, quantity)) revert PaymentFailed();
        }

        currentBatch.quantity -= quantity;
        _safeMint(sender, quantity);
    }

    function setCurrentBatch(
        uint256 quantity,
        uint256 price,
        bool active
    ) external {
        _onlySigner();
        if (currentBatch.quantity > 0) revert CurrentBatchNotActive();

        uint256 batchId = nextBatchId++;
        Batch memory newBatch = Batch({
            quantity: quantity,
            price: price,
            startIndex: _currentIndex,
            batchId: batchId,
            active: active
        });

        currentBatch = newBatch;
        allBatches[batchId] = newBatch;

        emit NewBatchCreated(_currentIndex);
    }

    function setCurrentBatchActive(bool active) external {
        _onlySigner();
        currentBatch.active = active;
    }

    function setTxFee(uint256 amount) external {
        _onlySigner();
        txFeeAmount = amount;
    }

    function setPaymentToken(address _paymentToken) external {
        _onlySigner();
        paymentToken = _paymentToken;
    }

    function setFeeCollector(address collector) external {
        _onlySigner();
        feeCollector = collector;
    }

    function setFreeParticipant(address participant, bool isFree) external {
        _onlySigner();
        freeParticipants[participant] = isFree;
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL & PRIVATE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function _pay(address sender, uint256 quantity) private returns (bool) {
        IERC20Upgradeable token = IERC20Upgradeable(paymentToken);
        uint256 totalCost = currentBatch.price * quantity;
        return token.transferFrom(sender, feeCollector, totalCost);
    }

    function _onlySigner() private view {
        if (!hasRole(SIGNER_ROLE, _msgSender())) revert Unauthorized();
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri;
    }
}
