//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.4;

  import "./IWhitelist.sol";

  contract KleoverseNFTMint is ERC721Enumerable, Ownable {
      string _tokenURI;
      uint256 public _nftprice = 0.5 ether;
      bool public _contractpaused;
      uint256 public maxKlvrsTokenIds = 200;
      uint256 public klvrstokenIds;
      IWhitelist whitelist;
      bool public presaleKlvrsStarted;
      uint256 public presaleKlvrsEnded;


      modifier onlyWhenNotPaused {
          require(!_contractpaused, "Kleoverse Contract currently paused");
          _;
      }

      constructor (string memory baseURI, address whitelistContract) ERC721("Kleoverse Genesis Tokens", "KLVRS-GNS") {
          _tokenURI = baseURI;
          whitelist = IWhitelist(whitelistContract);
      }

      function startPresale() public onlyOwner {
          presaleKlvrsStarted = true;
          presaleKlvrsEnded = block.timestamp + 2 minutes;
      }

      function presaleMint() public payable onlyWhenNotPaused {
          require(presaleKlvrsStarted && block.timestamp < presaleKlvrsEnded, "Kleoverse Presale is not running");
          require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted in Kleoverse Domain for Presale Offer");
          require(klvrstokenIds < maxKlvrsTokenIds, "Exceeded maximum Kleverse Token supply");
          require(msg.value >= _nftprice, "Ether or Matic sent is not correct");
          klvrstokenIds += 1;
          _safeMint(msg.sender, klvrstokenIds);
      }

      function mint() public payable onlyWhenNotPaused {
          require(presaleKlvrsStarted && block.timestamp >=  presaleKlvrsEnded, "Kleoverse Presale has not ended yet");
          require(klvrstokenIds < maxKlvrsTokenIds, "Exceed maximum Kleoverse Token supply");
          require(msg.value >= _nftprice, "Ether or Matic sent is not correct");
          klvrstokenIds += 1;
          _safeMint(msg.sender, klvrstokenIds);
      }

      function _baseURI() internal view virtual override returns (string memory) {
          return _tokenURI;
      }

      function setPaused(bool val) public onlyOwner {
          _contractpaused = val;
      }

      function withdraw() public onlyOwner  {
          address _owner = owner();
          uint256 amount = address(this).balance;
          (bool sent, ) =  _owner.call{value: amount}("");
          require(sent, "Failed to send Ether or Matic");
      }

      receive() external payable {}

      fallback() external payable {}
  }
