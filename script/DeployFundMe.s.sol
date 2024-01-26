// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import{HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns(FundMe) {
        // لن يتم نشره على البلوكشاين  vm.startBroadcast() أي شيئ خارج 
        HelperConfig helperConfig = new HelperConfig(); 
        address ethPriceFeed = helperConfig.activeNework();
        vm.startBroadcast();
        //mock  عقود إخبتار
        FundMe fundMe = new FundMe(ethPriceFeed);
        vm.stopBroadcast();
        return(fundMe); 
    }
}
