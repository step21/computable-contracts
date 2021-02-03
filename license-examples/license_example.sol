// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
//import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol";
import "github.com/step21/BokkyPooBahsDateTimeLibrary/contracts/BokkyPooBahsDateTimeLibrary.sol";
/// @title A license evaluation system
/// @author Florian Idelberger
/// @notice 
/// @dev 

// first include all values in struct - then put into list and eval etc with functions

contract LicenseContract {
    // which differentation between licenseContract and LicenseProps
    //using EnumerableMap for EnumerableMap.UintToAddressMap;
    bytes32 public work_hash; string public name;
    address payable public licensor;
    address public licensee;   
    //  EnumerableMap.UintToAddressMap sublicensees;
    address payable public arbiter;
    bool breachFeePaid;
    int startdate;
    int enddate;
    
event Status(LicenseProps);
    
struct LicenseProps {
    int id;
    int licenseTerm;
    int licenseFee;
    uint breachFee;
    bool isCommissioned;
    bool publicationIsApproved;
    bool requiresComments;
    uint timeToRemove;
    bool triggeredTimeToRemove;
    bool licenseBreached;}

mapping (uint => LicenseProps) licenses;
uint[] public licensesList;
uint numLicenses;
//EnumerableMap.UintToAddressMap memory _sublicensees,
modifier onlyBy(address _account)
    {require(msg.sender == _account,
          "Sender not authorized.");
        _;}

/// @notice Create a new license and add it to the mapping of licenses.
/// @dev T
/// @param _id, _licenseFee, _breachFee, _isCommissioned, _publicationIsApproved, _requiresComments, _timeToRemove, _triggeredTimeToRemove, _licenseBreached
/// @return licenseID of the created license.
function newLicense(int _id, int _licenseTerm, int _licenseFee, uint _breachFee, bool _isCommissioned, bool _publicationIsApproved, bool _requiresComments, uint _timeToRemove, bool _triggeredTimeToRemove, bool _licenseBreached) public onlyBy(licensor) returns (uint licenseID) {
        licenses[licenseID] = LicenseProps(_id, _licenseTerm, _licenseFee, _breachFee, _isCommissioned, _publicationIsApproved, _requiresComments, _timeToRemove, _triggeredTimeToRemove, _licenseBreached);
        licenseID = numLicenses++;
        // sublicensees = _sublicensees;
        return licenseID; }

/// @notice 
/// @dev 
/// @param _licenseID of the license to be modified
function commissionComments(uint _licenseID) public onlyBy(licensor) {
    LicenseProps storage l = licenses[_licenseID];
    l.publicationIsApproved = true;
    l.requiresComments = true;
    l.isCommissioned = true; }

/// @notice 
/// @dev 
/// @param _licenseID of the license to be modified
function grantApproval(uint _licenseID) public onlyBy(licensor) {
    LicenseProps storage l = licenses[_licenseID];
    l.publicationIsApproved = true; }

/// @notice 
/// @dev 
/// @param _licenseID of the license to be modified
function evalPublication(uint _licenseID, bool isPublished) public {
    LicenseProps storage l = licenses[_licenseID];
    if (isPublished) {
        if ((isPublished && !l.isCommissioned || !l.publicationIsApproved) && !l.triggeredTimeToRemove) {
            l.timeToRemove = block.timestamp;
            l.triggeredTimeToRemove = true;
        } else if (l.triggeredTimeToRemove && block.timestamp > l.timeToRemove + 1 days ) {
            declareBreach(_licenseID);
        }    }
    emit Status(l); }

/// @notice 
/// @dev 
/// @param _licenseID of the license to be modified
function declareRemoved(uint _licenseID) public onlyBy(arbiter) {
    LicenseProps storage l = licenses[_licenseID];
    l.timeToRemove = 0;
    l.triggeredTimeToRemove = false;
}

/// @notice 
/// @dev 
/// @param _licenseID of the license to be modified
function declareBreach(uint _licenseID) public onlyBy(arbiter) {
    LicenseProps storage l = licenses[_licenseID];
    l.licenseBreached = true;
    if (!breachFeePaid) {
        breachFeePaid = false;
        licensor.transfer(l.breachFee);
        }     } }
