// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library GetConversion{
    //Eth سعر 
        function ethPrice( AggregatorV3Interface priceFeed) internal view returns(uint256) {
            // عنوان العقد
            // ABI

            // 0x694AA1769357215DE4FAC081bf1f309aDC325306

            (, int256 answer,,,) = priceFeed.latestRoundData();
            //2000.00000000  
            //1.000000000000000000
            // int256 > uint256 

            return uint256(answer * 1e10) ; 
   
        }

        // سعر تحويل الصرف
        function ethConversionRate(uint256 ethAmount , AggregatorV3Interface priceFeed) internal view returns(uint256) {
            
            uint256 getEthPrice = ethPrice(priceFeed);
            // 1000000000000000000 * 1000000000000000000 = 1000000000000000000
            uint256 ethAmountInUSD = (getEthPrice * ethAmount) / 1e18 ; 
            return ethAmountInUSD ; 
        } 



}