#!/usr/bin/env bash
set -e

while getopts v: flag
do
    case "${flag}" in
        v) version=${OPTARG};;
    esac
done

echo $version

./build.sh -c ./config/prod.json

rm -rf ./package
mkdir -p package

echo "{
  \"name\": \"@maplelabs/premium-calculator\",
  \"version\": \"${version}\",
  \"description\": \"Premium Calculator Artifacts and ABIs\",
  \"author\": \"Maple Labs\",
  \"license\": \"AGPLv3\",
  \"repository\": {
    \"type\": \"git\",
    \"url\": \"https://github.com/maple-labs/premium-calculator.git\"
  },
  \"bugs\": {
    \"url\": \"https://github.com/maple-labs/premium-calculator/issues\"
  },
  \"homepage\": \"https://github.com/maple-labs/premium-calculator\"
}" > package/package.json

mkdir -p package/artifacts
mkdir -p package/abis

cat ./out/dapp.sol.json | jq '.contracts | ."contracts/PremiumCalc.sol" | .PremiumCalc' > package/artifacts/PremiumCalc.json
cat ./out/dapp.sol.json | jq '.contracts | ."contracts/PremiumCalc.sol" | .PremiumCalc | .abi' > package/abis/PremiumCalc.json

npm publish ./package --access public

rm -rf ./package
