// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract Domains {

    struct Domain {
        string name;
        address owner;
        address resolver;
    }

    // Mappings
    mapping (string => Domain) public domains;
    mapping (string => string) public records;

    // Register a domain
    function register(string calldata name, address owner, address resolver) public {
        domains[name] = Domain(name, owner, resolver);
    }

    // Get a domain
    function get(string calldata name) public view returns (string memory, address, address) {
        Domain memory domain = domains[name];
        return (domain.name, domain.owner, domain.resolver);
    }

    // Set a record
    function setRecord(string calldata name, string calldata record) public {
        // Check that the owner is the transaction sender
        require(domains[name].owner == msg.sender);
        records[name] = record;
    }
}