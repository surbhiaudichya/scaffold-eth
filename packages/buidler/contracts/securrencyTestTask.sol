// Copyright SECURRENCY INC.
// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

import "remix_tests.sol"; // this import is automatically injected by Remix.

/// File containe 3 smart contracts.
/// - TestTask for tasks solutions (2 task to be solved)
/// - Task1Test tests for task 1
/// - Task2Test tests for task 2

/// To check your's results, please deploy a smart contract with tests related to
/// to the task and run a functions. Each call will emit an event with test details.
/// To be sure that your solution work's properly, pay your attention to the
/// "passed" field in the log output, it must be equal to "true".
/// "passed": true - expected result for all tests.

/**
 * @author Surbhi Audichya 
 * @title Solidity test task
 */
contract TestTask {
    ///             ///
    ///    Task 1   ///
    ///             ///

    /**
     * @dev Test task condition:
     * @dev by a condition, a function getString accepts some template
     * @dev and we agreed that {account} in the template must be
     * @dev replaced by an "account" variable from the function,
     * @dev "{number}" must be replaced by a "number" variable
     * @dev Example
     * @dev template = "Example: {account}, {number}"
     * @dev result = "Example: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, 1250"
     *
     * @notice You can see more examples in a tests.
     * @notice Using subString, _toChecksumString, uintToString helper function
     * @notice resp. https://ethereum.stackexchange.com/questions/31457/substring-in-solidity,
     * @notice  https://ethereum.stackexchange.com/questions/63908/address-checksum-solidity-implementation,
     * @notice https://stackoverflow.com/questions/47129173/how-to-convert-uint-to-string-in-solidity,
     * @return result Updated template by a task condition
     */
    function buildStringByTemplate(string calldata template) external pure returns (string memory) {
        // 0x4549502d3535
        address account = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
        uint256 number = 1250;
        string memory result;

        bytes memory templateBytes = bytes(template);

        uint256 i;
        uint256 j;

        for (i = 0; i < templateBytes.length; i++) {
            
            if (templateBytes[i] == "{") {
                
                if (templateBytes[i + 1] == "a") {
                    
                    string memory subTemp = subString(template, j, i - 1);
                    string memory accountString = _toChecksumString(account);
                    result = string(abi.encodePacked(result, subTemp, " 0x", accountString));
                    while (templateBytes[i] != "}") {
                        i++;
                    }
                    
                    i++;
                    j = i;
                    
                } else if (templateBytes[i + 1] == "n") {
                    
                    string memory subTemp = subString(template, j, i - 1);
                    string memory numberString = uintToString(number);
                    result = string(abi.encodePacked(result, subTemp, " ", numberString));
                    
                    while (templateBytes[i] != "}") {
                        i++;
                    }
                    
                    i++;
                    j = i;
                }
            }
        }

        return (result);
    }


    ///             ///
    ///    Task 2   ///
    ///             ///

    /**
     * @dev Test task condition 2:
     *
     * @dev Write a function which takes an array of strings as input and outputs
     * @dev with one concatenated string. Function also should trim mirroring characters
     * @dev of each two consecutive array string elements. In two consecutive string elements
     * @dev "apple" and "electricity", mirroring characters are considered to be "le" and "el"
     * @dev and as a result these characters should be trimmed from both string elements,
     * @dev and concatenated string should be returned by the function. You may assume that
     * @dev array will consist of at least of one element, each element won't be an empty string.
     * @dev You may also assume that each element will contain only ascii characters.
     *
     * @dev Example 1
     * @dev input:  "apple", "electricity", "year"
     * @dev output: "appectricitear"
     * 
     * @param data array of strings 
     * @notice You can see more examples in a Task2Test smart contract.
     * @notice Using subString https://ethereum.stackexchange.com/questions/63908/address-checksum-solidity-implementation
     * @return result Minimized string by a task condition
     */
    function trimMirroringChars(string[] memory data) external pure returns (string memory) {
        string memory result;

        uint256 i;
        uint256 j;
        uint256 k;
        uint256 lenOne;
        uint256 lenTwo;
        uint256 len;
        result = data[0];
        
        for (i = 0; i < data.length - 1; i++) {
            
            bytes memory dataBytesOne = bytes(result);
            bytes memory dataBytesTwo = bytes(data[i + 1]);
            lenOne = dataBytesOne.length;
            lenTwo = dataBytesTwo.length;
            
            if (lenOne > lenTwo) 
               len = lenTwo;
            else 
               len = lenOne;

            for ((j = 0, k = lenOne - 1); j < len; ( j++, k-- )) {
                
                if (dataBytesTwo[j] == dataBytesOne[k]) {
                    
                } else 
                    break;
                
            }
            
            string memory subDataOne = subString(string(dataBytesOne), 0, k + 1);
            string memory subDataTwo = subString(string(dataBytesTwo), j, dataBytesTwo.length);

            result = string(abi.encodePacked(subDataOne, subDataTwo));
        }

        return result;
    }
    
     /**
     * @dev subString returns the sub part of a big string according to start and end index
     * @dev using helper functions _toChecksumCapsFlags, _toAsciiString
     * @param str the string 
     * @param startIndex sub string start index value 
     * @param endIndex sub string end index value 
     * 
     * @notice Using subString https://ethereum.stackexchange.com/questions/63908/address-checksum-solidity-implementation
     * @return result sub string
     */

    function subString(
        string memory str,
        uint256 startIndex,
        uint256 endIndex
    ) 
    internal pure returns (string memory) 
    {
        
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        
        for (uint256 i = startIndex; i < endIndex; i++) {
            
            result[i - startIndex] = strBytes[i];
            
        }
        return string(result);
    }
    
     /**
     * @dev _toChecksumString returns Checksum address string 
     *
     * @param account address 
     * @notice using https://ethereum.stackexchange.com/questions/63908/address-checksum-solidity-implementation,
     * @return asciiString sub string
     */

    function _toChecksumString(address account) internal pure returns (string memory asciiString) {
        // convert the account argument from address to bytes.
        bytes20 data = bytes20(account);

        // create an in-memory fixed-size bytes array.
        bytes memory asciiBytes = new bytes(40);

        // declare variable types.
        uint8 b;
        uint8 leftNibble;
        uint8 rightNibble;
        bool leftCaps;
        bool rightCaps;
        uint8 asciiOffset;

        // get the capitalized characters in the actual checksum.
        bool[40] memory caps = _toChecksumCapsFlags(account);

        // iterate over bytes, processing left and right nibble in each iteration.
        for (uint256 i = 0; i < data.length; i++) {
            // locate the byte and extract each nibble.
            b = uint8(uint160(data) / (2**(8 * (19 - i))));
            leftNibble = b / 16;
            rightNibble = b - 16 * leftNibble;

            // locate and extract each capitalization status.
            leftCaps = caps[2 * i];
            rightCaps = caps[2 * i + 1];

            // get the offset from nibble value to ascii character for left nibble.
            asciiOffset = _getAsciiOffset(leftNibble, leftCaps);

            // add the converted character to the byte array.
            asciiBytes[2 * i] = bytes1(leftNibble + asciiOffset);

            // get the offset from nibble value to ascii character for right nibble.
            asciiOffset = _getAsciiOffset(rightNibble, rightCaps);

            // add the converted character to the byte array.
            asciiBytes[2 * i + 1] = bytes1(rightNibble + asciiOffset);
        }

        return string(asciiBytes);
    }
    
     /**
     * @dev _toChecksumCapsFlags returns bool array of characterCapitalized
     * @dev this is a helper function to _toChecksumString
     * @param account address 
     * @notice using https://ethereum.stackexchange.com/questions/63908/address-checksum-solidity-implementation,
     * @return characterCapitalized array 
     */


    function _toChecksumCapsFlags(address account) internal pure returns (bool[40] memory characterCapitalized) {
        // convert the address to bytes.
        bytes20 a = bytes20(account);

        // hash the address (used to calculate checksum).
        bytes32 b = keccak256(abi.encodePacked(_toAsciiString(a)));

        // declare variable types.
        uint8 leftNibbleAddress;
        uint8 rightNibbleAddress;
        uint8 leftNibbleHash;
        uint8 rightNibbleHash;

        // iterate over bytes, processing left and right nibble in each iteration.
        for (uint256 i; i < a.length; i++) {
            // locate the byte and extract each nibble for the address and the hash.
            rightNibbleAddress = uint8(a[i]) % 16;
            leftNibbleAddress = (uint8(a[i]) - rightNibbleAddress) / 16;
            rightNibbleHash = uint8(b[i]) % 16;
            leftNibbleHash = (uint8(b[i]) - rightNibbleHash) / 16;

            characterCapitalized[2 * i] = (leftNibbleAddress > 9 && leftNibbleHash > 7);
            characterCapitalized[2 * i + 1] = (rightNibbleAddress > 9 && rightNibbleHash > 7);
        }
    }

     /**
     * @dev _toAsciiString returns asciiString
     * @dev this is a helper function to _toChecksumString
     * @param data bytes20  
     * @notice using https://ethereum.stackexchange.com/questions/63908/address-checksum-solidity-implementation,
     * @return asciiString string 
     */

    function _toAsciiString(bytes20 data) internal pure returns (string memory asciiString) {
        // create an in-memory fixed-size bytes array.
        bytes memory asciiBytes = new bytes(40);

        // declare variable types.
        uint8 b;
        uint8 leftNibble;
        uint8 rightNibble;

        // iterate over bytes, processing left and right nibble in each iteration.
        for (uint256 i = 0; i < data.length; i++) {
            // locate the byte and extract each nibble.
            b = uint8(uint160(data) / (2**(8 * (19 - i))));
            leftNibble = b / 16;
            rightNibble = b - 16 * leftNibble;

            // to convert to ascii characters, add 48 to 0-9 and 87 to a-f.
            asciiBytes[2 * i] = bytes1(leftNibble + (leftNibble < 10 ? 48 : 87));
            asciiBytes[2 * i + 1] = bytes1(rightNibble + (rightNibble < 10 ? 48 : 87));
        }

        return string(asciiBytes);
    }


    function _getAsciiOffset(uint8 nibble, bool caps) internal pure returns (uint8 offset) {
        // to convert to ascii characters, add 48 to 0-9, 55 to A-F, & 87 to a-f.
        if (nibble < 10) {
            offset = 48;
        } else if (caps) {
            offset = 55;
        } else {
            offset = 87;
        }
    }
    
     /**
     * @dev uintToString returns a string for given uint number  
     * @dev this is a helper function to buildStringByTemplate
     * @param num that needs to be converted to string   
     * @notice https://stackoverflow.com/questions/47129173/how-to-convert-uint-to-string-in-solidity,
     * @return str string of given number 
     */

    function uintToString(uint256 num) internal pure returns (string memory str) {
        uint256 maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint256 i = 0;
        
        while (num != 0) {
            
            uint256 remainder = num % 10;
            num = num / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
            
        }
        
        bytes memory s = new bytes(i);
        
        for (uint256 j = 0; j < i; j++) {
            
            s[j] = reversed[i - 1 - j];
        }
        str = string(s);
    }
}


