function convertedValues = convtemp(valuesToConvert, ...
    inputTemperatureUnits, outputTemperatureUnits)
% CONVERTTEMP   Convert to desired temperature units
%   convertedValues =
%   convtemp(valuesToConvert,inputTemperatureUnits,outputTemperatureUnits)
%   computes the conversion factor from specified input temperature units
%   (inputTemperatureUnits) to specified output temperature units
%   (outputTemperatureUnits). The function then applies the conversion
%   factor to the valuesToConvert.
%
%   alternative implementation of Aerospace Toolbox function
arguments
    valuesToConvert double {mustBeReal, mustBeFinite}
    inputTemperatureUnits (1, 1) string ...
        {mustBeMember(inputTemperatureUnits, ["K", "C", "F", "R"])}
    outputTemperatureUnits (1, 1) string ...
        {mustBeMember(outputTemperatureUnits, ["K", "C", "F", "R"])}
end
% validation of valuesToConvert depends on inputTemperatureUnits
switch inputTemperatureUnits 
    case "C"
        mustBeGreaterThanOrEqual(valuesToConvert, -273.15);
    case "F"
        mustBeGreaterThanOrEqual(valuesToConvert, -459.67);
    otherwise % K or R, absolute units
        mustBeNonnegative(valuesToConvert);
end
% switch case on every permutation of temperature units
switch inputTemperatureUnits+outputTemperatureUnits
    case "KC"
        convertedValues = valuesToConvert - 273.15;
    case "KF"
        convertedValues = 1.8 * valuesToConvert - 459.67;
    case "KR"
        convertedValues = 1.8 * valuesToConvert;
    case "CK"
        convertedValues = valuesToConvert + 273.15;
    case "CF"
        convertedValues = 1.8 * valuesToConvert + 32;
    case "CR"
        convertedValues = 1.8 * valuesToConvert + 491.67;
    case "FK"
        convertedValues = (valuesToConvert + 459.67) / 1.8;
    case "FC"
        convertedValues = (valuesToConvert - 32) / 1.8;
    case "FR"
        convertedValues = valuesToConvert + 459.67;
    case "RK"
        convertedValues = valuesToConvert / 1.8;
    case "RC"
        convertedValues = valuesToConvert / 1.8 - 273.15;
    case "RF"
        convertedValues = valuesToConvert - 459.67;
    otherwise % same unit
        convertedValues = valuesToConvert;
end

