// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721A} from "./ERC721A.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/**
 * @title ATLYARD
 * @notice A token minting contract with batch-based pricing and payment handling.
 */
contract ATLYARD is ERC721A, Ownable {
    /*////////////////////////////////////////////////////////////
                           EVENTS
    ////////////////////////////////////////////////////////////*/
    event NewBatchCreated(uint256 batchStartIndex);

    /*//////////////////////////////////////////////////////////////
                                STRUCTS
    //////////////////////////////////////////////////////////////*/
    struct Batch {
        uint256 quantity; // Remaining tokens in the batch
        uint256 price; // Price per token in payment token
        bool active; // Whether the batch is active for minting
    }

    /*///////////////////////////////////////////////////////////
                           STATE VARIABLES
    ////////////////////////////////////////////////////////////*/
    Batch public _currentBatch;
    address public paymentToken; // ERC20 token for payments
    address public feeCollector; // Address to collect minting fees

    uint256 public txFeeAmount; // Transaction fee in payment token
    uint256 public maxBuyAmount; // Maximum tokens a user can mint in a single transaction

    string private baseUri =
        "https://sidekickfinance.mypinata.cloud/ipfs/QmVRVjmmK5bDJdpSXAyZ4iqQsR5q7w4tyDPTqhV21UiYTM";

    mapping(address => bool) public freeParticipantControllers;
    mapping(address => bool) public freeParticipants;

    /*////////////////////////////////////////////////////////////
                           CONSTRUCTOR
    /////////////////////////////////////////////////////////////*/
    /**
     * @dev Sets initial configuration for the contract.
     * @param _paymentToken Address of the ERC20 token used for payments.
     */
    constructor(address _paymentToken) ERC721A("ATL Yard", "yATL") {
        require(_paymentToken != address(0), "Invalid payment token address");
        paymentToken = _paymentToken;
        feeCollector = msg.sender;
        txFeeAmount = 0;
        maxBuyAmount = 10;
    }

    /*//////////////////////////////////////////////////////////////
                      EXTERNAL & PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /**
     * @notice Mint tokens from the current batch.
     * @param quantity Number of tokens to mint.
     */
    function mint(uint256 quantity) external {
        Batch memory batch = _currentBatch; // Load batch data into memory for gas efficiency

        require(batch.quantity > 0, "No tokens left in batch");
        require(batch.active, "Current Batch is not active");
        require(quantity > 0, "Quantity must be greater than zero");
        require(quantity <= maxBuyAmount || msg.sender == owner(), "Exceeds max buy limit");

        // Update remaining quantity
        _currentBatch.quantity -= quantity;

        if (!freeParticipants[msg.sender]) {
            require(_pay(msg.sender, quantity), "Payment failed");
        }

        // Mint tokens
        _safeMint(msg.sender, quantity);
    }

    /**
     * @notice Configure a new batch for minting.
     * @param quantity Number of tokens in the batch.
     * @param price Price per token in payment token.
     * @param active Whether the batch is active.
     */
    function setCurrentBatch(uint256 quantity, uint256 price, bool active) external onlyOwner {
        require(_currentBatch.quantity == 0, "Current batch not finished");

        _currentBatch = Batch({quantity: quantity, price: price, active: active});

        emit NewBatchCreated(_currentIndex);
    }

    /**
     * @notice Update the base URI for token metadata.
     * @param newUri The new base URI.
     */
    function setBaseURI(string calldata newUri) external onlyOwner {
        baseUri = newUri;
    }

    /**
     * @notice Set the active status of the current batch.
     * @param active The new active status.
     */
    function setCurrentBatchActive(bool active) external onlyOwner {
        _currentBatch.active = active;
    }

    /**
     * @notice Update the transaction fee.
     * @param amount The new transaction fee.
     */
    function setTxFee(uint256 amount) external onlyOwner {
        txFeeAmount = amount;
    }

    /**
     * @notice Update the payment token address.
     * @param token The new payment token address.
     */
    function setPaymentToken(address token) public onlyOwner {
        require(token != address(0), "Invalid address");
        paymentToken = token;
    }

    /**
     * @notice Update the fee collector address.
     * @param collector The new fee collector address.
     */
    function setFeeCollector(address collector) external onlyOwner {
        require(collector != address(0), "Invalid address");
        feeCollector = collector;
    }

    /**
     * @notice Add or remove a free participant controller.
     * @param controller The controller address.
     * @param allow Whether the controller is allowed.
     */
    function setFreeParticipantController(address controller, bool allow) external onlyOwner {
        freeParticipantControllers[controller] = allow;
    }

    /**
     * @notice Add or remove a free participant.
     * @param participant The participant address.
     * @param free Whether the participant is free.
     */
    function setFreeParticipant(address participant, bool free) external {
        require(msg.sender == owner() || freeParticipantControllers[msg.sender], "not authorized");
        freeParticipants[participant] = free;
    }

    /*/////////////////////////////////////////////////////////////
                      INTERNAL & PRIVATE FUNCTIONS
    /////////////////////////////////////////////////////////////*/
    /**
     * @dev Handles payment for token minting.
     * @param payer The address paying the minting fee.
     * @param quantity The total amount to be paid.
     * @return success True if the payment succeeds.
     */
    function _pay(address payer, uint256 quantity) internal returns (bool success) {
        IERC20 token = IERC20(paymentToken);
        return token.transferFrom(payer, feeCollector, _currentBatch.price * quantity);
    }

    /**
     * @dev Returns the base URI for token metadata.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }
}
