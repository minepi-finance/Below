// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.20;

import "@zama.ai/fhevm@0.5.0/lib/TFHE.sol";

contract Voting {
    // Encrypted vote counts for "Yes" and "No"
    euint32 public yesCount;
    euint32 public noCount;
    address public owner;

    // Key Management System address for decryption
    address public kms;

    constructor(address _kms) {
        yesCount = TFHE.asEuint32(0);
        noCount = TFHE.asEuint32(0);
        owner = msg.sender;
        kms = _kms;
    }

    // Cast an encrypted vote
    function castVote(bytes calldata encryptedVote, bool voteForYes) public {
        euint32 vote = TFHE.asEuint32(encryptedVote);
        if (voteForYes) {
            yesCount = TFHE.add(yesCount, vote);
        } else {
            noCount = TFHE.add(noCount, vote);
        }
    }

    // Get encrypted vote counts (returns ciphertext)
    function getVoteCounts() public view returns (bytes memory, bytes memory) {
        return (TFHE.decrypt(yesCount, kms), TFHE.decrypt(noCount, kms));
    }

    // Decrypt results (only callable by owner)
    function revealResults() public view onlyOwner returns (uint32, uint32) {
        return (TFHE.decrypt(yesCount), TFHE.decrypt(noCount));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }
}
