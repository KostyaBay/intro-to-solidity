// contracts/DuckToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// Token Design:
// 1)  initial supply (send to owner) = 70 000 000
// 2)  max supply (capped) = 100 000 000
// 3)  Make token burnable
// 4)  Create block reward to distribute new supply to miners - 
//          blockReward
//          _beforeTokenTransfer
//          _mintMinerReward

contract DuckToken is ERC20Capped, ERC20Burnable{
    address payable public owner;
    uint256 public blockReward;

    constructor(uint256 cap, uint256 reward) ERC20("DuckToken", "DCK") ERC20Capped(cap * (10 ** decimals())){
        owner = payable(msg.sender);
        _mint(owner, 70000000 * (10 ** decimals()));
        blockReward = reward * (10 ** decimals());
    }

    function _update(address from, address to, uint256 value) internal virtual override(ERC20Capped, ERC20) {
        super._update(from, to, value);

        if (from == address(0)) {
            uint256 maxSupply = cap();
            uint256 supply = totalSupply();
            if (supply > maxSupply) {
                revert ERC20ExceededCap(supply, maxSupply);
            }
        }
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual { // override?
        if(from != address(0) && to != block.coinbase && block.coinbase != address(0)) {
            _mintMinerReward();
            }
        _beforeTokenTransfer(from, to, value);
    }

    function setBlockReward(uint256 reward) public onlyOwner{
        blockReward = reward * (10 ** decimals());
    }

    function destroy() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}