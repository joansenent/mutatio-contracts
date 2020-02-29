pragma solidity ^0.5.0;

//Import token contract
import "./MaybeDai.sol";

//Change contract name to Mutatio

contract Mutatio {
    // address public manager;
    // address payable players;
    address payable public owner = msg.sender; //Define a public owner variable. Set it to the creator of the contract when it is initialized.

    uint public orderId;

    struct Order {
        uint depositAmount;
        address buyerAddress;
        address targetToken;
        uint amountToken;
        address exchangeAddress;
        bool exchangeStarted;
    }

    mapping (uint => Order) orders;

    event LogExchangeEth(
        uint orderId,
        uint depositAmount,
        address buyerAddress,
        address targetToken,
        uint amountToken,
        bool exchangeStarted
    );

    modifier isNotStarted(uint orderId) {
        require(orders[orderId].exchangeStarted =! true);
        _;
    }
    modifier isAnExchange() {
        require(msg.sender == 0x4d6eC2391999Ff022A72614F7208D6cd42c34Ecc);
        _;
    }
    // modifier isTheRequiredAmount(uint orderId, address tokenTransaction) {
    //     // require(orders[orderId].amountToken * 0.998 =< tokenTransaction.amount) //we should be able to check the token contract
    //     // require(orders[orderId].targetToken == tokenTransaction.contract)
    // }

    function exchangeEth(address _tokenAddress, uint _amountToken)
        public
        payable
        returns(uint)
    {
        Order memory thisOrder;
        thisOrder.depositAmount = msg.value;
        thisOrder.buyerAddress = msg.sender;
        thisOrder.targetToken = _tokenAddress;
        thisOrder.amountToken = _amountToken;
        thisOrder.exchangeStarted = false;
        orderId = orderId + 1;
        orders[orderId] = thisOrder;
        emit LogExchangeEth(orderId, msg.value, msg.sender, _tokenAddress, _amountToken, false);
        return  orderId;
    }

    function exchangeStarted(uint orderId)
        public
        // isNotStarted(orderId)
        isAnExchange()
        returns(bool, address)
    {
        orders[orderId].exchangeStarted = true;
        orders[orderId].exchangeAddress = msg.sender;
        return (orders[orderId].exchangeStarted, orders[orderId].exchangeAddress);
    }

    function readOrder(uint orderId)
        public
        returns(
            uint depositAmount,
            address buyerAddress,
            address targetToken,
            uint amountToken,
            address exchangeAddress,
            bool exchangeStarted
        )
    {
        depositAmount = orders[orderId].depositAmount;
        buyerAddress = orders[orderId].buyerAddress;
        targetToken = orders[orderId].targetToken;
        amountToken = orders[orderId].amountToken;
        exchangeAddress = orders[orderId].exchangeAddress;
        exchangeStarted = orders[orderId].exchangeStarted;
        return(depositAmount, buyerAddress, targetToken, amountToken, exchangeAddress, exchangeStarted);
    }

    // function exchangeCompleted(uint orderId, address tokenTransaction)
    //     public
    //     payable
    //     isAnExchange()
    //     isTheRequiredAmount(orderId, tokenTransaction)
    //     // isNotUsedBefore() // the tansaction should not be alredy been used
    // {
    //     thisOrder = orders[orderId];
    //     thisOrder.exchangeAddress.transfer(thisOrder.depositAmount);
    //     // token.transferFrom(owner, thisOrder.buyerAddress, thisOrder.amountToken); //Needs to import the token contract
    // }

}