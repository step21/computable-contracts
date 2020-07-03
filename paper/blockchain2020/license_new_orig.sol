pragma solidity ^0.6.7;
pragma experimental ABIEncoderV2;

contract LicenseContract {
    bytes32 work_hash; string name; address payable licensor; address licensee;	address payable arbiter; bool breachFeePaid;
    
event Status(LicenseProps);
    
struct LicenseProps {
    int id; int licenseFee; uint breachFee; boool isCommissioned; bool publicationIsApproved; bool requiresComments; uint timeToRemove; bool triggeredTimeToRemove; bool licenseBreached;}

mapping (uint => LicenseProps) licenses;
uint[] public licensesList;
uint numLicenses;
modifier onlyBy(address _account)
    {require(msg.sender == _account,
          "Sender not authorized."); _;}

function newLicense(int _id, int _licenseFee, uint _breachFee, bool _isCommissioned, bool _publicationIsApproved, bool _requiresComments, uint _timeToRemove, bool _triggeredTimeToRemove, bool _licenseBreached) public returns (uint licenseID) {
        licenses[licenseID] = LicenseProps(_id, _licenseFee, _breachFee, _isCommissioned, _publicationIsApproved, _requiresComments, _timeToRemove, _triggeredTimeToRemove, _licenseBreached);
        licenseID = numLicenses++;
        return licenseID; }

function commissionComments(uint _licenseID) public {
    LicenseProps storage l = licenses[_licenseID];
    l.publicationIsApproved = true;
    l.requiresComments = true;
	l.isCommissioned = true; }

function grantApproval(uint _licenseID) public {
    LicenseProps storage l = licenses[_licenseID];
    l.publicationIsApproved = true; }

function evalPublication(uint _licenseID, bool isPublished) public {
    LicenseProps storage l = licenses[_licenseID];
    if (isPublished) {
        if ((isPublished && !l.isCommissioned || !l.publicationIsApproved) && !l.triggeredTimeToRemove) {
            l.timeToRemove = now;
            l.triggeredTimeToRemove = true;
        } else if (l.triggeredTimeToRemove && now > l.timeToRemove + 1 days ) {
            declareBreach(_licenseID);
        }    }
    emit Status(l); }

function declareRemoved(uint _licenseID) public onlyBy(arbiter) {
    LicenseProps storage l = licenses[_licenseID];
    l.timeToRemove = 0;
    l.triggeredTimeToRemove = false; }

function declareBreach(uint _licenseID) public onlyBy(arbiter) {
    LicenseProps storage l = licenses[_licenseID];
	l.licenseBreached = true;
	if (!breachFeePaid) {
	    breachFeePaid = false;
	    licensor.transfer(l.breachFee);
	    }     } }