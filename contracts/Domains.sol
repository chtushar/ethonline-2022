// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


import { StringUtils } from "./libraries/StringUtils.sol";
import {Base64} from "./libraries/Base64.sol";
import "hardhat/console.sol";

contract Domains is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address payable public owner;
    string public tld;
    struct Domain {
        string name;
        address owner;
        address resolver;
    }

    string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><text x="16" y="16" font-size="18" fill="#000">';
    string svgPartTwo = '</text></svg>';

    // Mappings
    mapping (string => Domain) public domains;
    mapping (string => string) public records;

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }


    constructor(string memory _tld) payable ERC721("Cross Name Service", "CNS") {
        owner = payable(msg.sender);
        tld = _tld;
        console.log("%s name service deployed", _tld);
    }

    function price(string calldata name) public pure returns(uint) {
        uint len = StringUtils.strlen(name);
        require(len > 0);
        if (len < 3) {
        return 5 * 10**14;
        } else if (len == 4) {
        return 3 * 10**14;
        } else {
        return 1 * 10**14;
        }
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to withdraw Matic");
    }

    // Register a domain
    function register(string calldata name, address owner, address resolver) public payable {
        require(domains[name].owner == address(0));

        uint256 _price = price(name);
        require(msg.value >= _price, "Not enough Matic paid");

        string memory _name = string(abi.encodePacked(name, ".", tld));
        string memory finalSvg = string(abi.encodePacked(svgPartOne, _name, svgPartTwo));
        uint256 newRecordId = _tokenIds.current();
        uint256 length = StringUtils.strlen(name);
        string memory strLen = Strings.toString(length);

        console.log("Registering %s.%s on the contract with tokenID %d", name, tld, newRecordId);

        // Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
        string memory json = Base64.encode(
        abi.encodePacked(
            '{"name": "',
            _name,
            '", "description": "A domain on the Ninja name service", "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(finalSvg)),
            '","length":"',
            strLen,
            '"}'
        )
        );

        string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));

        console.log("\n--------------------------------------------------------");
        console.log("Final tokenURI", finalTokenUri);
        console.log("--------------------------------------------------------\n");

        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        domains[name] = Domain(_name, owner, resolver);

        _tokenIds.increment();
        console.log("%s has registered a domain!", msg.sender);
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

    function getRecord(string calldata name) public view returns(string memory) {
      return records[name];
    }
}