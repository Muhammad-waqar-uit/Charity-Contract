// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20, Ownable {
    constructor() ERC20("Token", "TKN") Ownable(msg.sender) {}

    /**
     * @dev Mint a token and assign it to the specified address.
     * @param to The address to which the token will be assigned.
     */
    function mintToken(address to) public {
        _mint(to, 1); // TODO :: 1 * 10 ** 18
    }

    /**
     * @dev Burns a specified amount of tokens from a given address.
     * @param from The address from which the tokens will be burned.
     * @param amount The amount of tokens to be burned.
     */
    function burnToken(address from, uint256 amount) external {
        _burn(from, amount);
    }
}