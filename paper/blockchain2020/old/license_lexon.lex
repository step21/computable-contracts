LEX Evaluation Licence.
LEXON: 0.2.12
COMMENT: A licensing contract for a software evaluation

TERMS:
"Licensee" is a person.
"Licensor" is a person.
"Licensing Fee" is an amount.
"Breach Fee" is an amount.
"Use" is a binary.
"Publish" is a binary.
"Comment" is a binary.
"License" is an asset.
"HasLicense" is a binary.
"IsCommissioned" is a binary.
The Licensor fixes the Licensing Fee,
appoints the Licensee,
and fixes the Breach Fee.
The Licensor certifies the License.

CLAUSE: Licensed.
Licensor fixes HasLicense as True.
Licensor fixes Use as True.
Licensor fixes Comment as True.
The Licensee pays a Licensing Fee to the Licensor.

CLAUSE: ObligationToPublish.
Licensor fixes IsCommissioned as True.

CLAUSE: BreachTerminate.
Licensor fixes Use as False.
Licensor fixes HasLicense as False.
Licensee pays Breach Fee to Licensor.