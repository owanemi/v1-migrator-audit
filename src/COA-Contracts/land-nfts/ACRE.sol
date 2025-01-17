// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {ERC721A} from "./ERC721A.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/**
 * @title ATLACRE
 * @notice A token minting contract with batch-based pricing and payment handling.
 */
contract ATLACRE is ERC721A, Ownable {
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
    address public _paymentToken; // ERC20 token for payments
    address public _feeCollector; // Address to collect minting fees

    uint256 public _txFeeAmount; // Transaction fee in payment token
    uint256 public _maxBuyAmount; // Maximum tokens a user can mint in a single transaction

    mapping(address => bool) public freeParticipantControllers;
    mapping(address => bool) public freeParticipants;

    string private baseUri =
        "https://sidekickfinance.mypinata.cloud/ipfs/QmR3JYjc8bjvjpuwJhWN38DSKZSLA9ydU67CoddWuo89J8";

    /*////////////////////////////////////////////////////////////
                           CONSTRUCTOR
    /////////////////////////////////////////////////////////////*/
    /**
     * @dev Sets initial configuration for the contract.
     * @param paymentToken Address of the ERC20 token used for payments.
     */
    constructor(address paymentToken) ERC721A("ATL Acre", "aATL") {
        _paymentToken = paymentToken;
        _feeCollector = msg.sender;
        _txFeeAmount = 0;
        _maxBuyAmount = 10;
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
        require(quantity <= _maxBuyAmount || msg.sender == owner(), "Exceeds max buy limit");

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
        _txFeeAmount = amount;
    }

    /**
     * @notice Update the payment token address.
     * @param token The new payment token address.
     */
    function setPaymentToken(address token) external onlyOwner {
        require(token != address(0), "Invalid token address");
        _paymentToken = token;
    }

    /**
     * @notice Update the base URI for token metadata.
     * @param newUri The new base URI.
     */
    function setBaseURI(string memory newUri) external onlyOwner {
        baseUri = newUri;
    }

    /**
     * @notice Update the fee collector address.
     * @param collector The new fee collector address.
     */
    function setFeeCollector(address collector) external onlyOwner {
        require(collector != address(0), "Invalid address");
        _feeCollector = collector;
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
        require(freeParticipantControllers[msg.sender] || msg.sender == owner(), "Not authorized");
        freeParticipants[participant] = free;
    }

    /*//////////////////////////////////////////////////////////////
                   INTERNAL & PRIVATE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev Handles payment for token minting.
     * @param payer The address paying the minting fee.
     * @param quantity The number of tokens being minted.
     * @return success True if the payment succeeds.
     */
    function _pay(address payer, uint256 quantity) internal returns (bool) {
        IERC20 token = IERC20(_paymentToken);
        return token.transferFrom(payer, _feeCollector, _currentBatch.price * quantity);
    }

    /**
     * @dev Returns the base URI for token metadata.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }
}
