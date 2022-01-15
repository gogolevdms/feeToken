// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

/**
 * @title FeeToken.
 */
contract FeeToken is ERC20, Ownable {
    uint public fee = 25;
    uint public denom = 10000;

    address public wallet;

    event NewFee(uint oldFee, uint newFee);
    event NewWallet(address oldWallet, address newWallet);

    constructor(address account, address wallet_, string memory name_, string memory symbol_) ERC20(name_, symbol_) {
        wallet = wallet_;
        
        _mint(account, 12884901889e18);
        
        event NewWallet(address(0), wallet);
    }

    /// @notice The function sets the new fee percent.
    /// @param newFee_ The fee value.
    /// @return The bool value.
    function _setFee(uint newFee_) external onlyOwner returns (bool) {
        uint oldFee = fee;
        fee = newFee_;

        emit NewFee(oldFee, fee);

        return true;
    }

    /// @notice The function sets a new wallet.
    /// @param newWallet_ The new value to store.
    /// @return The bool value.
    function _setWallet(address newWallet_) external onlyOwner returns (bool) {
        address oldWallet = wallet;
        wallet = newWallet_;

        emit NewWallet(oldWallet, wallet);

        return true;
    }

    /// @notice The function transfers tokens including fee.
    /// @param sender The address of the token sender.
    /// @param recipient Address of the token recipient.
    /// @param amount Number of tokens to transfer.
    function _transfer(address sender, address recipient, uint amount) internal override {
        uint fee = amount * taxFee / denom;
        uint net = amount - fee;

        super._transfer(sender, recipient, net);
        super._transfer(sender, wallet, fee);
    }
}
