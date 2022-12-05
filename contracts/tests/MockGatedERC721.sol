// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import {SismoGated} from '../core/libs/sismo-gated/SismoGated.sol';

contract MockGatedERC721 is ERC721, SismoGated {
  constructor(
    address badgesAddress,
    address attesterAddress,
    uint256 gatedBadge
  )
    ERC721('Sismo Gated NFT Contract', 'SGNFT')
    SismoGated(badgesAddress, attesterAddress, gatedBadge)
  {}

  function safeMint(
    address to,
    uint256 tokenId,
    bytes calldata data
  ) public onlyBadgesOwner(to, data) {
    _mint(to, tokenId);
  }

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  ) public override(ERC721) {
    proveWithSismo(data);
    _transfer(from, to, tokenId);
  }

  function _afterTokenTransfer(address, address to, uint256, uint256) internal override(ERC721) {
    uint256 nullifier = _getNulliferForAddress(to);
    _markNullifierAsUsed(nullifier);
  }
}