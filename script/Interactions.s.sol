// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";


contract FundFundMe is Script {

    uint256 SEND_VALUE = 0.1 ether ; 

    function fundFundMe(address mostRecentAddress) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentAddress)).fundMe{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with ", SEND_VALUE);
    }

    function run() external {
        address mostRececentAddress = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRececentAddress);
    }
}

contract WithdrawFundMe is Script {

    function withdrawFundMe(address mostRecentAddress) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentAddress)).withdraw();
        vm.stopBroadcast();
        console.log("withdrw FundMe successfully ");
    }

    function run() external {
        address mostRececentAddress = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRececentAddress);
    }
}