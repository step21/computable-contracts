pragma solidity ^0.4.19;
contract license {
address author; address licensee;
bytes32 work_hash; string name;
bool hasLicense;
bool use; bool perm_use;
bool forb_use;
bool publish; bool perm_publish;
bool forb_publish; bool obl_publish;
bool comment; bool perm_comment;
bool forb_comment;
bool hasApproval;
bool isCommissioned;
bool remove; bool obl_remove;
bool violation;
// Constructor of the contract.
// Relevant setter and getter functions.
// Relevant 'actuator' functions.
function evaluateLicenseContract () \
    public returns (int) {
    if(hasLicense){
        forb_use = false;
        perm_use = true; } // Art 1
if(hasLicense && (hasApproval || \ 
    isCommissioned)){
    forb_publish = false;
    perm_publish = true; } // Art 2, 4
if(hasLicense && !hasApproval &&! \
    isCommissioned && publish){
    obl_remove = true; } // Art 2
if(perm_publish){
    forb_comment = false;
    perm_comment = true; } // Art 3
if(hasLicense && isCommissioned){
    forb_publish = false;
    perm_publish = true;
    obl_publish = true; } // Art 4
if(forb_use && use ||
    forb_publish && publish ||
    obl_publish && !publish && !remove ||
    forb_comment && comment ||
    obl_remove && !remove) {
    violation = true; }
if(violation){
    forb_use = true;
    forb_publish = true;
    forb_comment = true;
    perm_use = false;
    perm_publish = false;
    perm_comment = false;
    obl_publish = false; } // Art 5
} }
