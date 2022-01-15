// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

/**
 * @title FeeToken.
 */

contract FeeToken is ERC20, Ownable {
    uint public taxFee = 25;
    uint public denom = 10000;

    address public wallet;

    event SetFee(uint _oldFee, uint _newFee);
    event SetWallet(address _oldWallet, address _newWallet);

    constructor(address account, string memory name_, string memory symbol_) ERC20(name_, symbol_) {
        _mint(account, 12884901889e18);
    }

    /// @notice The function sets the new tax amount.
    /// @dev Stores the unsigned int value in the state variable 'taxFee'.
    /// @param _taxFee The new value to store.
    /// @return The bool value.
    function _setFee(uint _taxFee) external onlyOwner returns (bool) {
        taxFee = _taxFee;

        emit SetFee(taxFee, _taxFee);

        return true;
    }

    /// @notice The function sets a new wallet.
    /// @dev Stores the address value in the state variable 'wallet'.
    /// @param _wallet The new value to store.
    /// @return The bool value.
    function _setWallet(address _wallet) external onlyOwner returns (bool) {
        wallet = _wallet;

        emit SetWallet(wallet, _wallet);

        return true;
    }

    /// @notice The function transfers tokens.
    /// @param sender The address of the token sender.
    /// @param recipient Address of the token recipient.
    /// @param amount Number of tokens to transfer.
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        uint256 fee = amount * taxFee / denom;
        uint256 net = amount - fee;

        super._transfer(sender, recipient, net);
        super._transfer(sender, wallet, fee);
    }
}