/**
 * @title Task 1 tests
 *
 * @notice Designed for the remix IDE, please use it for tests.
 */
contract Task1Test {
    TestTask task;

    constructor() public {
        task = new TestTask();
    }

    /**
     * @dev Test task result
     * @dev template 1: "Result: {account}, {number}"
     *                  "Result: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, 1250"
     */
    function checkTemplate1() public {
        Assert.equal(
            task.buildStringByTemplate("Result: {account}, {number}"),
            "Result: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, 1250",
            "Result is equal to 'Result: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, 1250'"
        );
    }


    /**
     * @dev Test task result
     * @dev template 2: "number: {number}, account: {account}"
     * @dev             "number: 1250, account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c"
     */
    function checkTemplate2() public {
        Assert.equal(
            task.buildStringByTemplate("number: {number}, account: {account}"),
            "number: 1250, account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c",
            "Result is equal to 'number: 1250, account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c'"
        );
    }


    /**
     * @dev Test task result
     * @dev template 3: "number: {number}, number: {number}"
     * @dev             "number: 1250, number: 1250"
     */
    function checkTemplate3() public {
        Assert.equal(
            task.buildStringByTemplate("number: {number}, number: {number}"),
            "number: 1250, number: 1250",
            "Result is equal to 'number: 1250, number: 1250'"
        );
    }


    /**
     * @dev Test task result
     * @dev template 4: "account: {account}, account: {account}"
     * @dev             "account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c"
     */
    function checkTemplate4() public {
        Assert.equal(
            task.buildStringByTemplate("account: {account}, account: {account}"),
            "account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c",
            "Result is equal to 'account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c'"
        );
    }


    /**
     * @dev Test task result
     * @dev template 4: "account: {accountxyz}, number: {numberxyz}"
     * @dev             "account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, number: 1250"
     */
    function checkTemplate5() public {
        Assert.equal(
            task.buildStringByTemplate("account: {account}, number: {numberxyz}"),
            "account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, number: 1250",
            "Result is equal to 'account: 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, number: 1250'"
        );
    }
}


