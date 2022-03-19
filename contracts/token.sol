// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract BoredAirDrop is ERC20 {
    struct AddressAirdrop {
        address claimerAdress;
        uint256 amount;
        bool claimStatus;
    }

    constructor() ERC20("BoredAirDrop", "BAD") {}

    bytes32 public merkleRoot =
        0x59f80cbd86ae5f783775e0cd9e3847ec5d7c6d35252fd8a7709efeb538119f1f;

    mapping(address => AddressAirdrop) addressAirdrops;
    event claimAirdrop(address owner, uint256 amount);

    function claimAirDrop(
        bytes32[] calldata _merkleProof,
        uint256 _itemid,
        uint256 _amount,
        address _address
    ) public {
        AddressAirdrop storage airdrop = addressAirdrops[_address];
        require(!airdrop.claimStatus, "Address has been claimed");

        bytes32 leaf = keccak256(abi.encodePacked(_address, _itemid, _amount));
        require(
            MerkleProof.verify(_merkleProof, merkleRoot, leaf),
            "Incorrect proof"
        );
        _mint(_address, _amount);
        emit claimAirdrop(_address, _amount);
    }

    function getStatus(address _address) public view returns (bool) {
        AddressAirdrop storage airdrop = addressAirdrops[_address];
        return (airdrop.claimStatus);
    }
}
