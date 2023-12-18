// SPDX-License-Identifier: MIT
// ██████████╗  █████╗  ██╗     ██╗  █████╗   █████╗   █████╗
// ════██╔═══╝ ██╔══██║ ████  ████║ ██╔══██║ ██╔══██║ ██╔══██║
//     ██║     ██║  ██║ ██╔██ █╔██║ ██║  ██║ ██║  ══╝ ██║  ██║
//     ██║     ███████║ ██║ ██╔╝██║ ███████║ ██║ ███╗ ██║  ██║
//     ██║     ██╔══██║ ██║ ══╝ ██║ ██╔  ██║ ██║  ██║ ██║  ██║
//     ██║     ██║  ██║ ██║     ██║ ██║  ██║  ██████║  █████╔╝
//     ══╝     ══╝  ══╝ ══╝     ══╝ ══╝  ══╝  ══════╝  ═════╝
//   ███████╗██╗  ██╗ █████╗ ██╗     ███████╗
//   ██╔════╝██║  ██║██╔══██╗██║     ██╔════╝
//   ███████╗█████║  ███████║██║     █████╗  
//      ██╔═╝██╔══██║██╔══██║██║     ██╔══╝  
//   ███████║██║  ██║██║  ██║███████╗███████╗
//   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝

pragma solidity ^0.8.0;

// Interface for ERC20 token to interact with ERC20 compliant tokens.
interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

// TipContract: A contract for sending tips with an added tax to the owner.
contract TipContract {
    // Public state variables.
    IERC20 public token;  // Token contract interface.
    address public owner; // Owner of the contract.
    uint256 public taxPercentage = 3; // Initial tax percentage.
    uint256 private constant MAX_TAX_PERCENTAGE = 50; // Maximum tax percentage allowed.

    // Events to log significant state changes in the contract.
    event TipSent(address indexed sender, address indexed recipient, uint256 amount, uint256 tax);
    event TaxPercentageChanged(uint256 newTaxPercentage);
    event TokensWithdrawn(address tokenAddress, uint256 amount);

    // Constructor to initialize the contract with token address.
    constructor(address tokenAddress) {
        token = IERC20(tokenAddress); // Set the token for transactions.
        owner = msg.sender; // Set the contract deployer as the owner.
    }

    // Function to send a tip with added tax.
    function sendTip(address recipient, uint256 amount) external {
        uint256 tax = calculateTax(amount); // Calculate the tax amount.
        uint256 amountAfterTax = amount - tax; // Amount after deducting tax.
        address sender = msg.sender; // Cache msg.sender for optimization.

        // Ensure the sender has allowed the contract to spend the amount.
        require(token.allowance(sender, address(this)) >= amount, "Insufficient allowance");

        // Transfer tax to the owner and remaining amount to the recipient.
        require(token.transferFrom(sender, owner, tax), "Tax transfer failed");
        require(token.transferFrom(sender, recipient, amountAfterTax), "Tip transfer failed");

        // Emit an event for successful tip transaction.
        emit TipSent(sender, recipient, amountAfterTax, tax);
    }

    // Private function to calculate tax based on the provided amount.
    function calculateTax(uint256 amount) private view returns (uint256) {
        return (amount * taxPercentage) / 100; // Calculate and return tax.
    }

    // Function to set a new tax percentage. Only callable by the owner.
    function setTaxPercentage(uint256 newTaxPercentage) external {
        require(msg.sender == owner, "Only owner can change tax percentage");
        require(newTaxPercentage <= MAX_TAX_PERCENTAGE, "Tax percentage too high");
        taxPercentage = newTaxPercentage; // Update tax percentage.
        emit TaxPercentageChanged(newTaxPercentage); // Emit an event for tax change.
    }

    // Function for the owner to withdraw accumulated tokens.
    function withdrawTokens(address tokenAddress) external {
        require(msg.sender == owner, "Only owner can withdraw");
        IERC20 tokenToWithdraw = IERC20(tokenAddress);
        uint256 balance = tokenToWithdraw.balanceOf(address(this));
        require(balance > 0, "No tokens to withdraw");
        require(tokenToWithdraw.transfer(owner, balance), "Withdrawal failed");

        emit TokensWithdrawn(tokenAddress, balance); // Emit event on successful withdrawal.
    }
}