/**
 * @title Task 2 tests
 *
 * @notice Designed for the remix IDE, please use it for tests.
 */
contract Task2Test {
    TestTask task;

    constructor() public {
        task = new TestTask();
    }

    /**
     * @dev Test task result
     * @dev input ["apple", "electricity", "year"]
     * @dev output "appectricityear"
     */
    function checkCase1() public {
        string[] memory words = new string[](3);
        words[0] = "apple";
        words[1] = "electricity";
        words[2] = "year";

        Assert.equal(
            task.trimMirroringChars(words),
            "appectricitear",
            "Result is equal to 'appectricityear'"
        );
    }


    /**
     * @dev Test task result
     * @dev input ["ethereum", "museum", "must", "street"]
     * @dev output "etheresereet"
     */
    function checkCase2() public {
        string[] memory words = new string[](4);
        words[0] = "ethereum";
        words[1] = "museum";
        words[2] = "must";
        words[3] = "tree";

        Assert.equal(
            task.trimMirroringChars(words),
            "etheresesree",
            "Result is equal to 'etheresereet'"
        );
    }


    /**
     * @dev Test task result
     * @dev input ["aaaaapple","elppaaa","aapple"]
     * @dev output "pple"
     */
    function checkCase3() public {
        string[] memory words = new string[](4);
        words[0] = "aaaaapple";
        words[1] = "elppaaa";
        words[2] = "aapple";

        Assert.equal(
            task.trimMirroringChars(words),
            "etheresesree",
            "Result is equal to 'etheresereet'"
        );
    }
}
