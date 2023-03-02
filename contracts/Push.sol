// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/*
1.It should be an Upgradeable Smart Contract with ERC-1967 Transparent Upgradeable Proxy Pattern.

2.The smart contract should be capable of creating new channels from the contract itself, 
using the Push Core Contract on Goerli Testnet.

3. And lastly, the smart contract should also include a feature to 
emit out on-chain notifications using Push Communicator Contract on the Goerli testnet. */
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/// @title Push
/// @author Zartaj
/// @notice Simple contract to connected to push protocol for creating channels and sending notifications
/// @dev Using interfaces of ERC20, PUsh core conract and Push Communication contract to 
/// create channels and send notifications


contract Push is Initializable {

  event ChannelCreated(address indexed creator,uint indexed timestamp);  
  event NotificationSent(address indexed channel,uint indexed timestamp, string indexed notification);  

    IERC20 PUSH  ;
    IPUSHCore Core ;
    IPUSHCommInterface Comm ;
    bytes identity ;
    uint256 amount ;


    function initialize()  public initializer {
             PUSH = IERC20(0x2b9bE9259a4F5Ba6344c1b1c07911539642a2D33);
     Core = IPUSHCore(0xd4E3ceC407cD36d9e3767cD189ccCaFBF549202C);
     Comm =
        IPUSHCommInterface(0xb3971BCef2D791bc4027BbfedFb47319A4AAaaAa);
     identity =
        "0x312b516d5962773557707072426e687a66615559336d753271474d7632746f324448785734646f356174794a58475a6b";
     amount = 50 * 10**18;
    }

    function createChannel() external {
            PUSH.approve(address(Core),50* 10**18);

        Core.createChannelWithPUSH(
            IPUSHCore.ChannelType.InterestBearingOpen,
            identity,
            amount,
            0
        );
        emit ChannelCreated(msg.sender, block.timestamp);
    }

    function sendNotif(address channel, string memory _notif) external {
        IPUSHCommInterface(Comm).sendNotification(
            channel,
            address(this), 
            bytes(
                string(
                    abi.encodePacked(
                        "0", 
                        "+", 
                        "3", 
                        "+", 
                        "Testing Push", 
                        "+", 
                        _notif 
                    )
                )
            )
        );
        emit NotificationSent(channel, block.timestamp, _notif);
    }
}
interface IERC20{
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);

}

interface IPUSHCore {
    enum ChannelType {
        ProtocolNonInterest,
        ProtocolPromotion,
        InterestBearingOpen,
        InterestBearingMutual,
        TimeBound,
        TokenGaited
    }

    function createChannelWithPUSH(
        ChannelType _channelType,
        bytes calldata _identity,
        uint256 _amount,
        uint256 _channelExpiryTime
    ) external;
}

interface IPUSHCommInterface {
    function sendNotification(
        address _channel,
        address _recipient,
        bytes calldata _identity
    ) external;
}
