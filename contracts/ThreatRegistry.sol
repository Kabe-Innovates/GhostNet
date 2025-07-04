// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ThreatRegistry {
    enum ThreatLevel { Safe, Suspicious, Malicious }

    struct ThreatInfo {
        ThreatLevel level;
        string explanation;
        address reporter;
        uint256 timestamp;
    }

    mapping(address => ThreatInfo) public threats;

    address public owner;

    event ThreatFlagged(
        address indexed contractAddress,
        ThreatLevel level,
        string explanation,
        address indexed reporter,
        uint256 timestamp
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function flagThreat(
        address contractAddress,
        ThreatLevel level,
        string calldata explanation
    ) external onlyOwner {
        threats[contractAddress] = ThreatInfo(
            level,
            explanation,
            msg.sender,
            block.timestamp
        );
        emit ThreatFlagged(
            contractAddress,
            level,
            explanation,
            msg.sender,
            block.timestamp
        );
    }

    function getThreat(address contractAddress) external view returns (
        ThreatLevel level,
        string memory explanation,
        address reporter,
        uint256 timestamp
    ) {
        ThreatInfo memory info = threats[contractAddress];
        return (info.level, info.explanation, info.reporter, info.timestamp);
    }
}