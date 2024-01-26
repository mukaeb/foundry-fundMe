// أن نتيح للمستخدمين أن يودعوا في العقد
// أن نتيح لصاحب العقد أنه يسحب الإيداعات
// فهو أن نضع حد أدنى للإيداعات

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {GetConversion} from "./GetConversion.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// 751,968
// 632,008

// constant
// immutable
// custom errors

error notOwner();

contract FundMe {
    using GetConversion for uint256;


    uint256 public constant MIN_VALUE_USD = 5e18;
    address[] private  s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;

   

    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeed ; 

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fundMe() public payable {
        // eth السماح للمستخدم بإرسال
        // eth وضع حد أدنى للـ
        require(
            msg.value.ethConversionRate(s_priceFeed) >= MIN_VALUE_USD,
            "Not Enough ETH"
        );
        // revert  ما هو
        // التراجع ، في جوهره ، يبطل الإجراءات السابقة ، ويعيد الغاز المتبقي المرتبط بتلك الصفقة
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }
    
    function cheapWithdraw() public onlyOwner {
        address[] memory funders = s_funders ; 

        for ( uint256 funderIndex = 0; funderIndex<funders.length; funderIndex++){
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);
        (bool successCall, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(successCall, "Call Failed");
    }

    function withdraw() public onlyOwner {
        //for loop
        // حلقة
        // [1,2,3] => [0,0,0]
        // [0,1,2] فهرس المصفوفة

        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        //transfer
        //msg.sender   address
        //msg.sender payable
        //    payable (msg.sender).transfer(address(this).balance);

        //     //send
        //     bool success = payable (msg.sender).send(address(this).balance);
        //     require(success, "Send Failed");

        //call
        (bool successCall, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(successCall, "Call Failed");
    }

    modifier onlyOwner() {
        //   require(msg.sender == i_owner , "you are not the owner");
        if (msg.sender != i_owner) revert notOwner();
        _;
    }

    //  هل هناك طريقة لحفظ حقوق الممولين اللي بيقوموا بإرسال الإيثر مباشرة بإستخدام عنوان العقد ؟
    // recive() fallback()

    receive() external payable {
        fundMe();
    }

    fallback() external payable {
        fundMe();
    }

    function getVersion() external view returns (uint256) {
        return s_priceFeed.version();
    }

    function getAddressToAmountFunded(address fundingAddress) external view returns(uint256){
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunders(uint256 index) external view returns(address){
        return s_funders[index];
    }

    function getOwner() external view returns(address){
        return i_owner;
    }

    function getPriceFeed() external view returns(AggregatorV3Interface){
        return s_priceFeed;
    }
}

// 1. Enum
// 2. Events
// 3. Try / Catch
// 4. Function Selector
// 5. abi.encode / decode
// 6. Hash with keccak256
// 7. Yul / Assembly
