### 2. Authorization Controls Fix
**Issue**: Incorrect permission management for free participant controllers
**Implementation**:
```solidity
function setFreeParticipant(address participant, bool free) external {
    require(
        freeParticipantControllers[msg.sender] || msg.sender == owner(),
        "Not authorized"
    );
    require(participant != address(0), "Invalid participant address");
    freeParticipant[participant] = free;
    emit FreeParticipantUpdated(participant, free);
}
```

### 3. Payment Validation Enhancement
**Issue**: Inadequate payment validation in `_pay()` function
**Implementation**:
```solidity
function _pay(address payee, uint256 quantity) internal returns (bool) {
    IERC20Upgradeable token = IERC20Upgradeable(_paymentToken);
    bool success = token.transferFrom(
        payee,
        _feeCollector,
        _currentBatch.price * quantity
    );
    require(success, "Payment failed");
    return success;
}
```

```solidity
// 1. Use memory for struct updates
function updateBatch(uint256 quantity) internal {
    Batch memory batch = _currentBatch;
    batch.quantity -= quantity;
    _currentBatch = batch;
}